import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/inventario_page.dart';
import 'screens/clientes_page.dart';
import 'screens/reportes_page.dart';
import 'screens/empleados_page.dart';
import 'screens/pedidos_page.dart';
import 'screens/recibir_producto_page.dart';
import 'screens/configuraciones_page.dart';
import 'screens/login_screen.dart';
import 'screens/finanzas_page.dart'; // Importa la página de Finanzas
import 'screens/ventas_page.dart'; // Importa la página de Venta
import 'screens/vender_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        try {
          print('Navegando a: ${settings.name}');
          print('Argumentos recibidos: ${settings.arguments}');

          final Map<String, dynamic> args = settings.arguments != null &&
                  settings.arguments is Map<String, dynamic>
              ? settings.arguments as Map<String, dynamic>
              : {};

          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginScreen());
            case '/home':
              return MaterialPageRoute(
                builder: (_) => HomeScreen(
                  userId: args['userId'] ?? 0,
                  userName: args['userName'] ?? 'Default User',
                  profilePicUrl:
                      args['profilePicUrl'] ?? 'assets/default_profile.png',
                  permisos: args['permisos'] ?? {},
                ),
              );
            case '/vender':
              return MaterialPageRoute(
                builder: (_) => VenderPage(
                  userId: args['userId'] ?? 0,
                  userName: args['userName'] ?? 'Default User',
                  profilePicUrl:
                      args['profilePicUrl'] ?? 'assets/default_profile.png',
                  permisos: args['permisos'] ?? {},
                ),
              );
            case '/inventario':
              return MaterialPageRoute(
                builder: (_) => InventarioPage(
                  userId: args['userId'] ?? 0,
                  userName: args['userName'] ?? 'Default User',
                  profilePicUrl:
                      args['profilePicUrl'] ?? 'assets/default_profile.png',
                  permisos: args['permisos'] ?? {},
                ),
              );
            case '/clientes':
              return MaterialPageRoute(
                builder: (_) => ClientesPage(
                  userId: args['userId'] ?? 0,
                  userName: args['userName'] ?? 'Default User',
                  profilePicUrl:
                      args['profilePicUrl'] ?? 'assets/default_profile.png',
                  permisos: args['permisos'] ?? {},
                ),
              );
            case '/reportes':
              return MaterialPageRoute(
                builder: (_) => ReportesPage(
                  userId: args['userId'] ?? 0,
                  userName: args['userName'] ?? 'Default User',
                  profilePicUrl:
                      args['profilePicUrl'] ?? 'assets/default_profile.png',
                  permisos: args['permisos'] ?? {},
                ),
              );
            case '/ventas':
              return MaterialPageRoute(
                builder: (_) => VentasPage(
                  userId: args['userId'] ?? 0,
                  userName: args['userName'] ?? 'Default User',
                  profilePicUrl:
                      args['profilePicUrl'] ?? 'assets/default_profile.png',
                  permisos: args['permisos'] ?? {},
                ),
              );
            case '/empleados':
              return MaterialPageRoute(
                builder: (_) => EmpleadosPage(
                  userId: args['userId'] ?? 0,
                  userName: args['userName'] ?? 'Default User',
                  profilePicUrl:
                      args['profilePicUrl'] ?? 'assets/default_profile.png',
                  permisos: args['permisos'] ?? {},
                ),
              );
            case '/pedidos':
              return MaterialPageRoute(
                builder: (_) => PedidosPage(
                  userId: args['userId'] ?? 0,
                  userName: args['userName'] ?? 'Default User',
                  profilePicUrl:
                      args['profilePicUrl'] ?? 'assets/default_profile.png',
                  permisos: args['permisos'] ?? {},
                ),
              );
            case '/recibirProducto':
              return MaterialPageRoute(
                builder: (_) => RecibirProductoPage(
                  userId: args['userId'] ?? 0,
                  userName: args['userName'] ?? 'Default User',
                  profilePicUrl:
                      args['profilePicUrl'] ?? 'assets/default_profile.png',
                  permisos: args['permisos'] ?? {},
                ),
              );
            case '/configuraciones':
              return MaterialPageRoute(
                builder: (_) => ConfiguracionesPage(
                  userId: args['userId'] ?? 0,
                  userName: args['userName'] ?? 'Default User',
                  profilePicUrl:
                      args['profilePicUrl'] ?? 'assets/default_profile.png',
                  permisos: args['permisos'] ?? {},
                ),
              );
            case '/finanzas': // Nueva ruta para Finanzas
              return MaterialPageRoute(
                builder: (_) => FinanzasPage(
                  userId: args['userId'] ?? 0,
                  userName: args['userName'] ?? 'Default User',
                  profilePicUrl:
                      args['profilePicUrl'] ?? 'assets/default_profile.png',
                  permisos: args['permisos'] ?? {},
                ),
              );
            default:
              print('Ruta no encontrada: ${settings.name}');
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: Center(
                    child: Text(
                      'Ruta no encontrada: ${settings.name}',
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                ),
              );
          }
        } catch (e, stackTrace) {
          print('Error al generar la ruta: $e');
          print('StackTrace: $stackTrace');
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text(
                  'Error al generar la ruta: ${settings.name}',
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
