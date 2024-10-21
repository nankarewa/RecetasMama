import 'package:flutter/material.dart';

void main() {
  runApp(RecetasApp());
}

class RecetasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recetario',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ListaRecetas(),
    );
  }
}

class ListaRecetas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recetario'),
      ),
      body: ListView.builder(
        itemCount: recetas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recetas[index].titulo),
            subtitle: Text(recetas[index].descripcion),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetallesReceta(receta: recetas[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetallesReceta extends StatelessWidget {
  final Receta receta;

  DetallesReceta({required this.receta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receta.titulo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredientes:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            for (var ingrediente in receta.ingredientes)
              Text('- $ingrediente', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text(
              'Instrucciones:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              receta.instrucciones,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class Receta {
  final String titulo;
  final String descripcion;
  final List<String> ingredientes;
  final String instrucciones;

  Receta({
    required this.titulo,
    required this.descripcion,
    required this.ingredientes,
    required this.instrucciones,
  });
}

List<Receta> recetas = [
  Receta(
    titulo: 'Tortilla de Patatas',
    descripcion: 'Un clásico español hecho con patatas y huevos.',
    ingredientes: ['4 patatas', '6 huevos', 'Sal', 'Aceite de oliva'],
    instrucciones: '1. Pelar y cortar las patatas...\n2. Freírlas hasta dorar...\n3. Batir los huevos...',
  ),
  Receta(
    titulo: 'Gazpacho',
    descripcion: 'Una sopa fría de tomate, perfecta para el verano.',
    ingredientes: ['6 tomates', '1 pepino', '1 pimiento verde', 'Sal', 'Vinagre', 'Aceite de oliva'],
    instrucciones: '1. Lavar y cortar las verduras...\n2. Licuarlas todas juntas...\n3. Dejar enfriar y servir frío...',
  ),
];
