import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailapp/editor/editor.dart';
import 'package:mailapp/model.dart';
import 'package:mailapp/storage.dart';

class EmailEditorViewWrapper extends StatelessWidget {
  const EmailEditorViewWrapper({
    super.key,
    required this.email,
    required this.onSend,
    required this.scrollController,
  });

  final Email email;
  final void Function(Email email) onSend;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailEditingCubit(
        email: email,
        storage: context.read<Storage>(),
      ),
      child: FocusTraversalGroup(
        child: Column(
          children: [
            EmailRecipientView(
              email: email,
              onChanged: (context, recipients) {
                context.read<EmailEditingCubit>().updateRecipients(recipients);
              },
            ),
            EmailSubjectView(
              email: email,
              onChanged: (context, subject) {
                context.read<EmailEditingCubit>().updateSubject(subject);
              },
            ),
            Expanded(
              child: EmailEditorView(
                initialContent: email.content,
                onUpdate: (context, content) {
                  context.read<EmailEditingCubit>().updateContent(content);
                },
                onSubmit: (context) {
                  onSend(email);
                },
                scrollController: scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
