import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:yumm/Tabs/login_screen.dart';
import 'package:yumm/Tabs/mainTab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'openid',  // 🔥 NECESARIO para obtener el idToken
    ],
    serverClientId: '1008128250772-73fhd9c5k3n94ovtkaher189iornll6l.apps.googleusercontent.com',
  );

   static Future<bool> signInWithGoogle(BuildContext context) async {
  try {
    print("🟢 Iniciando proceso de autenticación con Google...");

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      print("⚠️ El usuario canceló el inicio de sesión.");
      return false;  // ❌ El usuario canceló
    }

    print("🟢 Usuario autenticado: ${googleUser.displayName} (${googleUser.email})");

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // ✅ Validamos si el idToken fue recibido
    if (googleAuth.idToken == null) {
      print("❌ idToken es null. Faltan permisos o configuración.");
      return false;
    } else {
      print("🟢 idToken recibido: ${googleAuth.idToken}");
    }

    print("🟢 Access Token: ${googleAuth.accessToken}");

    // Guardar datos del usuario localmente
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', googleUser.email);
    await prefs.setString('user_name', googleUser.displayName ?? '');
    await prefs.setString('user_photo', googleUser.photoUrl ?? '');
    await prefs.setString('token', googleAuth.idToken ?? '');

    print("🟢 Datos del usuario guardados localmente.");
    
    return true;  // ✅ Todo salió bien
  } catch (error) {
    print("❌ Error en el inicio de sesión con Google: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al iniciar sesión con Google: $error')),
    );
    return false;  // ❌ Fallo la autenticación
  }
}


 // 🔥 NUEVO: Función para cerrar sesión
  static Future<void> signOutGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signOut();  // Cierra sesión de Google
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();  // Limpia todos los datos guardados

      print("🟢 Sesión de Google cerrada y datos limpiados.");

      // Redirigir al LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      print("❌ Error al cerrar sesión de Google: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $error')),
      );
    }
  }
}


