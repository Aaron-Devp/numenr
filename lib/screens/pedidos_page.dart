import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/side_menu.dart';

class PedidosPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String profilePicUrl;
  final Map<String, dynamic> permisos;

  const PedidosPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.profilePicUrl,
    required this.permisos,
  });

  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String fullProfilePicUrl;
  String activeRoute = '/pedidos';

  final List<Map<String, dynamic>> pedidos = [
    {
      'id': 1,
      'proveedor': 'Proveedor A',
      'telefono': '1234567890',
      'email': 'proveedorA@email.com',
      'productos': [
        {'nombre': 'Camiseta', 'cantidad': 10, 'costo': 50.0},
        {'nombre': 'Pantalón', 'cantidad': 5, 'costo': 100.0},
      ],
      'costoTotal': 750.0,
      'fecha': '2025-01-23',
    },
    {
      'id': 2,
      'proveedor': 'Proveedor B',
      'telefono': '0987654321',
      'email': 'proveedorB@email.com',
      'productos': [
        {'nombre': 'Chaqueta', 'cantidad': 3, 'costo': 300.0},
      ],
      'costoTotal': 900.0,
      'fecha': '2025-01-20',
    },
  ];

  @override
  void initState() {
    super.initState();
    fullProfilePicUrl = widget.profilePicUrl.startsWith('http')
        ? widget.profilePicUrl
        : 'http://192.168.1.68:3000/${widget.profilePicUrl}';
  }

  void _navigateTo(String route) {
    if (activeRoute == route) {
      return;
    }

    setState(() {
      activeRoute = route;
    });

    Navigator.pushReplacementNamed(
      context,
      route,
      arguments: {
        'userId': widget.userId,
        'userName': widget.userName,
        'profilePicUrl': widget.profilePicUrl,
        'permisos': widget.permisos,
      },
    );
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showPedidoDetails(Map<String, dynamic> pedido) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles del Pedido - ${pedido['proveedor']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Teléfono: ${pedido['telefono']}'),
              Text('Email: ${pedido['email']}'),
              const SizedBox(height: 10),
              Text('Productos:',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              ...pedido['productos'].map<Widget>((producto) {
                return Text(
                    '${producto['nombre']} - Cantidad: ${producto['cantidad']} - Costo: \$${producto['costo']}');
              }).toList(),
              const SizedBox(height: 10),
              Text('Costo Total: \$${pedido['costoTotal']}'),
              Text('Fecha: ${pedido['fecha']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showAddPedidoDialog() {
    print('Agregar un nuevo pedido');
    // Implementar la lógica para agregar pedidos
  }

  void _showEditPedidoDialog(Map<String, dynamic> pedido) {
    print('Editar pedido: ${pedido['proveedor']}');
    // Implementar la lógica para editar pedidos
  }

  void _deletePedido(Map<String, dynamic> pedido) {
    setState(() {
      pedidos.remove(pedido);
    });
    print('Pedido eliminado: ${pedido['proveedor']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopBar(
        pageTitle: 'Pedidos',
        userName: widget.userName,
        profilePicUrl: fullProfilePicUrl,
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        onProfileTap: () {},
      ),
      drawer: SideMenu(
        permisos: widget.permisos,
        onMenuTap: (route) {
          _navigateTo(route);
        },
        onLogout: _logout,
        activeRoute: activeRoute,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _showAddPedidoDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo Pedido'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    print('Acceder a Proveedores');
                  },
                  icon: const Icon(Icons.group),
                  label: const Text('Proveedores'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = pedidos[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Proveedor: ${pedido['proveedor']}'),
                      subtitle: Text(
                          'Costo Total: \$${pedido['costoTotal']} - Fecha: ${pedido['fecha']}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'Editar') {
                            _showEditPedidoDialog(pedido);
                          } else if (value == 'Eliminar') {
                            _deletePedido(pedido);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'Editar',
                            child: Text('Editar'),
                          ),
                          const PopupMenuItem(
                            value: 'Eliminar',
                            child: Text('Eliminar'),
                          ),
                        ],
                      ),
                      onTap: () => _showPedidoDetails(pedido),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
