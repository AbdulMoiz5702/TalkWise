import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/chat_bot_bloc.dart';
import '../../Bloc/chat_bot_event.dart';
import '../../Bloc/chat_bot_state.dart';


class GeminiPage extends StatefulWidget {
  const GeminiPage({super.key});
  @override
  _GeminiPageState createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gemini API Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter a prompt'),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<GeminiBloc>().add(GenerateTextEvent(_controller.text));
                    },
                    child: Text('Generate Text'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<GeminiBloc>()
                          .add(GenerateImageEvent(_controller.text));
                    },
                    child: Text('Generate Image'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<GeminiBloc, GeminiState>(
                builder: (context, state) {
                  if (state is GeminiLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is GeminiTextGenerated) {
                    return SingleChildScrollView(
                      child: Text(state.text, style: TextStyle(fontSize: 16)),
                    );
                  }
                  if (state is GeminiImageGenerated) {
                    return Image.memory(
                      base64Decode(state.base64Image),
                    );
                  }
                  if (state is GeminiError) {
                    return Center(
                        child: Text('Error: ${state.message}',
                            style: TextStyle(color: Colors.red)));
                  }
                  return Center(child: Text('Enter a prompt to begin.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
