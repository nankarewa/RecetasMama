import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:recetas/Model/Receta.dart';
import 'package:recetas/Model/RecetasData.dart';
import 'package:recetas/Tabs/mainTab.dart';
import '../Style/AppTheme.dart'; // Importamos los temas
import 'package:google_fonts/google_fonts.dart';

class MainTab extends StatefulWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;

  MainTab({required this.themeMode, required this.onThemeChanged});

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  late ThemeMode _currentThemeMode;

  @override
  void initState() {
    super.initState();
    _currentThemeMode = widget.themeMode;
  }

  void _toggleTheme() {
    setState(() {
      _currentThemeMode = _currentThemeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      widget.onThemeChanged(_currentThemeMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = _currentThemeMode == ThemeMode.light;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Imagen principal de fondo sin desenfoque, ocupando toda la pantalla
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 1.1,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4), // Ajusta la opacidad según lo oscuro que desees
                        BlendMode.darken,
                      ),
                      child: Image.asset(
                        'assets/lemon.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
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
                        icon: Icon(
                          Icons.account_circle,
                          color:Colors.white ,
                        ),
                        onPressed: () {
                          // Acción para el icono de login
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: Colors.white,
                        ),
                        onPressed: _toggleTheme,
                      ),
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
                              color: Color(0xFFF4D516),
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
                        padding: EdgeInsets.all(16.0),
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
                                      color: Color(0xFFF4D516),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
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
                                SizedBox(width: 8),
                                Icon(Icons.search,  color: Color(0xFFF4D516),),
                              ],
                            ),
                            SizedBox(height: 250),
                            // Scroll horizontal con los tipos de cocina dentro del card
                            Container(
                              height: 280,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                children: [
                                  _buildCuisineCardWithHighlight('Cocina', 'China', 'assets/xina.png', isDarkMode),
                                  SizedBox(width: 25),
                                  _buildCuisineCardWithHighlight('Cocina', 'India', 'assets/india.png', isDarkMode),
                                  SizedBox(width: 25),
                                  _buildCuisineCardWithHighlight('Cocina', 'Italiana', 'assets/italia.png', isDarkMode),
                                  SizedBox(width: 25),
                                  _buildCuisineCardWithHighlight('Cocina', 'Mexicana', 'assets/mexico.png', isDarkMode),
                                  SizedBox(width: 25),
                                  _buildCuisineCardWithHighlight('Cocina', 'Japonesa', 'assets/japon.png', isDarkMode),
                                   SizedBox(width: 25),
                                  _buildCuisineCardWithHighlight('Cocina', 'Francesa', 'assets/francia.png', isDarkMode),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
             SizedBox(height: 20),
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
                             color: isDarkMode ? Colors.black : Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'YUMM',
                          style: GoogleFonts.righteous(
                            color: Color(0xFFF4D516),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildDetailedRecipeCard(
                    recetas[0].imagenUrl,
                    recetas[0].titulo,
                    recetas[0].descripcion,
                     recetas[0].autor,
                    true,
                    isDarkMode
                  ),
               const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final receta = recetas[index + 1];
                      return _buildDetailedRecipeCard(
                        receta.imagenUrl,
                        receta.titulo,
                        receta.descripcion,
                        receta.autor,
                        false,
                        isDarkMode
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft, // Asegura que el contenido esté alineado a la izquierda
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
                                color: Color(0xFFF4D516),
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

        SizedBox(height: 30),
             
          Container(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildSeasonCard('Calabazas', 'assets/calabaza.png', Colors.redAccent, false),
                SizedBox(width: 25),
                _buildSeasonCard('Moniato', 'assets/moniato.png', Colors.amberAccent, true),
                SizedBox(width: 25),
                _buildSeasonCard('Caquis', 'assets/caqui.png', Colors.brown, false),
              ],
            ),
          ),


            SizedBox(height: 30),
        ], 
        ),
      ),
    );
  }

  // Widget para crear un card de cada tipo de cocina
  Widget _buildCuisineCardWithHighlight(String firstPart, String highlightedPart, String imagePath, bool isDarkMode) {
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
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: firstPart + ' ',
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
                     color: Color(0xFFF4D516),
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

  // Widget para crear un card de receta detallada con descripción
  Widget _buildDetailedRecipeCard(String imagePath, String title, String description, String author, bool isTop, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: isTop ? 300 : 150, // Fijar una altura estándar para todas las imágenes
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.righteous(
            fontSize: 18,
            fontWeight: FontWeight.bold,
             color: isDarkMode ? Colors.black : Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
             color: isDarkMode ? Colors.grey[800] : Colors.grey[400],
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundImage: AssetImage('assets/author.jpg'), // Imagen del autor
            ),
            SizedBox(width: 6),
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
    );
  }

// Widget para crear un card de ingredientes de temporada
Widget _buildSeasonCard(String title, String imagePath, Color color, bool flip) {
  return Container(
    width: 180,
    height: 180,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
        topLeft: flip ? Radius.circular(100) :  Radius.circular(20),
        topRight: flip ? Radius.circular(20) :  Radius.circular(100),
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    child: Stack(
      children: [
        // Imagen en la parte inferior
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            ),
          ),
        ),
        // Texto que se superpone a la imagen, justo abajo
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.righteous(
                  fontSize: 28,
                  color: flip ? Colors.brown : Color(0xFFF4D516),
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






}
