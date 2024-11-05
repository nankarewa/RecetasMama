class Receta {
  final String titulo;
  final String descripcion;
  final List<String> ingredientes;
  final String instrucciones;
  final String imagenUrl;
  final String autor;

  Receta({
    required this.titulo,
    required this.descripcion,
    required this.ingredientes,
    required this.instrucciones,
    required this.imagenUrl,
    required this.autor,
  });
}
