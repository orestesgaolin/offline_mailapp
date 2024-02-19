import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mailapp/ai/ai.dart';
import 'package:mailapp/database.dart';
import 'package:mailapp/list/list.dart';
import 'package:mailapp/main_view/main_page.dart';
import 'package:mailapp/main_view/main_view.dart';
import 'package:mailapp/sender/sender_cubit.dart';
import 'package:mailapp/storage.dart';
import 'package:mailapp/synchronization/bloc/sync_bloc.dart';
import 'package:mailapp/synchronization/synchronization.dart';
import 'package:provider/provider.dart';

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = AppDatabase();

  if (!kIsWeb) {
    if (Platform.isMacOS) {
      await _configureMacosWindowUtils();
    }
  }

  runApp(MailApp(storage: storage));
}

class MailApp extends StatelessWidget {
  const MailApp({
    super.key,
    required this.storage,
  });

  final Storage storage;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: storage,
      child: ChangeNotifierProvider(
        create: (_) => AppTheme(),
        builder: (context, _) {
          final appTheme = context.watch<AppTheme>();
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => SyncBloc(storage),
                lazy: false,
              ),
              BlocProvider(
                create: (context) => EmailsListCubit(storage),
              ),
              BlocProvider(
                create: (context) => LayoutCubit(storage),
              ),
              BlocProvider(
                create: (context) => EmailSenderCubit(storage),
              ),
            ],
            child: MacosApp(
              title: 'Mail App',
              theme: MacosThemeData.light(),
              darkTheme: MacosThemeData.dark(),
              themeMode: appTheme.mode,
              debugShowCheckedModeBanner: false,
              home: const MainScreen(),
            ),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MainPageMode mode = MainPageMode.all;

  late final searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const menus = [
      PlatformMenu(
        label: 'Mail App',
        menus: [
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.about,
          ),
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.quit,
          ),
        ],
      ),
      PlatformMenu(
        label: 'View',
        menus: [
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.toggleFullScreen,
          ),
        ],
      ),
      PlatformMenu(
        label: 'Window',
        menus: [
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.minimizeWindow,
          ),
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.zoomWindow,
          ),
        ],
      ),
    ];

    return PlatformMenuBar(
      menus: menus,
      child: MacosWindow(
        sidebar: Sidebar(
          minWidth: 200,
          builder: (context, scrollController) {
            return SidebarItems(
              currentIndex: mode.index,
              onChanged: (i) {
                setState(() {
                  mode = MainPageMode.values[i];
                });
              },
              scrollController: scrollController,
              itemSize: SidebarItemSize.large,
              items: const [
                SidebarItem(
                  label: Text('All'),
                ),
                SidebarItem(
                  label: Text('Inbox'),
                ),
                SidebarItem(
                  label: Text('Sent & Outgoing'),
                ),
                SidebarItem(
                  label: Text('Tasks'),
                ),
              ],
            );
          },
          bottom: Column(
            children: [
              const Text(
                'Built with macos_ui, super_editor, and drift',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              Divider(
                color: MacosTheme.of(context).dividerColor,
              ),
              const MacosListTile(
                leading: MacosIcon(CupertinoIcons.profile_circled),
                title: Text('Dom Flutter'),
                subtitle: Text('dominik@roszkowski.dev'),
              ),
            ],
          ),
        ),
        endSidebar: Sidebar(
          startWidth: 200,
          minWidth: 200,
          maxWidth: 300,
          shownByDefault: false,
          builder: (context, _) {
            return const Center(
              child: Text('End Sidebar'),
            );
          },
        ),
        child: switch (mode) {
          MainPageMode.synchronizationTasks =>
            const SyncTasksView(scrollController: null),
          _ => MainPage(mode: mode)
        },
      ),
    );
  }
}

class AppTheme extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  set mode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }
}
