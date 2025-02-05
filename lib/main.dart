import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:mimiqit/firebase_options.dart';
import 'studio_provider.dart';
import 'my_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => StudioProvider()..fetchStudios(),
      child: const DanceStudioApp(),
    ),
  );
}

class DanceStudioApp extends StatefulWidget {
  const DanceStudioApp({super.key});

  @override
  State<DanceStudioApp> createState() => _DanceStudioAppState();
}

class _DanceStudioAppState extends State<DanceStudioApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dance Studio Finder',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
    );
  }
}
