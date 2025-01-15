import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/IngredienteTemporada.dart';

class Mainmenuapi {
  static Future<List<IngredienteTemporada>> fetchIngredientesTemporada() async {
    String temporada = "Otoño";
    final response =
        await http.get(Uri.parse('http://yumm.es/api/ingredientes/temporada?temporada=$temporada'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => IngredienteTemporada.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los ingredientes de temporada');
    }
  }
}
