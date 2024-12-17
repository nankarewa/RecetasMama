import 'package:recetas/Model/Receta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RecetaApi {
  Future<List<Receta>> getRecetas() async {
    final url = Uri.parse('http://yumm.es/api/recetas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse =
          utf8.decode(response.bodyBytes);
      List<dynamic> data = jsonDecode(decodedResponse);
      return data.map((json) => Receta.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las recetas');
    }
  }
}
