class IngredienteTemporada {
  final String nombre;
  final String imagenUrl;
  final String color;

  IngredienteTemporada({
    required this.nombre,
    required this.imagenUrl,
    required this.color,
  });

  factory IngredienteTemporada.fromJson(Map<String, dynamic> json) {
    return IngredienteTemporada(
      nombre: json['nombre'],
      imagenUrl: json['imagenUrl'],
      color: json['color'],
    );
  }
}
