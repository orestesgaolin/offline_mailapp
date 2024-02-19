import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mailapp/model.dart';

class EmailRecipientView extends StatefulWidget {
  const EmailRecipientView({
    super.key,
    required this.email,
    required this.onChanged,
  });

  final Email email;
  final void Function(BuildContext context, String content) onChanged;

  @override
  State<EmailRecipientView> createState() => _EmailRecipientViewState();
}

class _EmailRecipientViewState extends State<EmailRecipientView> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.email.recipient);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MacosTextField.borderless(
      controller: controller,
      placeholder: 'Recipients',
      maxLines: 1,
      padding: const EdgeInsets.only(left: 24, top: 24),
      onChanged: (value) => widget.onChanged(context, value),
    );
  }
}
