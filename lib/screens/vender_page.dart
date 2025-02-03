import 'package:flutter/material.dart';
import 'package:numenr/widgets/top_bar.dart';
import 'package:numenr/widgets/side_menu.dart';
import 'package:numenr/services/vender_service.dart';

class VenderPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String profilePicUrl;
  final Map<String, dynamic> permisos;

  const VenderPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.profilePicUrl,
    required this.permisos,
  });

  @override
  _VenderPageState createState() => _VenderPageState();
}

class _VenderPageState extends State<VenderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final VentaService _ventaService = VentaService();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();

  late String fullProfilePicUrl;
  String activeRoute = '/vender';
  String selectedPaymentMethod = 'Efectivo'; // Default payment method
  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> products = [];
  double subtotal = 0;
  double total = 0;
  double discount = 0;

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

  void _addToCart(Map<String, dynamic> product, int quantity) {
    setState(() {
      cart.add({
        'id': product['id'],
        'name': product['name'],
        'price': product['price'],
        'quantity': quantity,
        'total': product['price'] * quantity,
      });
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    subtotal = cart.fold(0, (sum, item) => sum + item['total']);
    total = subtotal - (subtotal * (discount / 100));
  }

  Future<void> _searchProducts(String query) async {
    try {
      final results = await _ventaService.searchProducts(query);
      setState(() {
        products = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar productos: $e')),
      );
    }
  }

  Future<void> _processSale() async {
    try {
      final sale = {
        'usuario_id': widget.userId,
        'fecha': DateTime.now().toIso8601String(),
        'total': total,
        'tipo_pago': selectedPaymentMethod,
        'descuento_total': discount,
      };

      final saleResponse = await _ventaService.registrarVenta(sale);
      final saleId = saleResponse['id'];

      final saleDetails = cart
          .map((item) => {
                'venta_id': saleId,
                'producto_id': item['id'],
                'cantidad': item['quantity'],
                'precio_unitario': item['price'],
                'subtotal': item['total'],
              })
          .toList();

      await _ventaService.registrarDetallesVenta(saleDetails);

      for (var item in cart) {
        final newStock = item['stock'] - item['quantity'];
        await _ventaService.actualizarStockProducto(item['id'], newStock);
      }

      setState(() {
        cart.clear();
        subtotal = 0;
        total = 0;
        discount = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venta procesada exitosamente.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al procesar la venta: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopBar(
        pageTitle: 'vender',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (query) {
                      _searchProducts(query);
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 35.0,
                      color: Colors.brown[300],
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                '#',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                'Nombre',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'Precio',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'Cantidad',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'Descuento',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: cart
                              .map((item) => Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                            child: Text(
                                                '${cart.indexOf(item) + 1}')),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(item['name']),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                            child: Text('\$${item['price']}')),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          initialValue: '${item['quantity']}',
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                            child: Text('\$${item['total']}')),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              cart.remove(item);
                                              _calculateTotal();
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 1030,
                height: 230,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRowInput(
                              'Sub Total:', '\$${subtotal.toStringAsFixed(2)}'),
                          const SizedBox(height: 16.0),
                          _buildRowInput('Desc %:', '$discount%',
                              editable: true),
                          const SizedBox(height: 16.0),
                          _buildRowInput(
                              'Total:', '\$${total.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32.0),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRowInput('Paga con:', '\$900.00',
                              editable: true),
                          const SizedBox(height: 16.0),
                          _buildRowInput('Cambio:', '\$0.00'),
                          const SizedBox(height: 16.0),
                          SizedBox(
                            height: 40.0,
                            width: double.infinity,
                            child: DropdownButtonFormField<String>(
                              value: selectedPaymentMethod,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Efectivo',
                                  child: Text('Efectivo'),
                                ),
                                DropdownMenuItem(
                                  value: 'Tarjeta',
                                  child: Text('Tarjeta'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedPaymentMethod = value!;
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32.0),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              cart.clear();
                              _calculateTotal();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 215, 183, 172),
                            minimumSize: const Size(150, 50),
                          ),
                          child: const Text(
                            'Cancelar vender',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            // Lógica para "Generar Rédito" aquí
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 182, 152, 142),
                            minimumSize: const Size(150, 50),
                          ),
                          child: const Text(
                            'Generar Rédito',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: _processSale,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown[300],
                            minimumSize: const Size(150, 50),
                          ),
                          child: const Text(
                            'Cobrar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowInput(String title, String value, {bool editable = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 40.0,
            child: editable
                ? TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
