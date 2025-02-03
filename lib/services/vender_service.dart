import 'dart:convert';
import 'package:http/http.dart' as http;

class VentaService {
  static const String baseUrl = 'http://192.168.1.68:3000/api';

  // Registrar una nueva venta
  Future<Map<String, dynamic>> registrarVenta(
      Map<String, dynamic> venta) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ventas'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(venta),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al registrar venta: ${response.body}');
    }
  }

  // Registrar detalles de una venta
  Future<void> registrarDetallesVenta(
      List<Map<String, dynamic>> detalles) async {
    final response = await http.post(
      Uri.parse('$baseUrl/detalles-venta'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(detalles),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al registrar detalles de venta: ${response.body}');
    }
  }

  // Actualizar el stock de un producto
  Future<void> actualizarStockProducto(
      int productoId, int nuevaCantidad) async {
    final response = await http.put(
      Uri.parse('$baseUrl/productos/$productoId/stock'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'cantidad': nuevaCantidad}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar stock: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    final response =
        await http.get(Uri.parse('$baseUrl/productos/search?query=$query'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al buscar productos: ${response.body}');
    }
  }
}
