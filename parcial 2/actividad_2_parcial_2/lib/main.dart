import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Supabase con tus credenciales
  await Supabase.initialize(
    url: 'https://igjiirtcydoubtyxyktr.supabase.co',
    anonKey: 'sb_publishable_bdQJWV6AJ86pSuiMuRCUXQ_BpN6AZ6l',
  );

  runApp(const ReproductorApp());
}

final supabase = Supabase.instance.client;

class ReproductorApp extends StatelessWidget {
  const ReproductorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reproductor Supabase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CancionesPage(),
    );
  }
}

class CancionesPage extends StatefulWidget {
  const CancionesPage({super.key});

  @override
  State<CancionesPage> createState() => _CancionesPageState();
}

class _CancionesPageState extends State<CancionesPage> {
  late final Future<List<Map<String, dynamic>>> _cancionesFuture;

  @override
  void initState() {
    super.initState();
    // Consulta a la tabla canciones creada en Supabase
    _cancionesFuture = supabase
        .from('canciones')
        .select()
        .order('id', ascending: true);
  }

  // Convierte los segundos de duración a formato mm:ss
  String _formatearDuracion(int? segundos) {
    if (segundos == null || segundos <= 0) return '--:--';
    final min = segundos ~/ 60;
    final sec = segundos % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canciones (Parcial 2 - Act. 2)'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _cancionesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error al consultar Supabase:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final canciones = snapshot.data ?? [];

          if (canciones.isEmpty) {
            return const Center(
              child: Text('No hay canciones registradas en la base de datos.'),
            );
          }

          return ListView.separated(
            itemCount: canciones.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final song = canciones[index];
              final bool esFavorita = song['favorita'] ?? false;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple.shade100,
                  child: const Icon(Icons.music_note, color: Colors.deepPurple),
                ),
                title: Text(
                  song['titulo'] ?? 'Sin título',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${song['artista'] ?? 'Artista'} • ${song['album'] ?? 'Sin álbum'} (${song['anio'] ?? 'N/A'})',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatearDuracion(song['duracion_seg']),
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      esFavorita ? Icons.favorite : Icons.favorite_border,
                      color: esFavorita ? Colors.red : Colors.grey,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}