import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import pentru salvare

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool? isDark = prefs.getBool('isDarkMode');

  if (isDark != null) {
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  runApp(const PackingApp());
}

class PackingApp extends StatelessWidget {
  const PackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'Pack Smart',
          debugShowCheckedModeBanner: false,

          themeMode: currentMode,

          // --- TEMA LIGHT ---
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 73, 187, 138),
              brightness: Brightness.light,
            ),
            textTheme: GoogleFonts.ralewayTextTheme(
              ThemeData.light().textTheme,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 106, 106, 106),
              foregroundColor: Colors.white,
            ),
          ),

          // --- TEMA DARK ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 73, 187, 138),
              brightness: Brightness.dark, // Aici e cheia
            ),
            textTheme: GoogleFonts.ralewayTextTheme(ThemeData.dark().textTheme),
            useMaterial3: true,
            // Ajustăm culorile pentru întuneric
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F),
              foregroundColor: Colors.white,
            ),
            cardTheme: const CardThemeData(
              color: Color(0xFF2C2C2C), // Carduri gri închis
            ),
          ),

          home: const HomeScreen(),
        );
      },
    );
  }
}
