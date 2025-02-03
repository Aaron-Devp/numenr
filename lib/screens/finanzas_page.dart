import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/top_bar.dart';
import '../widgets/side_menu.dart';

class FinanzasPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String profilePicUrl;
  final Map<String, dynamic> permisos;

  const FinanzasPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.profilePicUrl,
    required this.permisos,
  });

  @override
  _FinanzasPageState createState() => _FinanzasPageState();
}

class _FinanzasPageState extends State<FinanzasPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String fullProfilePicUrl;
  String activeRoute = '/finanzas';

  final List<Map<String, dynamic>> transactions = [
    {'date': '2025-01-01', 'description': 'Venta de camisa', 'amount': 1200.0},
    {
      'date': '2025-01-03',
      'description': 'Compra de material',
      'amount': -500.0
    },
    {
      'date': '2025-01-10',
      'description': 'Venta de pantalón',
      'amount': 1800.0
    },
    {
      'date': '2025-01-15',
      'description': 'Pago de servicios',
      'amount': -300.0
    },
  ];

  double get totalIncome => transactions
      .where((t) => t['amount'] > 0)
      .fold(0.0, (sum, t) => sum + t['amount']);

  double get totalExpenses => transactions
      .where((t) => t['amount'] < 0)
      .fold(0.0, (sum, t) => sum + t['amount'].abs());

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

  void _exportToExcel() {
    print('Exportando datos financieros a Excel...');
  }

  @override
  Widget build(BuildContext context) {
    final double totalBalance = totalIncome - totalExpenses;

    return Scaffold(
      key: _scaffoldKey,
      appBar: TopBar(
        pageTitle: 'Finanzas',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _exportToExcel,
                  icon: const Icon(Icons.download),
                  label: const Text('Exportar a Excel'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    print('Agregando nuevo registro financiero...');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar registro'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Resumen Financiero',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryCard('Ingresos Totales',
                    '\$${totalIncome.toStringAsFixed(2)}', Colors.green),
                _buildSummaryCard('Gastos Totales',
                    '\$${totalExpenses.toStringAsFixed(2)}', Colors.red),
                _buildSummaryCard(
                    'Saldo Neto',
                    '\$${totalBalance.toStringAsFixed(2)}',
                    totalBalance >= 0 ? Colors.green : Colors.red),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Gráficos Financieros',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SfCircularChart(
                      title: ChartTitle(text: 'Distribución de Transacciones'),
                      legend: Legend(isVisible: true),
                      series: <PieSeries<Map<String, dynamic>, String>>[
                        PieSeries<Map<String, dynamic>, String>(
                          dataSource: transactions,
                          xValueMapper: (data, _) => data['description'],
                          yValueMapper: (data, _) => data['amount'].abs(),
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SfCartesianChart(
                      title: ChartTitle(text: 'Ingresos vs. Gastos'),
                      primaryXAxis: CategoryAxis(),
                      series: <ChartSeries>[
                        ColumnSeries<Map<String, dynamic>, String>(
                          dataSource: [
                            {'category': 'Ingresos', 'value': totalIncome},
                            {'category': 'Gastos', 'value': totalExpenses},
                          ],
                          xValueMapper: (data, _) => data['category'],
                          yValueMapper: (data, _) => data['value'],
                          color: Colors.blue,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Transacciones del Mes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(
                        transaction['amount'] > 0
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: transaction['amount'] > 0
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text(transaction['description']),
                      subtitle: Text(transaction['date']),
                      trailing: Text(
                        '\$${transaction['amount'].toStringAsFixed(2)}',
                        style: TextStyle(
                          color: transaction['amount'] > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
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

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
