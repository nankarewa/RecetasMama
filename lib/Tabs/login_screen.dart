import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yumm/Provider/theme_provider.dart';
import 'package:yumm/Services/GoogleAuth.dart';
import 'package:yumm/Tabs/mainTab.dart';
import 'package:yumm/Tabs/registrer_screen.dart';
import '../Services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final AuthService _authService = AuthService();

  String? _token;
  String? _userEmail;  // Para mostrar el correo del usuario
  String? _userName;
  String? _userPhoto;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

 Future<void> _checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final email = prefs.getString('user_email');
  final name = prefs.getString('user_name');
  final photo = prefs.getString('user_photo');

  setState(() {
    _token = token;
    _userEmail = email;
    _userName = name;
    _userPhoto = photo;
  });
}

  // Función para iniciar sesión
  void _login() async {
    if (_formKey.currentState!.validate()) {
      bool success = await _authService.login(_email, _password);
      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', _email);  

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainTab()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas')),
        );
      }
    }
  }

  // Función para cerrar sesión
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_email');

    setState(() {
      _token = null;
      _userEmail = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sesión cerrada exitosamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _token != null
            ? _buildUserInfo()  // Mostrar info si está logueado
            : _buildLoginForm(),  // Mostrar formulario si no
      ),
    );
  }

  // UI para mostrar la información del usuario logueado
  Widget _buildUserInfo() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _userPhoto != null
          ? CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_userPhoto!),
            )
          : const Icon(Icons.account_circle, size: 100, color: Colors.blue),
      const SizedBox(height: 16),
      Text(
        'Bienvenido, ${_userName ?? 'Usuario'}',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text(
        _userEmail ?? '',
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
      const SizedBox(height: 32),
      ElevatedButton(
        onPressed: _logout,
        child: const Text('Cerrar Sesión'),
      ),
    ],
  );
}

  // Formulario de inicio de sesión
  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
            onChanged: (value) => _email = value,
            validator: (value) =>
                value!.isEmpty ? 'Ingrese un correo electrónico válido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
            onChanged: (value) => _password = value,
            validator: (value) =>
                value!.isEmpty ? 'Ingrese una contraseña' : null,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Iniciar Sesión'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            child: const Text('¿No tienes cuenta? Regístrate'),
          ),


 // BOTÓN DE GOOGLE
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.grey),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
          icon: Image.asset(
            'assets/google_logo.png',  // Icono de Google
            height: 24,
            width: 24,
          ),
          label: const Text('Iniciar sesión con Google'),
          onPressed: () async {
            await GoogleAuthService.signInWithGoogle(context);
            // Aquí puedes redirigir al usuario si es necesario
          },
        ),


        ],
      ),
    );
  }
}
