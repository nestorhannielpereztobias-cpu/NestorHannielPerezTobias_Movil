import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Registro de Preferencias',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFBF4FF),
      ),
      home: const RegistroPreferenciasScreen(),
    );
  }
}

class RegistroPreferenciasScreen extends StatefulWidget {
  const RegistroPreferenciasScreen({super.key});

  @override
  State<RegistroPreferenciasScreen> createState() =>
      _RegistroPreferenciasScreenState();
}

class _RegistroPreferenciasScreenState
    extends State<RegistroPreferenciasScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();

  String? _genero = 'Masculino';
  final Map<String, bool> _intereses = {
    'Deporte': false,
    'Musica': false,
    'Cine': false,
    'Lectura': false,
  };
  String _pais = 'Mexico';

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

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Preferencias',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const dynamicColor(0xFF1E88E5),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildSeccion1(),
            const SizedBox(height: 12),
            _buildSeccion2(),
            const SizedBox(height: 12),
            _buildSeccion3(),
            const SizedBox(height: 12),
            _buildSeccion4(),
            const SizedBox(height: 12),
            _buildSeccion5(),
            const SizedBox(height: 16),
            _buildBotonesAccion(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Sección 1: Información General
  Widget _buildSeccion1() {
    return InkWell(
      onTap: () => _mostrarSnackBar('Seleccionada: Sección 1 (Información General)'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F3FD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF90CAF9)),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF1E88E5), size: 22),
                SizedBox(width: 8),
                Text(
                  'Seccion 1: Informacion General',
                  style: TextStyle(
                    color: Color(0xFF1565C0),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              'Completa los siguientes datos personales basicos',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // Sección 2: Datos Personales
  Widget _buildSeccion2() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8EB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA5D6A7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person, color: Color(0xFF2E7D32), size: 22),
              SizedBox(width: 8),
              Text(
                'Seccion 2: Datos Personales',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nombreController,
            onTap: () => _mostrarSnackBar('Seleccionado campo: Nombre completo'),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person, color: Colors.grey),
              hintText: 'Nombre completo',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black38),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _edadController,
            keyboardType: TextInputType.number,
            onTap: () => _mostrarSnackBar('Seleccionado campo: Edad'),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
              hintText: 'Edad',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black38),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sección 3: Distribución en Filas
  Widget _buildSeccion3() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCC80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.view_agenda, color: Color(0xFFE65100), size: 22),
              SizedBox(width: 8),
              Text(
                'Seccion 3: Distribucion en Filas',
                style: TextStyle(
                  color: Color(0xFFE65100),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFilaItem(
            'Fila 1 - Color Rojo',
            const Color(0xFFFFCDD2),
            Colors.red,
          ),
          const SizedBox(height: 8),
          _buildFilaItem(
            'Fila 2 - Color Amarillo',
            const Color(0xFFFFF9C4),
            Colors.yellow.shade700,
          ),
          const SizedBox(height: 8),
          _buildFilaItem(
            'Fila 3 - Color Azul',
            const Color(0xFFBBDEFB),
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildFilaItem(String texto, Color fondo, Color colorCirculo) {
    return InkWell(
      onTap: () => _mostrarSnackBar('Presionaste: $texto'),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: colorCirculo,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              texto,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // Sección 4: Cuatro Hijos en Colores
  Widget _buildSeccion4() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCE93D8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.grid_view, color: Color(0xFF6A1B9A), size: 22),
              SizedBox(width: 8),
              Text(
                'Seccion 4: Cuatro Hijos en Colores',
                style: TextStyle(
                  color: Color(0xFF6A1B9A),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildHijoItem('Hijo 1', const Color(0xFFF8BBD0), Colors.pink),
              const SizedBox(width: 8),
              _buildHijoItem('Hijo 2', const Color(0xFFFFE0B2), Colors.orange),
              const SizedBox(width: 8),
              _buildHijoItem('Hijo 3', const Color(0xFFC8E6C9), Colors.green),
              const SizedBox(width: 8),
              _buildHijoItem('Hijo 4', const Color(0xFFD1C4E9), Colors.deepPurple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHijoItem(String etiqueta, Color fondo, Color colorTexto) {
    return Expanded(
      child: InkWell(
        onTap: () => _mostrarSnackBar('Seleccionado: $etiqueta'),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: fondo,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            etiqueta,
            style: TextStyle(
              color: colorTexto.withValues(alpha: 0.8),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // Sección 5: Controles UI
  Widget _buildSeccion5() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.add_circle_outline, color: Colors.black87, size: 22),
              SizedBox(width: 8),
              Text(
                'Seccion 5: Controles UI',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Genero:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          _buildRadioTile('Masculino'),
          _buildRadioTile('Femenino'),
          _buildRadioTile('Otro'),
          const SizedBox(height: 10),
          const Text(
            'Intereses:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          _buildCheckboxTile('Deporte'),
          _buildCheckboxTile('Musica'),
          _buildCheckboxTile('Cine'),
          _buildCheckboxTile('Lectura'),
          const SizedBox(height: 12),
          const Text(
            'Pais:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black38),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _pais,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                items: ['Mexico', 'España', 'Colombia', 'Argentina', 'Chile']
                    .map((pais) => DropdownMenuItem(
                          value: pais,
                          child: Row(
                            children: [
                              const Icon(Icons.public, color: Colors.black54),
                              const SizedBox(width: 8),
                              Text(pais),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _pais = val);
                    _mostrarSnackBar('País seleccionado: $val');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioTile(String valor) {
    return InkWell(
      onTap: () {
        setState(() => _genero = valor);
        _mostrarSnackBar('Género seleccionado: $valor');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            Radio<String>(
              value: valor,
              groupValue: _genero,
              activeColor: Colors.deepPurple,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (val) {
                setState(() => _genero = val);
                _mostrarSnackBar('Género seleccionado: $val');
              },
            ),
            Text(valor, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxTile(String clave) {
    return InkWell(
      onTap: () {
        setState(() => _intereses[clave] = !(_intereses[clave] ?? false));
        _mostrarSnackBar(
          '${clave}: ${_intereses[clave]! ? "Marcado" : "Desmarcado"}',
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            Checkbox(
              value: _intereses[clave],
              activeColor: Colors.deepPurple,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (val) {
                setState(() => _intereses[clave] = val ?? false);
                _mostrarSnackBar(
                  '$clave: ${val! ? "Marcado" : "Desmarcado"}',
                );
              },
            ),
            Text(clave, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // Botones inferiores
  Widget _buildBotonesAccion() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => _mostrarSnackBar('Botón presionado: Mostrar Preferencias'),
            icon: const Icon(Icons.visibility, size: 18),
            label: const Text(
              'Mostrar Preferencias',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF43A047),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => _mostrarSnackBar('Botón presionado: Guardar Registro'),
            icon: const Icon(Icons.check_circle, size: 18),
            label: const Text(
              'Guardar Registro',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

// Fallback por compatibilidad de sintaxis de color
class dynamicColor extends Color {
  const dynamicColor(super.value);
}