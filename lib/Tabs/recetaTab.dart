import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Model/Receta.dart'; // Importa la clase Receta

class RecetaTab extends StatelessWidget {
  final Receta receta;

  const RecetaTab({super.key, required this.receta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receta.titulo, style: GoogleFonts.righteous()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),
            Text(
              receta.titulo,
              style: GoogleFonts.righteous(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Por: ${receta.autor}',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Text(
              receta.descripcion,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Ingredientes:',
              style: GoogleFonts.righteous(fontSize: 22),
            ),
            const SizedBox(height: 8),
            ...receta.ingredientes.map((ingrediente) => Text(
                  '- ${ingrediente.nombre}: ${ingrediente.cantidad} ${ingrediente.unidad}',
                  style: const TextStyle(fontSize: 14),
                )),
            const SizedBox(height: 16),
            Text(
              'Instrucciones:',
              style: GoogleFonts.righteous(fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(
              receta.instrucciones,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
