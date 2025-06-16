

class GeminiImageResponse {
  final String base64Image;
  GeminiImageResponse(this.base64Image);

  factory GeminiImageResponse.fromJson(Map<String, dynamic> json) {
    final parts =
    json['candidates'][0]['content']['parts'] as List<dynamic>;
    for (final part in parts) {
      if (part.containsKey('inlineData')) {
        return GeminiImageResponse(part['inlineData']['data'] as String);
      }
    }
    throw FormatException('No image data in response');
  }
}