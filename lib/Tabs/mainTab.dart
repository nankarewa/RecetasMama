import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yumm/Model/Receta.dart';
import 'package:yumm/Model/RecetasData.dart';
import 'package:yumm/Provider/theme_provider.dart';
import 'package:yumm/Proxy/recetaAPI.dart';
import 'package:yumm/Tabs/login_screen.dart';
import 'package:yumm/Tabs/mainTab.dart';
import 'package:yumm/Tabs/recetaTab.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Importamos los temas
import 'package:google_fonts/google_fonts.dart';
import 'package:yumm/Tabs/userTab.dart';
import '../Proxy/mainMenuApi.dart';

class MainTab extends StatefulWidget {
  const MainTab({super.key});

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  final ScrollController _scrollController = ScrollController();

   String? _userPhoto;

  @override
  void dispose() {
    _scrollController.dispose(); // Limpiar el controlador
    super.dispose();
  }

   @override
  void initState() {
    super.initState();
    _loadUserPhoto();
  }


 // 🔄 Cargar la foto de perfil del usuario
  Future<void> _loadUserPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userPhoto = prefs.getString('user_photo');
    });
  }

  @override
  Widget build(BuildContext context) {
   final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.light;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Imagen principal de fondo sin desenfoque, ocupando toda la pantalla
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 1.1,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(
                            0.4), // Ajusta la opacidad según lo oscuro que desees
                        BlendMode.darken,
                      ),
                      child: Image.asset(
                        'assets/lemon.png',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                  ),
                ),

                // Caja de degradado extraída del AppBar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(1.0),
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Iconos superiores (antes en AppBar)
                Positioned(
                  top: 40,
                  right: 16,
                  child: Row(
                    children: [
                    IconButton(
                        icon: _userPhoto != null && _userPhoto!.isNotEmpty
                            ? CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(_userPhoto!),
                              )
                            : const Icon(
                                Icons.account_circle,
                                color: Colors.white,
                              ),
                        onPressed: () {
                       navigateToProfileOrLogin(context);
                        },
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //     isDarkMode 
                      //         ? Icons.light_mode // Ícono de sol para tema claro
                      //         : Icons.dark_mode, // Ícono de luna para tema oscuro
                      //     color: Colors.white
                      //   ),
                      //   onPressed: () {
                      //     themeProvider.toggleTheme(); // Cambia el tema
                      //   },
                      // ),
                    ],
                  ),
                ),

                Positioned(
                  top: 140,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Y',
                            style: GoogleFonts.righteous(
                              color: const Color(0xFFF4D516),
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'UMM',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Card borroso sobre la imagen principal
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.25,
                  left: 32,
                  right: 32,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Recetas que ',
                                    style: GoogleFonts.righteous(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'INSPIRAN',
                                    style: GoogleFonts.righteous(
                                      color: const Color(0xFFF4D516),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Buscar...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.08),
                                const Icon(
                                  Icons.search,
                                  color: Color(0xFFF4D516),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            // Scroll horizontal con los tipos de cocina dentro del card
                            SizedBox(
                              height: 280,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                children: [
                                  _buildCuisineCardWithHighlight('Cocina',
                                      'China', 'assets/xina.png', isDarkMode),
                                  const SizedBox(width: 25),
                                  _buildCuisineCardWithHighlight('Cocina',
                                      'India', 'assets/india.png', isDarkMode),
                                  const SizedBox(width: 25),
                                  _buildCuisineCardWithHighlight(
                                      'Cocina',
                                      'Italiana',
                                      'assets/italia.png',
                                      isDarkMode),
                                  const SizedBox(width: 25),
                                  _buildCuisineCardWithHighlight(
                                      'Cocina',
                                      'Mexicana',
                                      'assets/mexico.png',
                                      isDarkMode),
                                  const SizedBox(width: 25),
                                  _buildCuisineCardWithHighlight(
                                      'Cocina',
                                      'Japonesa',
                                      'assets/japon.png',
                                      isDarkMode),
                                  const SizedBox(width: 25),
                                  _buildCuisineCardWithHighlight(
                                      'Cocina',
                                      'Francesa',
                                      'assets/francia.png',
                                      isDarkMode),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.08),

                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.1,
                  left: (MediaQuery.of(context).size.width - 50) / 2,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 50,
                        color: Color(0xFFF4D516),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            // Nueva sección con contenido adicional
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Lo mejor de ',
                          style: GoogleFonts.righteous(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'YUMM',
                          style: GoogleFonts.righteous(
                            color: const Color(0xFFF4D516),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  //---------------------------------------------------
                  // FutureBuilder para cargar recetas de la API
                  //---------------------------------------------------
                  FutureBuilder<List<Receta>>(
                    future: RecetaApi().getRecetas(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // Indicador de carga
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error al cargar recetas'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No hay recetas disponibles'));
                      }

                      final recetas = snapshot.data!;

                      return Column(
                        children: [
                          // La primera receta destacada
                          _buildDetailedRecipeCard(
                            recetas[0].imagenUrl,
                            recetas[0].titulo,
                            recetas[0].descripcion,
                            recetas[0].autor,
                            true,
                            isDarkMode,
                            () {
                              // Acción al pulsar la tarjeta
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecetaTab(receta: recetas[0]),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),

                          // Grid de recetas
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: recetas.length -
                                1, // Excluye la primera receta destacada
                            itemBuilder: (context, index) {
                              final receta = recetas[
                                  index + 1]; // Empieza desde la segunda receta
                              return _buildDetailedRecipeCard(
                                receta.imagenUrl,
                                receta.titulo,
                                receta.descripcion,
                                receta.autor,
                                false,
                                isDarkMode,
                                () {
                                  // Acción al pulsar la tarjeta
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecetaTab(receta: receta),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment
                    .centerLeft, // Asegura que el contenido esté alineado a la izquierda
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Ingredientes de ',
                            style: GoogleFonts.righteous(
                              color: isDarkMode ? Colors.black : Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'temporada',
                            style: GoogleFonts.righteous(
                              color: const Color(0xFFF4D516),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            Container(
              height: 180,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<List<Widget>>(
                future:
                    buildSeasonCards(), // Llamada a la función que construye las tarjetas
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Indicador de carga
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error al cargar datos'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hay datos disponibles'));
                  }
                  // Realizar el desplazamiento después de cargar los datos
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(
                          MediaQuery.of(context).size.width *
                              0.02); // Desplazar el scroll 40 píxeles
                    }
                  });
                  return ListView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!, // Las tarjetas generadas
                  );
                },
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.08),

            //=====================================================
            //============   Sección Inspiracion   ================
            //=====================================================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 37, 37, 37),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '¿Necesitas ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'inspiración?',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dos columnas por fila
                      crossAxisSpacing: 4, // Espaciado horizontal
                      mainAxisSpacing: 8, // Espaciado vertical
                      childAspectRatio: 1.8,
                    ),
                    itemCount: 8, // Número total de íconos
                    itemBuilder: (context, index) {
                      final items = [
                        {"icon": Icons.lunch_dining, "label": "Batch cooking"},
                        {"icon": Icons.timer, "label": "Menos de 30Min"},
                        {"icon": Icons.cake, "label": "Postres"},
                        {"icon": Icons.eco, "label": "Vegetarianas"},
                        {
                          "icon": Icons.local_fire_department,
                          "label": "Healthy"
                        },
                        {"icon": Icons.fastfood, "label": "Aperitivos"},
                        {"icon": Icons.local_drink, "label": "Bebidas"},
                        {
                          "icon": Icons.emoji_food_beverage,
                          "label": "Guilty Pleasures"
                        },
                      ];
                      return _buildCategoryButton(
                        items[index]["icon"] as IconData,
                        items[index]["label"] as String,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          ],
        ),
      ),
    );
  }

  // Widget para crear un card de cada tipo de cocina
  Widget _buildCuisineCardWithHighlight(String firstPart,
      String highlightedPart, String imagePath, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          Container(
            width: 200,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.contain,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$firstPart ',
                  style: GoogleFonts.righteous(
                    fontSize: 28,
                    color: isDarkMode ? Colors.white : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: highlightedPart,
                  style: GoogleFonts.righteous(
                    fontSize: 28,
                    color: const Color(0xFFF4D516),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void navigateToProfileOrLogin(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token != null && token.isNotEmpty) {
    // 🔐 Usuario autenticado -> ir a UserTab
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserTab()),
    );
  } else {
    // ❌ No autenticado -> ir a LoginScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}

  // Widget para crear un card de receta detallada con descripción
  Widget _buildDetailedRecipeCard(
      String imagePath,
      String title,
      String description,
      String author,
      bool isTop,
      bool isDarkMode,
      VoidCallback onTap) {
    // Función para manejar el evento onTap

    return 
    GestureDetector(
      onTap: onTap, // Acción al pulsar la tarjeta
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: imagePath.startsWith('http')
                ? Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: isTop ? 300 : 150,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          'Error al cargar imagen',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  )
                : Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: isTop ? 300 : 150,
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.righteous(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[800] : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const CircleAvatar(
                radius: 14,
                //backgroundImage: AssetImage('assets/author.jpg'),
              ),
              const SizedBox(width: 6),
              Text(
                'por $author',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Widget para crear un card de ingredientes de temporada
  Widget _buildSeasonCard(
      String title, String imagePath, Color color, bool flip) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: flip ? const Radius.circular(100) : const Radius.circular(20),
          topRight: flip ? const Radius.circular(20) : const Radius.circular(100),
          bottomLeft: const Radius.circular(20),
          bottomRight: const Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Imagen en la parte inferior
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.network(
                imagePath, // URL remota
                fit: BoxFit.cover,
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.red,
                  ); // Muestra un ícono de error si no se carga la imagen
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // La imagen se cargó correctamente
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(), // Indicador de carga
                    );
                  }
                },
              ),
            ),
          ),
          // Texto que se superpone a la imagen, justo abajo
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Center(
                child: Text(
                  title,
                  style: GoogleFonts.righteous(
                    fontSize: 28,
                    color: flip ? Colors.brown : const Color(0xFFF4D516),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Widget>> buildSeasonCards() async {
    final ingredientes =
        await Mainmenuapi.fetchIngredientesTemporada(); // Llamada a la API

    return ingredientes.asMap().entries.map((entry) {
      final index = entry.key; // Índice del elemento
      final ingrediente = entry.value;

      // Alternar flip según el índice (pares/no pares)
      final flip = index.isOdd;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: _buildSeasonCard(
          ingrediente.nombre,
          ingrediente.imagenUrl,
          Color(int.parse(
              '0xFF${ingrediente.color.substring(1)}')), // Convertir HEX a Color
          flip, // Alternar redondeo
        ),
      );
    }).toList();
  }

// Función auxiliar para construir los botones de categorías
  Widget _buildCategoryButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.yellow,
          size: 54,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
