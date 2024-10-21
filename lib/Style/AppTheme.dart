import 'package:flutter/material.dart';

class AppTheme {
  // Tema claro
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.orange,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    textTheme: TextTheme(
      // Descripciones con color más oscuro para el tema claro
      bodyMedium: TextStyle(
        color: Colors.grey[800], // Color gris oscuro para tema claro
      ),
    ),
  );

  // Tema oscuro
  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.orange,
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    textTheme: TextTheme(
      // Descripciones con color más claro para el tema oscuro
      bodyMedium: TextStyle(
        color: Colors.grey[300], // Color gris claro para tema oscuro
      ),
    ),
  );
}
