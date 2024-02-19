import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mailapp/clock/clock.dart';
import 'package:mailapp/editor/editor.dart';
import 'package:mailapp/list/list.dart';
import 'package:mailapp/main_view/main_view.dart';
import 'package:mailapp/mock_email/mock_email_button.dart';
import 'package:mailapp/model.dart';
import 'package:mailapp/reader/email_reader_view.dart';
import 'package:mailapp/reader/reader.dart';
import 'package:mailapp/sender/sender_cubit.dart';
import 'package:mailapp/storage.dart';
import 'package:mailapp/synchronization/synchronization.dart';

enum MainPageMode {
  all,
  inbox,
  outgoing,
  synchronizationTasks,
}

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    required this.mode,
  });

  final MainPageMode mode;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final layoutState = context.watch<LayoutCubit>().state;

    void onSend(Email email) {
      // TODO(dominik): 1. Send via EmailSenderCubit and LayoutCubit
    }

    void onEdit(Email email) {
      context.read<LayoutCubit>().editDocument(email);
    }

    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Mail App Example'),
        titleWidth: 250.0,
        leading: const SidebarTooltip(),
        actions: [
          if (layoutState is PreviewState || layoutState is InitialState)
            ToolBarIconButton(
              label: 'New',
              showLabel: false,
              icon: const MacosIcon(
                CupertinoIcons.add_circled,
              ),
              onPressed: () {
                context.read<LayoutCubit>().newDocument();
              },
            ),
          if (layoutState is PreviewState &&
              layoutState.email.status.canBeEdited)
            ToolBarIconButton(
              label: 'Edit',
              showLabel: false,
              icon: const MacosIcon(
                CupertinoIcons.pencil,
              ),
              onPressed: () {
                onEdit(layoutState.email);
              },
            ),
          if (layoutState is PreviewState &&
              layoutState.email.status.canBeStopped)
            ToolBarIconButton(
              label: 'Cancel sending',
              showLabel: false,
              icon: const MacosIcon(
                CupertinoIcons.stop_circle,
              ),
              onPressed: () {
                context.read<EmailSenderCubit>().cancelSending(
                      layoutState.email.id,
                    );
              },
            ),
          if (layoutState is ComposingState)
            ToolBarIconButton(
              label: 'Exit',
              showLabel: false,
              icon: const MacosIcon(
                CupertinoIcons.xmark,
              ),
              onPressed: () {
                context.read<LayoutCubit>().closeDocument();
              },
            ),
          if (layoutState is ComposingState)
            ToolBarIconButton(
              label: 'Send',
              showLabel: false,
              icon: MacosIcon(
                CupertinoIcons.paperplane,
                color: MacosTheme.of(context).primaryColor,
              ),
              onPressed: () {
                onSend(layoutState.email);
              },
            ),
        ],
      ),
      children: [
        ResizablePane(
          minSize: 180,
          startSize: 200,
          windowBreakpoint: 700,
          resizableSide: ResizableSide.right,
          builder: (_, scrollController) {
            return EmailsListView(
              mode: widget.mode,
              scrollController: scrollController,
            );
          },
        ),
        ContentArea(
          builder: (context, scrollController) {
            print(layoutState);
            final view = switch (layoutState) {
              ComposingState(email: var email) => EmailEditorViewWrapper(
                  email: email,
                  onSend: onSend,
                  scrollController: scrollController,
                ),
              PreviewState(email: var email) => BlocProvider(
                  key: ValueKey(email.id),
                  create: (context) => EmailReaderCubit(
                    id: email.id,
                    storage: context.read<Storage>(),
                  ),
                  lazy: false,
                  child: EmailReaderView(
                    onEdit: onEdit,
                  ),
                ),
              InitialState() => const SizedBox(),
            };

            var footer = switch (layoutState) {
              ComposingState(email: var email) =>
                LastUpdatedLabel(email: email),
              PreviewState(email: var email) => LastUpdatedLabel(email: email),
              InitialState() => const SizedBox(),
            };

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: view),
                footer,
              ],
            );
          },
        ),
        ResizablePane(
          minSize: 300,
          startSize: 300,
          windowBreakpoint: 700,
          resizableSide: ResizableSide.left,
          builder: (_, scrollController) {
            return Column(
              children: [
                Expanded(
                  child: SyncTasksView(
                    scrollController: scrollController,
                  ),
                ),
                const MockEmailButton(),
                const ClockLabel(),
              ],
            );
          },
        ),
      ],
    );
  }
}

class LastUpdatedLabel extends StatelessWidget {
  const LastUpdatedLabel({
    super.key,
    required this.email,
  });

  final Email email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Last updated at ${email.updatedAt}',
          style: MacosTheme.of(context).typography.caption1,
        ),
      ),
    );
  }
}
