import 'Receta.dart'; // Importar el modelo de Receta

// Lista de recetas de ejemplo
List<Receta> recetas = [
  Receta(
    titulo: 'Tortilla de Patatas',
    descripcion: 'Un clásico español hecho con patatas y huevos.',
    ingredientes: ['4 patatas', '6 huevos', 'Sal', 'Aceite de oliva'],
    instrucciones: '1. Pelar y cortar las patatas...\n2. Freírlas hasta dorar...\n3. Batir los huevos...',
    imagenUrl: 'assets/tortilla.jpg',
  ),
  Receta(
    titulo: 'Gazpacho',
    descripcion: 'Una sopa fría de tomate, perfecta para el verano.',
    ingredientes: ['6 tomates', '1 pepino', '1 pimiento verde', 'Sal', 'Vinagre', 'Aceite de oliva'],
    instrucciones: '1. Lavar y cortar las verduras...\n2. Licuarlas todas juntas...\n3. Dejar enfriar y servir frío...',
    imagenUrl: 'assets/gazpacho.jpg',
  ),
];
