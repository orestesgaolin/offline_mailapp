import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class SidebarTooltip extends StatelessWidget {
  const SidebarTooltip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MacosTooltip(
      message: 'Toggle Sidebar',
      useMousePosition: false,
      child: MacosIconButton(
        icon: MacosIcon(
          CupertinoIcons.sidebar_left,
          color: MacosTheme.brightnessOf(context).resolve(
            const Color.fromRGBO(0, 0, 0, 0.5),
            const Color.fromRGBO(255, 255, 255, 0.5),
          ),
          size: 20.0,
        ),
        boxConstraints: const BoxConstraints(
          minHeight: 20,
          minWidth: 20,
          maxWidth: 48,
          maxHeight: 38,
        ),
        onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
      ),
    );
  }
}

class WidgetTextTitle1 extends StatelessWidget {
  const WidgetTextTitle1({super.key, required this.widgetName});

  final String widgetName;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: MacosColors.systemGrayColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6.0,
        ),
        child: Text(
          widgetName,
          style: MacosTypography.of(context).title1.copyWith(),
        ),
      ),
    );
  }
}

class WidgetTextTitle2 extends StatelessWidget {
  const WidgetTextTitle2({super.key, required this.widgetName});

  final String widgetName;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: MacosColors.systemGrayColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6.0,
        ),
        child: Text(widgetName, style: MacosTypography.of(context).title2),
      ),
    );
  }
}
