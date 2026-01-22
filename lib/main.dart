import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/app_constants.dart';
import 'common/app_theme.dart';
import 'screens/home_screen.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool? isDark = prefs.getBool(AppConstants.prefIsDarkMode);

  if (isDark != null) {
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  runApp(const BellyBuddyApp());
}

class BellyBuddyApp extends StatelessWidget {
  const BellyBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: AppConstants.appTitle,
          debugShowCheckedModeBanner: false,

          themeMode: currentMode,

          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),

          home: const HomeScreen(),
        );
      },
    );
  }
}
