import 'dart:convert';
import 'package:http/http.dart' as http;

class InventoryService {
  static const String baseUrl = 'http://192.168.1.68:3000/api/inventory';

  Future<List<Map<String, dynamic>>> getProductos() async {
    final response = await http.get(Uri.parse('$baseUrl/productos'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener productos: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getCategorias() async {
    final response = await http.get(Uri.parse('$baseUrl/categorias'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener categorías: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getDepartamentos() async {
    final response = await http.get(Uri.parse('$baseUrl/departamentos'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener departamentos: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getMarcas() async {
    final response = await http.get(Uri.parse('$baseUrl/marcas'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener marcas: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getColores() async {
    final response = await http.get(Uri.parse('$baseUrl/colores'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else if (response.statusCode == 404) {
      print('No se encontraron colores');
      return [];
    } else {
      throw Exception('Error al obtener colores: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getTallas() async {
    final response = await http.get(Uri.parse('$baseUrl/tallas'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else if (response.statusCode == 404) {
      print('No se encontraron tallas');
      return [];
    } else {
      throw Exception('Error al obtener tallas: ${response.body}');
    }
  }

  Future<void> agregarProducto(Map<String, dynamic> producto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/productos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(producto),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al agregar producto: ${response.body}');
    }
  }

  Future<void> modificarProducto(int id, Map<String, dynamic> producto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/productos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(producto),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al modificar producto: ${response.body}');
    }
  }

  Future<void> eliminarProducto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/productos/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar producto: ${response.body}');
    }
  }

  Future<bool> verificarCodigoInterno(String codigoInterno) async {
    final response =
        await http.get(Uri.parse('$baseUrl/verificar-codigo/$codigoInterno'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['existe'] as bool;
    } else {
      throw Exception('Error al verificar el código interno: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> buscarProductos(String valor) async {
    final response = await http.get(
      Uri.parse('$baseUrl/productos/search?query=$valor'),
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al buscar productos: ${response.body}');
    }
  }
}
