
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GesturLabApp());
}

class GesturLabApp extends StatelessWidget {
  const GesturLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GesturLab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B365D),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B365D),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
