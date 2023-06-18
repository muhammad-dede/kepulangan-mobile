import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Themes {
  final box = GetStorage();

  ThemeMode getThemeMode() {
    return box.read('isDarkMode') != null ? ThemeMode.dark : ThemeMode.light;
  }

  final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF144477),
    ),
  );

  final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
  );
}
