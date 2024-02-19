import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mailapp/editor/editor.dart';
import 'package:mailapp/model.dart';
import 'package:mailapp/reader/reader.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_editor_markdown/super_editor_markdown.dart';

class EmailReaderView extends StatelessWidget {
  const EmailReaderView({
    super.key,
    required this.onEdit,
  });

  final void Function(Email email) onEdit;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EmailReaderCubit>().state;

    final content = switch (state) {
      EmailReaderInitial() => const SizedBox(),
      EmailReaderLoaded(email: var email) => SuperReader(
          document: deserializeMarkdownToDocument(email.content),
          stylesheet: getStylesheet(MediaQuery.platformBrightnessOf(context)),
        ),
    };

    final subject = switch (state) {
      EmailReaderInitial() => const SizedBox(),
      EmailReaderLoaded(email: var email) => Padding(
          padding: const EdgeInsets.only(
            top: 24,
            left: 24,
          ),
          child: Text(
            email.subject.isEmpty ? 'No subject' : email.subject,
            style: MacosTheme.of(context).typography.body,
          ),
        ),
    };

    return Listener(
      onPointerDown: switch (state) {
        EmailReaderInitial() => null,
        EmailReaderLoaded(email: var email) =>
          email.status == EmailStatus.draft ? (_) => onEdit(email) : null,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subject,
          Expanded(
            child: content,
          ),
        ],
      ),
    );
  }
}
