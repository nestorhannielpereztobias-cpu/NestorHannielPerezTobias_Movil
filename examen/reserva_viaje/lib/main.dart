import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva de Viaje',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF1F5F5),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00796B)),
        useMaterial3: true,
      ),
      home: const ReservaViajeScreen(),
    );
  }
}

// -------------------------------------------------------------
// PANTALLA 1: FORMULARIO DE RESERVA
// -------------------------------------------------------------
class ReservaViajeScreen extends StatefulWidget {
  const ReservaViajeScreen({super.key});

  @override
  State<ReservaViajeScreen> createState() => _ReservaViajeScreenState();
}

class _ReservaViajeScreenState extends State<ReservaViajeScreen> {
  // Controladores
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _correoCtrl = TextEditingController();

  // Estados
  String _destinoSeleccionado = 'Playa';
  String _transporteSeleccionado = 'Avión';

  bool _hotel = false;
  bool _tour = false;
  bool _seguro = false;

  bool _notificaciones = true;
  double _presupuesto = 3000.0;
  DateTime? _fechaSeleccionada;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _correoCtrl.dispose();
    super.dispose();
  }

  // SnackBar helper
  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Función para limpiar campos
  void _limpiarFormulario() {
    setState(() {
      _nombreCtrl.clear();
      _correoCtrl.clear();
      _destinoSeleccionado = 'Playa';
      _transporteSeleccionado = 'Avión';
      _hotel = false;
      _tour = false;
      _seguro = false;
      _notificaciones = true;
      _presupuesto = 3000.0;
      _fechaSeleccionada = null;
    });
    _mostrarSnackBar('Formulario reiniciado');
  }

  // Formatear fecha
  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return 'Toca para elegir fecha';
    final d = fecha.day.toString().padLeft(2, '0');
    final m = fecha.month.toString().padLeft(2, '0');
    return '$d/$m/${fecha.year}';
  }

  // Obtener texto de extras seleccionados
  String _obtenerTextoExtras() {
    List<String> seleccionados = [];
    if (_hotel) seleccionados.add('Hotel');
    if (_tour) seleccionados.add('Tour');
    if (_seguro) seleccionados.add('Seguro');
    return seleccionados.isEmpty ? 'Ninguno' : seleccionados.join(', ');
  }

  // Validación de datos
  bool _validarDatos() {
    final nombre = _nombreCtrl.text.trim();
    final correo = _correoCtrl.text.trim();
    return (nombre.isNotEmpty && correo.contains('@') && _fechaSeleccionada != null);
  }

  // Modal Alerta Faltan Datos
  void _dialogoFaltanDatos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 28),
            SizedBox(width: 8),
            Text('Faltan datos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Completa nombre, correo válido (@) y selecciona la fecha del viaje.',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido', style: TextStyle(color: Color(0xFF00796B), fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  // Modal Resumen de Viaje
  void _dialogoResumen() {
    if (!_validarDatos()) {
      _dialogoFaltanDatos();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.inventory_2_outlined, color: Color(0xFF00796B), size: 28),
            SizedBox(width: 8),
            Text('Resumen del Viaje', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _filaResumen(Icons.person, 'Nombre:', _nombreCtrl.text.trim(), Colors.teal),
              _filaResumen(Icons.email, 'Correo:', _correoCtrl.text.trim(), Colors.teal),
              _filaResumen(Icons.location_on, 'Destino:', _destinoSeleccionado, Colors.teal),
              _filaResumen(Icons.directions_bus, 'Transporte:', _transporteSeleccionado, Colors.teal),
              _filaResumen(Icons.star, 'Extras:', _obtenerTextoExtras(), Colors.teal),
              _filaResumen(Icons.notifications, 'Notificaciones:', _notificaciones ? 'Activadas' : 'Desactivadas', Colors.teal),
              _filaResumen(Icons.attach_money, 'Presupuesto:', '\$${_presupuesto.toInt()}', Colors.teal),
              _filaResumen(Icons.calendar_month, 'Fecha:', _formatearFecha(_fechaSeleccionada), Colors.teal),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00796B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _irABoleto();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Widget _filaResumen(IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 4),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14))),
        ],
      ),
    );
  }

  void _irABoleto() {
    if (!_validarDatos()) {
      _dialogoFaltanDatos();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoletoScreen(
          nombre: _nombreCtrl.text.trim(),
          correo: _correoCtrl.text.trim(),
          destino: _destinoSeleccionado,
          transporte: _transporteSeleccionado,
          extras: _obtenerTextoExtras(),
          notificaciones: _notificaciones ? 'Activadas' : 'Desactivadas',
          presupuesto: _presupuesto.toInt(),
          fecha: _formatearFecha(_fechaSeleccionada),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva de Viaje', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00796B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services, color: Colors.white),
            tooltip: 'Limpiar',
            onPressed: _limpiarFormulario,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            // SECCIÓN 1: Información general
            _cardContenedor(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.teal.shade50, shape: BoxShape.circle),
                        child: const Icon(Icons.info_outline, color: Color(0xFF00796B)),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sección 1 · Información general', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('Completa tu reserva paso a paso', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Llena tus datos, elige destino y confirma tu viaje.',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // SECCIÓN 2: Datos del viajero
            _cardContenedor(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                        child: const Icon(Icons.person_outline, color: Colors.green),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sección 2 · Datos del viajero', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('¿Quién se va de viaje?', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _nombreCtrl,
                    decoration: _inputDecoration('Nombre completo', 'Ej: Ana García', Icons.person, Colors.green),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _correoCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration('Correo electrónico', 'Ej: ana@correo.com', Icons.email, Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // SECCIÓN 3: Destino y transporte
            _cardContenedor(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
                        child: const Icon(Icons.location_on_outlined, color: Colors.orange),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sección 3 · Destino y transporte', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('Elige tu aventura', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      _tarjetaDestino('Playa', Icons.beach_access, Colors.blue),
                      const SizedBox(width: 8),
                      _tarjetaDestino('Ciudad', Icons.location_city, Colors.orange),
                      const SizedBox(width: 8),
                      _tarjetaDestino('Montaña', Icons.landscape, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 14),

                  const Text('Transporte:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),

                  DropdownButtonFormField<String>(
                    value: _transporteSeleccionado,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      prefixIcon: const Icon(Icons.directions_bus_filled_outlined, color: Colors.orange),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Avión', child: Text('Avión')),
                      DropdownMenuItem(value: 'Autobús', child: Text('Autobús')),
                      DropdownMenuItem(value: 'Tren', child: Text('Tren')),
                      DropdownMenuItem(value: 'Barco', child: Text('Barco')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _transporteSeleccionado = val);
                        _mostrarSnackBar('Transporte seleccionado: $val');
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // SECCIÓN 4: Extras y preferencias
            _cardContenedor(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.purple.shade50, shape: BoxShape.circle),
                        child: const Icon(Icons.tune, color: Colors.purple),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sección 4 · Extras y preferencias', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('Personaliza tu experiencia', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Checkboxes envueltos en Material para evitar la excepción
                  _checkboxItem('Hotel incluido', '+ \$1200', Icons.hotel, _hotel, (v) {
                    setState(() => _hotel = v ?? false);
                    _mostrarSnackBar('Hotel: ${_hotel ? "Agregado" : "Removido"}');
                  }),
                  const SizedBox(height: 8),
                  _checkboxItem('Tour guiado', '+ \$600', Icons.tour, _tour, (v) {
                    setState(() => _tour = v ?? false);
                    _mostrarSnackBar('Tour: ${_tour ? "Agregado" : "Removido"}');
                  }),
                  const SizedBox(height: 8),
                  _checkboxItem('Seguro de viaje', '+ \$400', Icons.health_and_safety, _seguro, (v) {
                    setState(() => _seguro = v ?? false);
                    _mostrarSnackBar('Seguro: ${_seguro ? "Agregado" : "Removido"}');
                  }),
                  const SizedBox(height: 10),

                  // Switch notificaciones con Material
                  Material(
                    color: _notificaciones ? Colors.purple.shade50 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                    child: SwitchListTile(
                      activeColor: Colors.purple,
                      title: const Text('Recibir notificaciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text(_notificaciones ? 'Activadas' : 'Desactivadas', style: TextStyle(color: _notificaciones ? Colors.teal : Colors.grey, fontSize: 12)),
                      value: _notificaciones,
                      onChanged: (v) {
                        setState(() => _notificaciones = v);
                        _mostrarSnackBar('Notificaciones: ${_notificaciones ? "Activadas" : "Desactivadas"}');
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Slider Presupuesto
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Presupuesto:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '\$${_presupuesto.toInt()}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Slider(
                    min: 500,
                    max: 10000,
                    divisions: 20,
                    activeColor: Colors.purple,
                    value: _presupuesto,
                    onChanged: (val) {
                      setState(() => _presupuesto = val);
                    },
                  ),
                  const SizedBox(height: 8),

                  // Selector de fecha
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _fechaSeleccionada ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        helpText: 'Selecciona la fecha del viaje',
                      );
                      if (picked != null) {
                        setState(() => _fechaSeleccionada = picked);
                        _mostrarSnackBar('Fecha elegida: ${_formatearFecha(picked)}');
                      }
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.calendar_month, color: Colors.purple),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Fecha del viaje', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                Text(
                                  _formatearFecha(_fechaSeleccionada),
                                  style: TextStyle(
                                    fontWeight: _fechaSeleccionada != null ? FontWeight.bold : FontWeight.normal,
                                    color: _fechaSeleccionada != null ? Colors.black87 : Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // SECCIÓN 5: Confirmar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF00564D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('Sección 5 · Confirmar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Revisa tus datos antes de despegar 🚀', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.visibility, size: 16, color: Color(0xFF00564D)),
                          label: const Text('Ver Resumen', style: TextStyle(color: Color(0xFF00564D), fontSize: 12, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: _dialogoResumen,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.airplane_ticket, size: 16, color: Colors.black87),
                          label: const Text('Confirmar', style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFA000),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: _irABoleto,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _cardContenedor({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: child,
    );
  }

  Widget _tarjetaDestino(String nombre, IconData icono, Color color) {
    bool isSelected = _destinoSeleccionado == nombre;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _destinoSeleccionado = nombre);
          _mostrarSnackBar('Destino seleccionado: $nombre');
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withAlpha(35) : Colors.white,
            border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: isSelected ? 1.8 : 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icono, color: color, size: 26),
              const SizedBox(height: 4),
              Text(
                nombre,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color : Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint, IconData icon, Color iconColor) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: iconColor),
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
    );
  }

  Widget _checkboxItem(String title, String subtitle, IconData icon, bool value, Function(bool?) onChanged) {
    return Material(
      color: value ? Colors.purple.shade50 : Colors.grey.shade50,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: value ? Colors.purple.shade200 : Colors.transparent),
        ),
        child: CheckboxListTile(
          title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          secondary: Icon(icon, color: value ? Colors.purple : Colors.grey),
          value: value,
          activeColor: Colors.purple,
          onChanged: onChanged,
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// PANTALLA 2: MI BOLETO
// -------------------------------------------------------------
class BoletoScreen extends StatelessWidget {
  final String nombre;
  final String correo;
  final String destino;
  final String transporte;
  final String extras;
  final String notificaciones;
  final int presupuesto;
  final String fecha;

  const BoletoScreen({
    super.key,
    required this.nombre,
    required this.correo,
    required this.destino,
    required this.transporte,
    required this.extras,
    required this.notificaciones,
    required this.presupuesto,
    required this.fecha,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Boleto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00796B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: const Color(0xFF00796B),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.flight_takeoff, color: Colors.white70),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFA000),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(fecha, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black87)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white.withAlpha(50),
                          child: const Icon(Icons.airplanemode_active, color: Colors.white, size: 28),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '¡Buen viaje, $nombre!',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          destino.toUpperCase(),
                          style: const TextStyle(letterSpacing: 2, fontSize: 12, color: Colors.white70, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 130,
                    width: double.infinity,
                    margin: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop&q=60'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: [
                        _itemBoleto(
                          Icons.email,
                          Colors.teal,
                          'Correo',
                          correo,
                          null,
                        ),
                        _itemBoleto(
                          Icons.location_on,
                          Colors.orange,
                          'Destino',
                          destino,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Text(transporte, style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        _itemBoleto(
                          Icons.star,
                          Colors.purple,
                          'Extras',
                          extras,
                          null,
                        ),
                        _itemBoleto(
                          Icons.notifications,
                          Colors.blue,
                          'Notificaciones',
                          notificaciones,
                          Text('\$$presupuesto', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text('Regresar y editar', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _itemBoleto(IconData icon, Color iconColor, String title, String subtitle, Widget? extraTrailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor.withAlpha(25), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Text(subtitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
          if (extraTrailing != null) extraTrailing,
        ],
      ),
    );
  }
}