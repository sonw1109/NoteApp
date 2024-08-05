import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_app/providers/theme_provider.dart';

import 'package:note_app/screens/content_screen.dart';
import 'package:note_app/screens/home_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/screens/login_screen.dart';
import 'package:note_app/screens/signup_screen.dart';
import 'package:note_app/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Khởi tạo Firebase
  runApp(
    const ProviderScope(
      child: Theme(),
    ),
  );
}

class Theme extends ConsumerWidget {
  const Theme({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(changeThemeProvider);
    return MaterialApp(
      theme: theme,
      routes: <String, WidgetBuilder>{
        '/1': (BuildContext context) {
          return const ContentScreen();
        },
      },
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
