import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/side_menu.dart';

class EmpleadosPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String profilePicUrl;
  final Map<String, dynamic> permisos;

  const EmpleadosPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.profilePicUrl,
    required this.permisos,
  });

  @override
  _EmpleadosPageState createState() => _EmpleadosPageState();
}

class _EmpleadosPageState extends State<EmpleadosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String fullProfilePicUrl;
  String activeRoute = '/empleados';
  bool isGridView = true;
  bool showEmpleados = true;

  final List<Map<String, dynamic>> empleados = [
    {
      'id': 1,
      'nombre': 'Juan Pérez',
      'apellido': 'Gómez',
      'email': 'juan.perez@gmail.com',
      'telefono': '1234567890',
      'fotoPerfil': 'assets/default_profile.png',
      'fechaIngreso': '2023-01-15',
    },
    {
      'id': 2,
      'nombre': 'María López',
      'apellido': 'Rodríguez',
      'email': 'maria.lopez@gmail.com',
      'telefono': '9876543210',
      'fotoPerfil': 'assets/default_profile.png',
      'fechaIngreso': '2022-05-10',
    },
  ];

  final List<Map<String, dynamic>> usuarios = [
    {
      'id': 1,
      'nombreUsuario': 'juan123',
      'nombre': 'Juan Pérez',
      'fechaRegistro': '2022-02-15',
      'fotoPerfil': 'assets/default_profile.png',
    },
    {
      'id': 2,
      'nombreUsuario': 'maria456',
      'nombre': 'María López',
      'fechaRegistro': '2021-10-10',
      'fotoPerfil': 'assets/default_profile.png',
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
    if (activeRoute == route) return;

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

  void _showEmployeeDetails(Map<String, dynamic> empleado) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text('Detalles de ${empleado['nombre']} ${empleado['apellido']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(empleado['fotoPerfil']),
              radius: 50,
            ),
            const SizedBox(height: 10),
            Text('Email: ${empleado['email']}'),
            Text('Teléfono: ${empleado['telefono']}'),
            Text('Fecha de Ingreso: ${empleado['fechaIngreso']}'),
          ],
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

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles de ${user['nombre']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(user['fotoPerfil']),
              radius: 50,
            ),
            const SizedBox(height: 10),
            Text('Nombre de Usuario: ${user['nombreUsuario']}'),
            Text('Fecha de Registro: ${user['fechaRegistro']}'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              print('Ver ventas de ${user['nombreUsuario']}');
            },
            child: const Text('Ver Ventas'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data =
        showEmpleados ? empleados : usuarios;

    return Scaffold(
      key: _scaffoldKey,
      appBar: TopBar(
        pageTitle: showEmpleados ? 'Empleados' : 'Usuarios',
        userName: widget.userName,
        profilePicUrl: fullProfilePicUrl,
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        onProfileTap: () {},
      ),
      drawer: SideMenu(
        permisos: widget.permisos,
        onMenuTap: _navigateTo,
        onLogout: _logout,
        activeRoute: activeRoute,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: showEmpleados
                          ? 'Buscar empleado...'
                          : 'Buscar usuario...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    print(showEmpleados
                        ? 'Agregar nuevo empleado'
                        : 'Agregar nuevo usuario');
                  },
                  icon: const Icon(Icons.add),
                  color: Colors.blue,
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isGridView = !isGridView;
                    });
                  },
                  icon: Icon(isGridView ? Icons.list : Icons.grid_view),
                  color: Colors.blue,
                  iconSize: 30,
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showEmpleados = !showEmpleados;
                    });
                  },
                  child: Text(showEmpleados ? 'Ver Usuarios' : 'Ver Empleados'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isGridView
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return GestureDetector(
                          onTap: () {
                            showEmpleados
                                ? _showEmployeeDetails(item)
                                : _showUserDetails(item);
                          },
                          child: showEmpleados
                              ? _buildEmployeeCard(item)
                              : _buildUserCard(item),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return GestureDetector(
                          onTap: () {
                            showEmpleados
                                ? _showEmployeeDetails(item)
                                : _showUserDetails(item);
                          },
                          child: showEmpleados
                              ? _buildEmployeeCard(item)
                              : _buildUserCard(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> empleado) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Editar') {
                      print('Editando empleado: ${empleado['nombre']}');
                    } else if (value == 'Eliminar') {
                      print('Eliminando empleado: ${empleado['nombre']}');
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
              ],
            ),
            CircleAvatar(
              backgroundImage: AssetImage(empleado['fotoPerfil']),
              radius: 30,
            ),
            const SizedBox(height: 8),
            Text(
              empleado['nombre'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              empleado['email'],
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Editar') {
                      print('Editando usuario: ${user['nombreUsuario']}');
                    } else if (value == 'Eliminar') {
                      print('Eliminando usuario: ${user['nombreUsuario']}');
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
              ],
            ),
            CircleAvatar(
              backgroundImage: AssetImage(user['fotoPerfil']),
              radius: 30,
            ),
            const SizedBox(height: 8),
            Text(
              user['nombre'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Usuario: ${user['nombreUsuario']}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
