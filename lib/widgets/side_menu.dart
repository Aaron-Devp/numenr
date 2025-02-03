import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final Map<String, dynamic> permisos;
  final Function(String) onMenuTap;
  final VoidCallback onLogout;
  final String activeRoute; // Ruta activa actual

  const SideMenu({
    super.key,
    required this.permisos,
    required this.onMenuTap,
    required this.onLogout,
    required this.activeRoute, // Recibe la ruta activa
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFBFB8AE), // Fondo beige claro
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Espaciado superior

            // Opciones del menú dinámicas sin íconos, solo texto centrado
            if (permisos['home'] == true)
              _buildMenuItem(
                'Home',
                isActive: activeRoute == '/home',
                onTap: () => onMenuTap('/home'),
              ),
            if (permisos['vender'] == true)
              _buildMenuItem(
                'Vender',
                isActive: activeRoute == '/vender',
                onTap: () => onMenuTap('/vender'),
              ),
            if (permisos['inventario'] == true)
              _buildMenuItem(
                'Inventario',
                isActive: activeRoute == '/inventario',
                onTap: () => onMenuTap('/inventario'),
              ),
            if (permisos['clientes'] == true)
              _buildMenuItem(
                'Clientes',
                isActive: activeRoute == '/clientes',
                onTap: () => onMenuTap('/clientes'),
              ),
            if (permisos['reportes'] == true)
              _buildMenuItem(
                'Reportes',
                isActive: activeRoute == '/reportes',
                onTap: () => onMenuTap('/reportes'),
              ),
            if (permisos['ventas'] == true)
              _buildMenuItem(
                'Ventas',
                isActive: activeRoute == '/ventas',
                onTap: () => onMenuTap('/ventas'),
              ),
            if (permisos['empleados'] == true)
              _buildMenuItem(
                'Empleados',
                isActive: activeRoute == '/empleados',
                onTap: () => onMenuTap('/empleados'),
              ),
            if (permisos['pedidos'] == true)
              _buildMenuItem(
                'Pedidos',
                isActive: activeRoute == '/pedidos',
                onTap: () => onMenuTap('/pedidos'),
              ),

            if (permisos['finanzas'] == true)
              _buildMenuItem(
                'Finanzas',
                isActive: activeRoute == '/finanzas',
                onTap: () => onMenuTap('/finanzas'),
              ),

            if (permisos['recibirProducto'] == true)
              _buildMenuItem(
                'Recibir Producto',
                isActive: activeRoute == '/recibirProducto',
                onTap: () => onMenuTap('/recibirProducto'),
              ),

            const Spacer(), // Empuja las opciones fijas hacia abajo

            // Botón de ajustes al final como ícono
            if (permisos['configuraciones'] == true)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () => onMenuTap('/configuraciones'),
                  child: const Icon(
                    Icons.settings,
                    color: Colors.brown,
                    size: 28,
                  ),
                ),
              ),

            // Botón de cerrar sesión
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: onLogout,
                child: const Icon(Icons.logout, color: Colors.black, size: 28),
              ),
            ),

            const SizedBox(height: 20), // Espaciado inferior
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    String title, {
    VoidCallback? onTap,
    bool isActive = false, // Indica si la opción está activa
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isActive
                ? FontWeight.bold
                : FontWeight.normal, // Negrita si está activa
            color: isActive
                ? Colors.black
                : Colors.grey[800], // Color distintivo si está activa
          ),
          textAlign: TextAlign.center, // Centrado
        ),
      ),
    );
  }
}
