import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'Bloc/chat_bot_bloc.dart';
import 'Views/Screens/Splash/Splash_screen.dart';
import 'package:path_provider/path_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final results = await Future.wait([
        () async {
      if (kIsWeb) {
        return await HydratedStorage.build(storageDirectory: HydratedStorageDirectory.web,);
      } else {
        final dir = await getTemporaryDirectory();
        return await HydratedStorage.build(storageDirectory: HydratedStorageDirectory((dir).path),);
      }
    }(),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]),
  ]);
  HydratedBloc.storage = results[0] as HydratedStorage;
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=> GeminiBloc(apiKey: apiKey)),
      ],
      child: const MaterialApp(
        title: 'TalkWise',
        home: SplashScreen(),
      ),
    );
  }
}



