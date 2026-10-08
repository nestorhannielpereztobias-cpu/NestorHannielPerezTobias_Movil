import 'package:flutter/material.dart';
import 'package:mis_lugares_favoritos/models/place_model.dart';
import 'package:mis_lugares_favoritos/services/auth_service.dart';
import 'package:mis_lugares_favoritos/services/places_service.dart';
import 'package:mis_lugares_favoritos/screens/auth/login_screen.dart';
import 'package:mis_lugares_favoritos/screens/places/add_edit_place_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _placesService = PlacesService();
  late Future<List<Place>> _placesFuture;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  void _loadPlaces() {
    setState(() {
      _placesFuture = _placesService.getPlaces();
    });
  }

  Future<void> _deletePlace(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar lugar'),
        content: const Text('¿Estás seguro de que deseas eliminar este lugar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _placesService.deletePlace(id);
        _loadPlaces();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lugar eliminado correctamente')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Lugares Favoritos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recargar',
            onPressed: _loadPlaces,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await _authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Place>>(
        future: _placesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error al cargar lugares: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final places = snapshot.data ?? [];

          if (places.isEmpty) {
            return const Center(
              child: Text(
                'No tienes lugares guardados todavía.\n¡Presiona el botón + para agregar uno!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (place.imageUrl != null)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          place.imageUrl!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 160,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                          ),
                        ),
                      ),
                    ListTile(
                      title: Text(
                        place.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (place.description != null && place.description!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(place.description!),
                            ),
                          Chip(
                            label: Text(
                              place.category,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: Colors.indigo.withAlpha(30),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddEditPlaceScreen(place: place),
                                ),
                              );
                              if (updated == true) _loadPlaces();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deletePlace(place.id),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditPlaceScreen()),
          );
          if (added == true) _loadPlaces();
        },
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Agregar Lugar'),
      ),
    );
  }
}