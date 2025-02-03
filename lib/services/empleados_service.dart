import 'dart:convert';
import 'package:http/http.dart' as http;

class EmpleadosService {
  static const String baseUrl = 'http://192.168.1.68:3000/api/empleados';

  Future<List<Map<String, dynamic>>> getEmpleados() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener empleados: ${response.body}');
    }
  }

  Future<void> agregarEmpleado(Map<String, dynamic> empleado) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(empleado),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al agregar empleado: ${response.body}');
    }
  }

  Future<void> modificarEmpleado(int id, Map<String, dynamic> empleado) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(empleado),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al modificar empleado: ${response.body}');
    }
  }

  Future<void> eliminarEmpleado(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar empleado: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> buscarEmpleados(String valor) async {
    final response = await http.get(Uri.parse('$baseUrl/search?query=$valor'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al buscar empleados: ${response.body}');
    }
  }
}
