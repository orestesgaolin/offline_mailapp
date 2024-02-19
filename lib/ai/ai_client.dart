import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart';

class AiClient {
  AiClient.vertexAi({
    required String apiKey,
    required String projectUrl,
  }) : _model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: apiKey,
          httpClient: VertexHttpClient(projectUrl),
        );

  final GenerativeModel _model;

  Stream<String> generateContent() {
    return _model.generateContentStream(
      [
        Content.text(
            'Generate random email content about some animal. Skip subject. Provide content only.'),
      ],
    ).map((event) {
      return event.candidates.firstOrNull?.content?.parts
              .map((e) => e is TextPart ? e.text : e.toString())
              .join('') ??
          '';
    });
  }
}

// This class is borrowed from here:
// https://github.com/leancodepl/arb_translate/blob/main/lib/src/translation_delegates/gemini_translation_delegate.dart#L233
class VertexHttpClient extends BaseClient {
  VertexHttpClient(this._projectUrl);

  final String _projectUrl;
  final _client = Client();

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    if (request is! Request ||
        request.url.host != 'generativelanguage.googleapis.com') {
      return _client.send(request);
    }

    final vertexRequest = Request(
      request.method,
      Uri.parse(
        request.url.toString().replaceAll(
              'https://generativelanguage.googleapis.com/v1/models',
              _projectUrl,
            ),
      ),
    )..bodyBytes = request.bodyBytes;

    for (final header in request.headers.entries) {
      if (header.key != 'x-goog-api-key') {
        vertexRequest.headers[header.key] = header.value;
      }
    }

    vertexRequest.headers['Authorization'] =
        'Bearer ${request.headers['x-goog-api-key']}';

    return _client.send(vertexRequest);
  }
}
