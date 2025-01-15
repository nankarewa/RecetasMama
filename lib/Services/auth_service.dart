import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'https://yumm.es/api';

  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'apodo': username,
        'contrasenya': password,
        'correo': email,
      }),
    );

    return response.statusCode == 201;
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'correo': email,
        'contrasenya': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Validamos si 'token' existe y no es nulo
      if (data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return true;
      } else {
        // Manejar el caso en que 'token' sea null
        throw Exception("Token no recibido del servidor");
      }
    } else {
      // Manejar errores HTTP
      throw Exception("Error en el inicio de sesión: ${response.statusCode}");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
