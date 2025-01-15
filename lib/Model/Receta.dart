import 'package:yumm/Model/Ingrediente.dart';

class Receta {
  final int id;
  final String titulo;
  final String descripcion;
  final List<Ingrediente> ingredientes;
  final String instrucciones;
  final String imagenUrl;
  final String autor;

Receta({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.ingredientes,
    required this.instrucciones,
    required this.imagenUrl,
    required this.autor,
  });

  // Método para convertir JSON en una instancia de Receta
  factory Receta.fromJson(Map<String, dynamic> json) {
    var ingredientesJson = json['ingredientes'] as List;
    List<Ingrediente> ingredientes = ingredientesJson
        .map((ingrediente) => Ingrediente.fromJson(ingrediente))
        .toList();

    return Receta(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      ingredientes: ingredientes,
      instrucciones: json['instrucciones'],
      imagenUrl: json['imagenUrl'],
      autor: json['autor'],
    );
  }
}
