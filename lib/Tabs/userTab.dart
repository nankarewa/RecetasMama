import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumm/Provider/theme_provider.dart';
import 'package:yumm/Services/googleAuth.dart';
import 'package:yumm/Tabs/AddRecipeTab.dart';
import 'package:yumm/Tabs/login_screen.dart';
import 'package:yumm/Tabs/mainTab.dart';

class UserTab extends StatefulWidget {
  const UserTab({Key? key}) : super(key: key);

  @override
  _UserTabState createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  String? _userName;
  String? _userEmail;
  String? _userPhoto;
  String? _token;
  bool isActiveTabLeft = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name');
      _userEmail = prefs.getString('user_email');
      _userPhoto = prefs.getString('user_photo');
      _token = prefs.getString('token');
    });
  }

  Future<void> _logout() async {
    try {
      // 1️⃣ Cerrar sesión de Google
      await GoogleAuthService.signOutGoogle(context);

      // 2️⃣ Limpiar todos los datos guardados
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // 🔥 Borra todo (token, email, nombre, foto)

      // 3️⃣ Resetear el estado
      setState(() {
        _token = null;
        _userEmail = null;
        _userName = null;
        _userPhoto = null;
      });

      print("🟢 Sesión cerrada y datos eliminados.");

      // 4️⃣ Redirigir al Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

      // 5️⃣ Notificación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión cerrada exitosamente')),
      );
    } catch (error) {
      print("❌ Error al cerrar sesión: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.light;
    return Scaffold(
      appBar: AppBar(
    title: const Text('Perfil'),
    actions: [
      IconButton(
        icon: Icon(
          isDarkMode
              ? Icons.light_mode // Ícono de sol para tema claro
              : Icons.dark_mode, // Ícono de luna para tema oscuro
           color: isDarkMode
                        ? Colors.black
                        : Colors.grey[200]
        ),
        onPressed: () {
          themeProvider.toggleTheme(); // Cambia el tema
        },
      ),
    ],
  ),
      body: _buildUserInfo(),
      floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.yellow[700],
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddRecipetab()),
        );
      },
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildUserInfo() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _userPhoto != null
                  ? NetworkImage(_userPhoto!)
                  : const AssetImage('assets/default_profile.png')
                      as ImageProvider,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 10),
            Text(
              _userName ?? 'Usuario',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              _userEmail ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatItem('Recetas subidas', '20',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[200]!
                        : Colors.black),
                const SizedBox(width: 20),
                _buildStatItem('Recetas guardadas', '123',
                    color: Colors.yellow[800]!),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _buildTabButton(
                    'Mis recetas',
                    isActiveTabLeft, // Indica si esta pestaña está activa
                    () {
                      setState(() {
                        isActiveTabLeft = true; // Cambia a la pestaña izquierda
                      });
                    },
                    true, // Esta es la pestaña izquierda
                  ),
                  _buildTabButton(
                    'Recetas que me gustan',
                    !isActiveTabLeft, // Indica si esta pestaña está activa
                    () {
                      setState(() {
                        isActiveTabLeft = false; // Cambia a la pestaña derecha
                      });
                    },
                    false, // Esta es la pestaña derecha
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count, {required Color color}) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTabButton(
      String label, bool isActive, VoidCallback onPressed, bool isLeft) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.yellow[700] : Colors.white,
          borderRadius: isLeft
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
