import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc/chat_bot_bloc.dart';
import 'Views/Screens/gemini_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String apiKey = "AIzaSyCMR2i47-GUdT3NF6nJBsEbfdNKBQKt9SM";
    return MaterialApp(
      title: 'Gemini Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => GeminiBloc(apiKey: apiKey),
        child: GeminiPage(),
      ),
    );
  }
}

