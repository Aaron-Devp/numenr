import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para usar FilteringTextInputFormatter
import 'package:numenr/widgets/top_bar.dart';
import 'package:numenr/widgets/side_menu.dart';
import 'package:numenr/services/inventory_service.dart';

class InventarioPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String profilePicUrl;
  final Map<String, dynamic> permisos;

  const InventarioPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.profilePicUrl,
    required this.permisos,
  });

  @override
  _InventarioPageState createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  late String fullProfilePicUrl;

  String activeRoute = '/inventario';

  final InventoryService _inventoryService = InventoryService();

  List<Map<String, dynamic>> _categorias = [];
  List<Map<String, dynamic>> _departamentos = [];
  List<Map<String, dynamic>> _marcas = [];
  List<Map<String, dynamic>> _colores = [];
  List<Map<String, dynamic>> _tallas = [];
  List<Map<String, dynamic>> _productos = [];

  String? _nombreProducto;
  int? _categoriaId, _departamentoId, _marcaId, _colorId, _tallaId;
  double? _precioCompra, _precioVenta;
  int? _cantidad;

  @override
  void initState() {
    super.initState();
    fullProfilePicUrl = widget.profilePicUrl.startsWith('http')
        ? widget.profilePicUrl
        : 'http://192.168.1.68:3000/${widget.profilePicUrl}';

    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      _categorias = await _inventoryService.getCategorias();
      _departamentos = await _inventoryService.getDepartamentos();
      _marcas = await _inventoryService.getMarcas();
      _colores = await _inventoryService.getColores();
      _tallas = await _inventoryService.getTallas();
      _productos = await _inventoryService.getProductos();

      setState(() {}); // Refresca la interfaz con los nuevos datos
    } catch (e) {
      _mostrarMensaje('Error al cargar datos: $e');
    }
  }

  void _mostrarMensaje(String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: TextStyle(color: esError ? Colors.red : Colors.green),
        ),
        backgroundColor: esError ? Colors.red[50] : Colors.green[50],
      ),
    );
  }

  Future<void> _buscarProductos(String query) async {
    if (query.isEmpty) {
      await _cargarDatos(); // Si el campo está vacío, recarga todos los productos
      return;
    }

    try {
      final resultados = await _inventoryService.buscarProductos(query);
      setState(() {
        _productos = resultados;
      });
    } catch (e) {
      _mostrarMensaje('Error en la búsqueda: $e', esError: true);
    }
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) {
      _mostrarMensaje('Por favor, corrige los errores antes de continuar.',
          esError: true);
      return;
    }

    _formKey.currentState!.save();

    final producto = {
      'codigo_defecto': null,
      'nombre_producto': _nombreProducto,
      'categoria_id': _categoriaId,
      'departamento_id': _departamentoId,
      'marca_id': _marcaId,
      'color_id': _colorId,
      'talla_id': _tallaId,
      'cantidad': _cantidad,
      'precio_costo': _precioCompra,
      'precio_venta': _precioVenta,
    };

    try {
      await _inventoryService.agregarProducto(producto);
      _mostrarMensaje('Producto agregado correctamente', esError: false);
      _cargarDatos();
    } catch (e) {
      _mostrarMensaje('Error al agregar producto: $e', esError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: TopBar(
        pageTitle: 'Inventario',
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
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (query) => _buscarProductos(query),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        hintText: 'Buscar producto por nombre o código',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          // Encabezado fijo
                          Container(
                            height: 35.0, // Mayor altura para el encabezado
                            color: Colors.brown[300], // Color de fondo
                            child: Row(
                              children: const [
                                SizedBox(
                                  width:
                                      150, // Ancho personalizado para la columna "Código"
                                  child: Center(
                                    child: Text(
                                      'Código',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // Color blanco
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      200, // Ancho personalizado para la columna "Nombre"
                                  child: Center(
                                    child: Text(
                                      'Nombre',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // Color blanco
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      180, // Ancho personalizado para la columna "Precio de compra"
                                  child: Center(
                                    child: Text(
                                      'Precio de compra',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // Color blanco
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      215, // Ancho personalizado para la columna "Precio unitario"
                                  child: Center(
                                    child: Text(
                                      'Precio unitario',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // Color blanco
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      100, // Ancho personalizado para la columna "Cantidad"
                                  child: Center(
                                    child: Text(
                                      'Cantidad',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // Color blanco
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      50, // Ancho personalizado para la columna de acciones
                                  child: Center(
                                    child: Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // Color blanco
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Contenido con scroll
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: _productos.map((producto) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[400]!,
                                        ), // Línea separadora
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Center(
                                            child: Text(
                                              producto['codigo_interno'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Center(
                                            child: Text(
                                              producto['nombre_producto'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 175,
                                          child: Center(
                                            child: Text(
                                              '\$${producto['precio_costo']}',
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 230,
                                          child: Center(
                                            child: Text(
                                              '\$${producto['precio_venta']}',
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Center(
                                            child: Text(
                                              '${producto['cantidad']}',
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                          child: IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                _confirmarEliminacionProducto(
                                                    producto['id']),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEDED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Ingresar Producto',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nombre del Producto',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\s]')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El nombre del producto es obligatorio';
                          }
                          return null;
                        },
                        onSaved: (value) => _nombreProducto = value,
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown('Categoría', _categorias, (value) {
                        _categoriaId = value;
                      }, displayField: (item) => item['nombre']),
                      const SizedBox(height: 8),
                      _buildDropdown('Departamento', _departamentos, (value) {
                        _departamentoId = value;
                      }, displayField: (item) => item['nombre']),
                      const SizedBox(height: 8),
                      _buildDropdown('Marca', _marcas, (value) {
                        _marcaId = value;
                      }, displayField: (item) => item['nombre']),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown('Color', _colores, (value) {
                              _colorId = value;
                            }, displayField: (item) => item['nombre']),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildDropdown('Talla', _tallas, (value) {
                              _tallaId = value;
                            },
                                displayField: (item) =>
                                    '${item['tipo']} - ${item['valor']}'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Precio de Compra',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null ||
                                    double.tryParse(value) == null) {
                                  return 'Precio de compra inválido';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _precioCompra = double.tryParse(value!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Precio Unitario',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null ||
                                    double.tryParse(value) == null) {
                                  return 'Precio unitario inválido';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _precioVenta = double.tryParse(value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Cantidad',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || int.tryParse(value) == null) {
                            return 'Cantidad inválida';
                          }
                          return null;
                        },
                        onSaved: (value) => _cantidad = int.tryParse(value!),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await _guardarProducto();
                          _limpiarFormulario();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Guardar Producto'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarEliminacionProducto(int productoId) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content:
            const Text('¿Está seguro de que desea eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _inventoryService.eliminarProducto(productoId);
      _mostrarMensaje('Producto eliminado correctamente', esError: false);
      _cargarDatos();
    }
  }

  void _limpiarFormulario() {
    _formKey.currentState?.reset();
    _nombreProducto = null;
    _categoriaId = null;
    _departamentoId = null;
    _marcaId = null;
    _colorId = null;
    _tallaId = null;
    _precioCompra = null;
    _precioVenta = null;
    _cantidad = null;
    setState(() {});
  }

  Widget _buildDropdown(
    String label,
    List<Map<String, dynamic>> items,
    void Function(int?) onChanged, {
    required String Function(Map<String, dynamic>) displayField,
  }) {
    return DropdownButtonFormField<int>(
      items: items.isNotEmpty
          ? items.map((item) {
              return DropdownMenuItem<int>(
                value: item['id'],
                child: Text(displayField(item)),
              );
            }).toList()
          : [
              DropdownMenuItem<int>(
                value: null,
                child: Text('Sin datos disponibles'),
              ),
            ],
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null) {
          return 'Selecciona $label';
        }
        return null;
      },
    );
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
}
