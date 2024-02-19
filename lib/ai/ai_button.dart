import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mailapp/ai/ai_client.dart';
import 'package:rxdart/rxdart.dart';

class AiButton extends StatelessWidget {
  const AiButton({
    super.key,
    required this.onContent,
  });

  final void Function(String content) onContent;

  @override
  Widget build(BuildContext context) {
    const apiKey = String.fromEnvironment('AI_API_KEY');
    return PushButton(
      onPressed: () async {
        final client = AiClient.vertexAi(
          apiKey: apiKey,
          projectUrl:
              'https://us-central1-aiplatform.googleapis.com/v1/projects/dashboard-410409/locations/us-central1/publishers/google/models',
        );

        final sub = client
            .generateContent()
            .delay(const Duration(seconds: 1))
            .listen((event) {
          print(event);
          onContent(event);
        });
      },
      controlSize: ControlSize.large,
      child: Text('AI help me'),
    );
  }
}
