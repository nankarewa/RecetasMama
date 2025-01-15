import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yumm/Style/AppTheme.dart';
import 'package:yumm/Tabs/mainTab.dart';
import 'Provider/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Yumm App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode, // Usamos ThemeProvider aquí
      home: const MainTab(),
    );
  }
}



// //-------------------------------------------
// class RecetasApp extends StatefulWidget {
//   @override
//   _RecetasAppState createState() => _RecetasAppState();
// }

// class _RecetasAppState extends State<RecetasApp> {
//   // Iniciamos con el tema claro por defecto
//   ThemeMode _themeMode = ThemeMode.light;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       key: ValueKey(_themeMode),
//       title: 'Recetario',
//       theme: AppTheme.lightTheme, // Tema claro
//       darkTheme: AppTheme.darkTheme, // Tema oscuro
//       themeMode: _themeMode, // Usamos la variable para cambiar de tema
//       home: ListaRecetas(
//         onThemeChanged: (ThemeMode mode) {
//           setState(() {
//             _themeMode = mode; // Cambiamos el modo de tema
//           });
//         },
//         themeMode: _themeMode, // Pasamos el tema actual al widget
//       ),
//     );
//   }
// }

// class ListaRecetas extends StatefulWidget {
//   final Function(ThemeMode) onThemeChanged;
//   final ThemeMode themeMode;

//   ListaRecetas({required this.onThemeChanged, required this.themeMode});

//   @override
//   _ListaRecetasState createState() => _ListaRecetasState();
// }

// class _ListaRecetasState extends State<ListaRecetas> {
//   List<Receta> recetasFiltradas = recetas;
//   String _query = '';

//   void _buscarReceta(String query) {
//   setState(() {
//     // Normalizamos el input del usuario eliminando acentos y pasando a minúsculas
//     String normalizedQuery = removeDiacritics(query.toLowerCase());

//     // Filtramos las recetas eliminando acentos y pasando a minúsculas en los títulos
//     recetasFiltradas = recetas.where((receta) {
//       String normalizedTitulo = removeDiacritics(receta.titulo.toLowerCase());
//       return normalizedTitulo.contains(normalizedQuery);
//     }).toList();
//   });
// }



//   String removeDiacritics(String str) {
//   const withDiacritics = 'áàäâãéèëêíìïîóòöôõúùüûñç';
//   const withoutDiacritics = 'aaaaaeeeeiiiiooooouuuunc';

//   for (int i = 0; i < withDiacritics.length; i++) {
//     str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
//   }

//   return str;
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recetario de Mamá'),
//         actions: [
//           // Botón para cambiar entre modo claro y oscuro
//           IconButton(
//             icon: Icon(
//               widget.themeMode == ThemeMode.dark
//                   ? Icons.light_mode // Sol si está en modo oscuro
//                   : Icons.dark_mode, // Luna si está en modo claro
//             ),
//             onPressed: () {
//               // Alternar entre tema claro y oscuro
//               ThemeMode newThemeMode = widget.themeMode == ThemeMode.dark
//                   ? ThemeMode.light
//                   : ThemeMode.dark;
//               widget.onThemeChanged(newThemeMode);
//             },
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(60),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: _buscarReceta,
//               style: TextStyle(color: Colors.black),
//               decoration: InputDecoration(
//                 hintText: 'Buscar receta...',
//                 prefixIcon: Icon(Icons.search, color: Colors.black),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//                  hintStyle: TextStyle(color: Colors.grey),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GridView.builder(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             childAspectRatio: 0.8,
//           ),
//           itemCount: recetasFiltradas.length,
//           itemBuilder: (context, index) {
//             return Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DetallesReceta(
//                         receta: recetasFiltradas[index],
//                       ),
//                     ),
//                   );
//                 },
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(15),
//                       ),
//                      child: Image.asset(
//                       recetasFiltradas[index].imagenUrl,  // Usamos la imagen local desde los assets
//                       height: 120,
//                       fit: BoxFit.cover,
//                     ),

//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             recetasFiltradas[index].titulo,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             recetasFiltradas[index].descripcion,
//                             style: Theme.of(context).textTheme.bodyMedium, // Usamos el texto del tema
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class DetallesReceta extends StatelessWidget {
//   final Receta receta;

//   DetallesReceta({required this.receta});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(receta.titulo),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.asset(
//                 receta.imagenUrl,  // Usamos la ruta local de la imagen en lugar de la URL
//                 fit: BoxFit.cover,
//                 height: 200,
//                 width: double.infinity,
//               ),
//             ),

//             SizedBox(height: 16),
//             Text(
//               'Ingredientes:',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             for (var ingrediente in receta.ingredientes)
//               Text('- $ingrediente', style: TextStyle(fontSize: 16)),
//             SizedBox(height: 20),
//             Text(
//               'Instrucciones:',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             Text(
//               receta.instrucciones,
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
