import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/top_bar.dart';
import '../widgets/side_menu.dart';

class ReportesPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String profilePicUrl;
  final Map<String, dynamic> permisos;

  const ReportesPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.profilePicUrl,
    required this.permisos,
  });

  @override
  _ReportesPageState createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String fullProfilePicUrl;
  String activeRoute = '/reportes';

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

  Widget _buildReportSection({
    required String title,
    required Widget chart,
    required Widget table,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 300,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: chart,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Container(
                height: 300,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: table,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildExportButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Logic for exporting data to Excel goes here
      },
      icon: const Icon(Icons.file_download),
      label: const Text('Exportar a Excel'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopBar(
        pageTitle: 'Reportes',
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
            _buildReportSection(
              title: 'Reportes de Ventas',
              chart: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'Ventas Mensuales'),
                series: <CartesianSeries>[
                  // Cambiado de ChartSeries a CartesianSeries
                  ColumnSeries<dynamic, String>(
                    dataSource: [
                      {'x': 'Enero', 'y': 30},
                      {'x': 'Febrero', 'y': 40},
                      {'x': 'Marzo', 'y': 35},
                    ],
                    xValueMapper: (data, _) => data['x'] as String,
                    yValueMapper: (data, _) => data['y'] as int,
                  )
                ],
              ),
              table: DataTable(
                columns: const [
                  DataColumn(label: Text('Fecha')),
                  DataColumn(label: Text('Ventas')),
                  DataColumn(label: Text('Ingresos')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('01/01/2025')),
                    DataCell(Text('20')),
                    DataCell(Text('\$200')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('02/01/2025')),
                    DataCell(Text('30')),
                    DataCell(Text('\$300')),
                  ]),
                ],
              ),
            ),
            _buildReportSection(
              title: 'Niveles de Inventario',
              chart: SfCircularChart(
                title: ChartTitle(text: 'Distribución de Inventario'),
                series: <CircularSeries>[
                  // Cambiado para compatibilidad
                  PieSeries<dynamic, String>(
                    dataSource: [
                      {'x': 'Camisetas', 'y': 50},
                      {'x': 'Pantalones', 'y': 20},
                      {'x': 'Zapatos', 'y': 30},
                    ],
                    xValueMapper: (data, _) => data['x'] as String,
                    yValueMapper: (data, _) => data['y'] as int,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
              table: DataTable(
                columns: const [
                  DataColumn(label: Text('Producto')),
                  DataColumn(label: Text('Cantidad')),
                  DataColumn(label: Text('Estado')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Camiseta')),
                    DataCell(Text('50')),
                    DataCell(Text('Disponible')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Pantalón')),
                    DataCell(Text('20')),
                    DataCell(Text('Bajo stock')),
                  ]),
                ],
              ),
            ),
            _buildReportSection(
              title: 'Tendencias de Ingresos',
              chart: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'Tendencias de Ingresos'),
                series: <CartesianSeries>[
                  // Cambiado de ChartSeries a CartesianSeries
                  LineSeries<dynamic, String>(
                    dataSource: [
                      {'x': 'Enero', 'y': 5000},
                      {'x': 'Febrero', 'y': 4500},
                      {'x': 'Marzo', 'y': 4700},
                    ],
                    xValueMapper: (data, _) => data['x'] as String,
                    yValueMapper: (data, _) => data['y'] as int,
                  )
                ],
              ),
              table: DataTable(
                columns: const [
                  DataColumn(label: Text('Mes')),
                  DataColumn(label: Text('Ingresos Proyectados')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Enero')),
                    DataCell(Text('\$5000')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Febrero')),
                    DataCell(Text('\$4500')),
                  ]),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _buildExportButton(),
            ),
          ],
        ),
      ),
    );
  }
}
