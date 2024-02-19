import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mailapp/list/list.dart';
import 'package:mailapp/main_view/main_view.dart';
import 'package:mailapp/model.dart';

class EmailsListView extends StatelessWidget {
  const EmailsListView({
    super.key,
    required this.mode,
    required this.scrollController,
  });

  final MainPageMode mode;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EmailsListCubit>().state;

    return switch (state) {
      EmailsListInitial() => const EmailsListEmptyState(),
      EmailsListLoaded(emails: var e) => e.isEmpty
          ? const EmailsListEmptyState()
          : LoadedEmailsListView(
              scrollController: scrollController,
              emails: e.where((element) {
                switch (mode) {
                  // This method of filtering should be moved to the storage level
                  case MainPageMode.all:
                    return true;
                  case MainPageMode.inbox:
                    return element.status == EmailStatus.received ||
                        element.status == EmailStatus.unread;
                  case MainPageMode.outgoing:
                    return element.status == EmailStatus.sent ||
                        element.status == EmailStatus.pendingSending ||
                        element.status == EmailStatus.draft ||
                        element.status == EmailStatus.sending;
                  case MainPageMode.synchronizationTasks:
                    return false;
                }
              }).toList()),
    };
  }
}

class EmailsListEmptyState extends StatelessWidget {
  const EmailsListEmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No emails yet',
        style: MacosTheme.of(context).typography.body,
      ),
    );
  }
}

class LoadedEmailsListView extends StatelessWidget {
  const LoadedEmailsListView({
    super.key,
    required this.emails,
    required this.scrollController,
  });

  final List<Email> emails;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final layoutState = context.watch<LayoutCubit>().state;
    final selectedDocumentId = switch (layoutState) {
      ComposingState(email: var email) => email.id,
      PreviewState(email: var email) => email.id,
      InitialState() => null,
    };
    return ListView.builder(
      controller: scrollController,
      itemCount: emails.length,
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      itemBuilder: (context, index) {
        final email = emails[index];
        final isSelected = email.id == selectedDocumentId;
        return MouseHoverListener(
          child: EmailListTile(
            email: email,
            isSelected: isSelected,
            onTap: () {
              context.read<LayoutCubit>().previewDocument(email);
            },
          ),
        );
      },
    );
  }
}

class MouseHoverListener extends StatefulWidget {
  const MouseHoverListener({super.key, required this.child});

  final Widget child;

  @override
  State<MouseHoverListener> createState() => _MouseHoverListenerState();
}

class _MouseHoverListenerState extends State<MouseHoverListener> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isHovered ? MacosTheme.of(context).dividerColor : null,
        ),
        child: widget.child,
      ),
    );
  }
}

class EmailListTile extends StatelessWidget {
  const EmailListTile({
    super.key,
    required this.email,
    required this.isSelected,
    required this.onTap,
  });

  final Email email;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final contentLength = email.content.length;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 8.0),
        child: MacosListTile(
          leading: switch (email.status) {
            EmailStatus.sent =>
              const ListTileIcon(CupertinoIcons.paperplane_fill),
            EmailStatus.pendingSending =>
              const ListTileIcon(CupertinoIcons.paperplane),
            EmailStatus.sending =>
              const ListTileIcon(CupertinoIcons.paperplane),
            EmailStatus.draft =>
              const ListTileIcon(CupertinoIcons.pencil_outline),
            EmailStatus.unread => const ListTileIcon(CupertinoIcons.envelope),
            EmailStatus.received =>
              const ListTileIcon(CupertinoIcons.envelope_open),
          },
          title: Text(
            email.subject.isEmpty ? 'No subject' : email.subject,
            style: MacosTheme.of(context).typography.title2.copyWith(
                  color:
                      isSelected ? MacosTheme.of(context).primaryColor : null,
                ),
          ),
          subtitle: Text(
            email.content
                .substring(0, contentLength > 50 ? 50 : contentLength)
                .replaceAll('\n', ' ')
                .replaceAll('*', '')
                .replaceAll('  ', ' '),
            style: MacosTheme.of(context).typography.body.copyWith(
                  color:
                      isSelected ? MacosTheme.of(context).primaryColor : null,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class ListTileIcon extends StatelessWidget {
  const ListTileIcon(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Icon(
        icon,
        size: 20,
      ),
    );
  }
}
