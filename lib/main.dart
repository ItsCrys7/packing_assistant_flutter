import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PackingApp());
}

class PackingApp extends StatelessWidget {
  const PackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pack Smart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 73, 187, 138),
        ),
        fontFamily: 'Georgia',
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const HomeScreen(),
    );
  }
}
