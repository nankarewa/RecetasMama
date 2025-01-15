import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();  // Cargar tema al iniciar
  }

  void toggleTheme() {
   _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  // Guardar el nuevo estado del tema
  _saveTheme(_themeMode == ThemeMode.dark);
    notifyListeners(); // Notifica a todos los widgets que están escuchando
  }

  void setTheme(ThemeMode theme) {
    _themeMode = theme;
    notifyListeners();
  }


   Future<void> _saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
