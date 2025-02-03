import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/top_bar.dart';
import '../widgets/side_menu.dart';

class VentasPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String profilePicUrl;
  final Map<String, dynamic> permisos;

  const VentasPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.profilePicUrl,
    required this.permisos,
  });

  @override
  _VentasPageState createState() => _VentasPageState();
}

class _VentasPageState extends State<VentasPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String fullProfilePicUrl;
  String activeRoute = '/ventas';
  String filtroSeleccionado = 'Día';

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

  Widget _buildFiltroVentas() {
    return DropdownButton<String>(
      value: filtroSeleccionado,
      items: const [
        DropdownMenuItem(value: 'Día', child: Text('Día')),
        DropdownMenuItem(value: 'Semana', child: Text('Semana')),
        DropdownMenuItem(value: 'Mes', child: Text('Mes')),
        DropdownMenuItem(value: 'Año', child: Text('Año')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            filtroSeleccionado = value;
          });
        }
      },
    );
  }

  Widget _buildGraficaVentas() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(text: 'Ventas por $filtroSeleccionado'),
      series: <CartesianSeries>[
        ColumnSeries<dynamic, String>(
          dataSource: [
            {'x': 'Lunes', 'y': 20},
            {'x': 'Martes', 'y': 15},
            {'x': 'Miércoles', 'y': 30},
            {'x': 'Jueves', 'y': 25},
            {'x': 'Viernes', 'y': 40},
          ],
          xValueMapper: (data, _) => data['x'] as String,
          yValueMapper: (data, _) => data['y'] as int,
        ),
      ],
    );
  }

  Widget _buildTablaVentas() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('No. Venta')),
        DataColumn(label: Text('Fecha')),
        DataColumn(label: Text('Vendedor')),
        DataColumn(label: Text('Productos')),
        DataColumn(label: Text('Total')),
        DataColumn(label: Text('Descuento')),
      ],
      rows: [
        DataRow(
          cells: [
            const DataCell(Text('001')),
            const DataCell(Text('2025-01-01')),
            const DataCell(Text('Juan Pérez')),
            DataCell(
              const Text('Ver detalles'),
              onTap: () {
                _mostrarDetallesVenta(context, '001');
              },
            ),
            const DataCell(Text('\$200.00')),
            const DataCell(Text('No')),
          ],
        ),
        DataRow(
          cells: [
            const DataCell(Text('002')),
            const DataCell(Text('2025-01-02')),
            const DataCell(Text('María López')),
            DataCell(
              const Text('Ver detalles'),
              onTap: () {
                _mostrarDetallesVenta(context, '002');
              },
            ),
            const DataCell(Text('\$300.00')),
            const DataCell(Text('5%')),
          ],
        ),
      ],
    );
  }

  void _mostrarDetallesVenta(BuildContext context, String ventaId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalles de la Venta $ventaId'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Productos: Camiseta x2, Pantalón x1'),
              Text('Total: \$200.00'),
              Text('Descuento: No'),
              Text('Vendedor: Juan Pérez'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopBar(
        pageTitle: 'Ventas',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Gráfica de Ventas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                _buildFiltroVentas(),
              ],
            ),
            const SizedBox(height: 16),
            _buildGraficaVentas(),
            const SizedBox(height: 16),
            const Text(
              'Historial de Ventas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildTablaVentas(),
            ),
          ],
        ),
      ),
    );
  }
}
