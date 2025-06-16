abstract class GeminiState {}

class GeminiInitial extends GeminiState {}

class GeminiLoading extends GeminiState {}

class GeminiTextGenerated extends GeminiState {
  final String text;
  GeminiTextGenerated(this.text);
}

class GeminiImageGenerated extends GeminiState {
  final String base64Image;
  GeminiImageGenerated(this.base64Image);
}

class GeminiError extends GeminiState {
  final String message;
  GeminiError(this.message);
}
