import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:yumm/Tabs/mainTab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Aquí podrías enviar el token al backend para validación si es necesario

      // Guardar datos del usuario localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', googleUser.email);
      await prefs.setString('user_name', googleUser.displayName ?? '');
      await prefs.setString('user_photo', googleUser.photoUrl ?? '');

      // Redirigir a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainTab()),
      );
    } catch (error) {
      print('Error en el inicio de sesión con Google: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al iniciar sesión con Google')),
      );
    }
  }
}
