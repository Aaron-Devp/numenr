import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart'; // Importar la pantalla Home desde un archivo separado

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _isPasswordVisible = false;
  String? _errorMessage;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    print('Inicio de sesión iniciado...');
    print('Usuario ingresado: $username');
    print('Contraseña ingresada: ${'*' * password.length}');

    try {
      print('Enviando datos al servidor...');
      final response = await http.post(
        Uri.parse('http://192.168.1.68:3000/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('Respuesta recibida con código: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Procesando datos del servidor...');
        final data = jsonDecode(response.body);
        print('Datos recibidos del servidor: $data');

        final user = data['user'];
        if (user != null && user['id'] != null) {
          print('Navegando a HomeScreen con datos del usuario: $user');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                userId: user['id'],
                userName: user['nombre_usuario'],
                profilePicUrl:
                    user['profile_picture'] ?? 'assets/default_profile.png',
                permisos: user['permisos'],
              ),
            ),
          );
        } else {
          print('Error: Datos del usuario no válidos.');
          setState(() {
            _errorMessage = 'Error: Datos del usuario no válidos.';
          });
        }
      } else if (response.statusCode == 401) {
        print('Error: Credenciales inválidas.');
        setState(() {
          _errorMessage = 'Error: Credenciales inválidas.';
        });
      } else {
        final errorData = jsonDecode(response.body);
        print('Error recibido del servidor: ${errorData['message']}');
        setState(() {
          _errorMessage = 'Error: ${errorData['message']}';
        });
      }
    } catch (e) {
      print('Error en la conexión al servidor: $e');
      setState(() {
        _errorMessage =
            'Error al conectar con el servidor. Verifica tu conexión.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 60),
                width: 500,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: const Color(0xFFF5F5F5),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        TextField(
                          controller: _usernameController,
                          focusNode: _usernameFocus,
                          onSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person),
                            labelText: 'Usuario',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          obscureText: !_isPasswordVisible,
                          onSubmitted: (_) {
                            _login();
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _login();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Iniciar Sesión',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 0,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/default_profile.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
