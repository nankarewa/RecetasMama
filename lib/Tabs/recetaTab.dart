import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Model/Receta.dart'; // Importa la clase Receta

class RecetaTab extends StatelessWidget {
  final Receta receta;

  RecetaTab({required this.receta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receta.titulo, style: GoogleFonts.righteous()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: receta.imagenUrl.startsWith('http')
                  ? Image.network(
                      receta.imagenUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                    )
                  : Image.asset(
                      receta.imagenUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                    ),
            ),
            SizedBox(height: 16),
            Text(
              receta.titulo,
              style: GoogleFonts.righteous(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Por: ${receta.autor}',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
            Text(
              receta.descripcion,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Ingredientes:',
              style: GoogleFonts.righteous(fontSize: 22),
            ),
            SizedBox(height: 8),
            ...receta.ingredientes.map((ingrediente) => Text(
                  '- ${ingrediente.nombre}: ${ingrediente.cantidad} ${ingrediente.unidad}',
                  style: TextStyle(fontSize: 14),
                )),
            SizedBox(height: 16),
            Text(
              'Instrucciones:',
              style: GoogleFonts.righteous(fontSize: 22),
            ),
            SizedBox(height: 8),
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
