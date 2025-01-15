import 'package:flutter/material.dart';
import 'package:yumm/Tabs/login_screen.dart';
import '../Services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  final AuthService _authService = AuthService();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      bool success = await _authService.register(_username, _email, _password);
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const LoginScreen(), // Cambia a tu pantalla de login
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar usuario')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre de usuario'),
                onChanged: (value) => _username = value,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un nombre de usuario' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                onChanged: (value) => _email = value,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un correo electrónico' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                onChanged: (value) => _password = value,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese una contraseña' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
