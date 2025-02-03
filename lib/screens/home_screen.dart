import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:numenr/widgets/top_bar.dart';
import 'package:numenr/widgets/side_menu.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  final String userName;
  final String profilePicUrl;
  final Map<String, dynamic> permisos;

  const HomeScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.profilePicUrl,
    required this.permisos,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String fullProfilePicUrl;
  String activeRoute = '/home';

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
        pageTitle: 'Inicio',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.5,
          children: [
            _buildCard(
              'Resumen del Día',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Ingresos: \$2,500.00'),
                  SizedBox(height: 4),
                  Text('Ventas realizadas: 60'),
                ],
              ),
            ),
            _buildCard(
              'Créditos Pendientes',
              ListView(
                shrinkWrap: true,
                children: const [
                  ListTile(
                      title: Text('Cliente 1', style: TextStyle(fontSize: 12)),
                      trailing: Text('\$600.00')),
                  ListTile(
                      title: Text('Cliente 2', style: TextStyle(fontSize: 12)),
                      trailing: Text('\$150.00')),
                  ListTile(
                      title: Text('Cliente 3', style: TextStyle(fontSize: 12)),
                      trailing: Text('\$200.00')),
                ],
              ),
            ),
            _buildCard(
              'Tendencias de Ventas',
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  ColumnSeries<SalesData, String>(
                    dataSource: [
                      SalesData('Ene', 10000),
                      SalesData('Feb', 8000),
                      SalesData('Mar', 9500),
                    ],
                    xValueMapper: (SalesData sales, _) => sales.month,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                  ),
                ],
              ),
            ),
            _buildCard(
              'Finanzas',
              SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<FinanceData, String>(
                    dataSource: [
                      FinanceData('Ingresos', 5000),
                      FinanceData('Egresos', 3000),
                      FinanceData('Utilidades', 2000),
                    ],
                    xValueMapper: (FinanceData data, _) => data.category,
                    yValueMapper: (FinanceData data, _) => data.amount,
                  ),
                ],
              ),
            ),
            _buildCard(
              'Stock Bajo',
              ListView(
                shrinkWrap: true,
                children: const [
                  ListTile(
                      title: Text('Producto 1', style: TextStyle(fontSize: 12)),
                      trailing: Text('10 Pz')),
                  ListTile(
                      title: Text('Producto 2', style: TextStyle(fontSize: 12)),
                      trailing: Text('4 Pz')),
                ],
              ),
            ),
            _buildCard(
              'Actividad Reciente',
              ListView(
                shrinkWrap: true,
                children: const [
                  ListTile(
                      title: Text('Usuario 1', style: TextStyle(fontSize: 12)),
                      trailing: Text('Venta')),
                  ListTile(
                      title: Text('Usuario 2', style: TextStyle(fontSize: 12)),
                      trailing: Text('Abono')),
                  ListTile(
                      title: Text('Usuario 3', style: TextStyle(fontSize: 12)),
                      trailing: Text('Devolución')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, Widget content) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(child: content),
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

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}

class FinanceData {
  final String category;
  final double amount;

  FinanceData(this.category, this.amount);
}
