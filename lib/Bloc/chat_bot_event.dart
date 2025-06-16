
abstract class GeminiEvent {}

class GenerateTextEvent extends GeminiEvent {
  final String prompt;
  GenerateTextEvent(this.prompt);
}

class GenerateImageEvent extends GeminiEvent {
  final String prompt;
  GenerateImageEvent(this.prompt);
}
