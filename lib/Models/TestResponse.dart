

class GeminiTextResponse {
  final String text;
  GeminiTextResponse(this.text);

  factory GeminiTextResponse.fromJson(Map<String, dynamic> json) {
    final parts = json['candidates'][0]['content']['parts'] as List;
    final text = parts.first['text'] as String;
    return GeminiTextResponse(text);
  }
}