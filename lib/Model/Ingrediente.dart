class Ingrediente {
  final int ingredienteId;
  final String nombre;
  final String cantidad;
  final String unidad;

  Ingrediente({
    required this.ingredienteId,
    required this.nombre,
    required this.cantidad,
    required this.unidad,
  });

  // Método para convertir JSON en una instancia de Ingrediente
  factory Ingrediente.fromJson(Map<String, dynamic> json) {
    return Ingrediente(
      ingredienteId: json['ingrediente_id'],
      nombre: json['nombre'],
      cantidad: json['cantidad'],
      unidad: json['unidad'],
    );
  }
}