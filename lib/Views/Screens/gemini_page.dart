import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/chat_bot_bloc.dart';
import '../../Bloc/chat_bot_event.dart';
import '../../Bloc/chat_bot_state.dart';


class GeminiPage extends StatefulWidget {
  const GeminiPage({super.key});
  @override
  State<GeminiPage> createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatBubble> _chatHistory = [];
  String _selectedMode = 'Text'; // or 'Image'
  bool _isThinking = false;

  void _addUserMessage(String text) {
    setState(() {
      _chatHistory.add(_ChatBubble(text: text, isUser: true));
    });
  }

  void _addBotThinkingMessage() {
    final message = _selectedMode == 'Text'
        ? '🤖 Thinking...'
        : '🧠 Imagining your image...';
    setState(() {
      _isThinking = true;
      _chatHistory.add(_ChatBubble(text: message, isUser: false, isTemporary: true));
    });
  }

  void _replaceThinkingMessage({String? text, String? imageBase64}) {
    if (_isThinking) {
      setState(() {
        _chatHistory.removeWhere((c) => c.isTemporary);
        _chatHistory.add(
          _ChatBubble(
            text: text ?? '',
            imageBase64: imageBase64,
            isUser: false,
          ),
        );
        _isThinking = false;
      });
    }
  }

  void _sendPrompt() {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;

    _addUserMessage(prompt);
    _controller.clear();
    _addBotThinkingMessage();

    final bloc = context.read<GeminiBloc>();
    if (_selectedMode == 'Image') {
      bloc.add(GenerateImageEvent(prompt));
    } else {
      bloc.add(GenerateTextEvent(prompt));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 2,
        title: const Text('TalkWise', style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedMode,
            onSelected: (value) => setState(() => _selectedMode = value),
            color: Colors.grey[900],
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'Text',
                child: Text('Text Mode', style: TextStyle(color: Colors.white)),
              ),
              PopupMenuItem(
                value: 'Image',
                child: Text('Image Mode', style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocListener<GeminiBloc, GeminiState>(
              listener: (context, state) {
                if (state is GeminiTextGenerated) {
                  _replaceThinkingMessage(text: state.text);
                } else if (state is GeminiImageGenerated) {
                  _replaceThinkingMessage(imageBase64: state.base64Image);
                }
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _chatHistory.length,
                itemBuilder: (context, index) {
                  final chat = _chatHistory[index];
                  return Align(
                    alignment:
                    chat.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 300),
                      decoration: BoxDecoration(
                        color: chat.isUser ? Colors.white10 : Colors.grey[900],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: Radius.circular(chat.isUser ? 12 : 0),
                          bottomRight: Radius.circular(chat.isUser ? 0 : 12),
                        ),
                      ),
                      child: chat.imageBase64 != null
                          ? Image.memory(base64Decode(chat.imageBase64!))
                          : Text(
                        chat.text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.white24),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: _selectedMode == 'Text'
                            ? 'Ask something...'
                            : 'Describe an image...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _sendPrompt,
                    icon: Icon(
                      _selectedMode == 'Text' ? Icons.send : Icons.image,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: Text(
                      _selectedMode,
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}





