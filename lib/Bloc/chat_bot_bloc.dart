import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/ImageResponse.dart';
import '../Models/TestResponse.dart';
import 'chat_bot_event.dart';
import 'chat_bot_state.dart';


class GeminiBloc extends HydratedBloc<GeminiEvent, GeminiState> {
  final String apiKey;

  GeminiBloc({required this.apiKey}) : super(GeminiInitial()) {
    on<GenerateTextEvent>(_onGenerateText);
    on<GenerateImageEvent>(_onGenerateImage);
  }

  Future<void> _onGenerateText(
      GenerateTextEvent event,
      Emitter<GeminiState> emit,
      ) async {
    emit(GeminiLoading());
    try {
      final res = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': event.prompt}
              ]
            }
          ]
        }),
      );
      if (res.statusCode != 200) throw Exception(res.body);
      final body = jsonDecode(res.body);
      final geminiRes = GeminiTextResponse.fromJson(body);
      emit(GeminiTextGenerated(geminiRes.text));
    } catch (e) {
      emit(GeminiError(e.toString()));
    }
  }

  Future<void> _onGenerateImage(
      GenerateImageEvent event,
      Emitter<GeminiState> emit,
      ) async {
    emit(GeminiLoading());
    try {
      final res = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-preview-image-generation:generateContent?key=$apiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': event.prompt}
              ]
            }
          ],
          'generationConfig': {
            'responseModalities': ['TEXT', 'IMAGE']
          }
        }),
      );
      if (res.statusCode != 200) throw Exception(res.body);
      final body = jsonDecode(res.body);
      final geminiRes = GeminiImageResponse.fromJson(body);
      emit(GeminiImageGenerated(geminiRes.base64Image));
    } catch (e) {
      emit(GeminiError(e.toString()));
    }
  }

  @override
  GeminiState? fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    final data = json['data'] as String?;
    if (type == 'text' && data != null) return GeminiTextGenerated(data);
    if (type == 'image' && data != null) return GeminiImageGenerated(data);
    return GeminiInitial();
  }

  @override
  Map<String, dynamic>? toJson(GeminiState state) {
    if (state is GeminiTextGenerated) {
      return {'type': 'text', 'data': state.text};
    } else if (state is GeminiImageGenerated) {
      return {'type': 'image', 'data': state.base64Image};
    }
    return null;
  }
}
