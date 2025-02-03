import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/side_menu.dart';

class RecibirProductoPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String profilePicUrl;
  final Map<String, dynamic> permisos;

  const RecibirProductoPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.profilePicUrl,
    required this.permisos,
  });

  @override
  _RecibirProductoPageState createState() => _RecibirProductoPageState();
}

class _RecibirProductoPageState extends State<RecibirProductoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String fullProfilePicUrl;
  String activeRoute = '/recibirProducto';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopBar(
        pageTitle: 'Recibir Producto',
        userName: widget.userName,
        profilePicUrl: fullProfilePicUrl,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onProfileTap: () {},
      ),
      drawer: SideMenu(
        permisos: widget.permisos,
        onMenuTap: _navigateTo,
        onLogout: _logout,
        activeRoute: activeRoute,
      ),
      body: const Center(
        child: Text('Página Recibir Producto', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
