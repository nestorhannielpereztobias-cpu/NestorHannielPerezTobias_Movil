import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mis_lugares_favoritos/core/supabase_constants.dart';
import 'package:mis_lugares_favoritos/models/place_model.dart';

class PlacesService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Obtener la lista de lugares del usuario actual
  Future<List<Place>> getPlaces() async {
    final response = await _supabase
        .from(SupabaseConstants.placesTable)
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((data) => Place.fromMap(data)).toList();
  }

  // 2. Subir imagen a Supabase Storage y retornar su URL pública
  Future<String?> uploadImage(File imageFile) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final path = 'places/$fileName';

      await _supabase.storage
          .from(SupabaseConstants.placesBucket)
          .upload(path, imageFile);

      final imageUrl = _supabase.storage
          .from(SupabaseConstants.placesBucket)
          .getPublicUrl(path);

      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  // 3. Crear un nuevo lugar
  Future<void> createPlace({
    required String name,
    required String? description,
    required String category,
    required double latitude,
    required double longitude,
    String? imageUrl,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    await _supabase.from(SupabaseConstants.placesTable).insert({
      'user_id': user.id,
      'name': name,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
    });
  }

  // 4. Actualizar un lugar existente
  Future<void> updatePlace({
    required String id,
    required String name,
    required String? description,
    required String category,
    required double latitude,
    required double longitude,
    String? imageUrl,
  }) async {
    await _supabase.from(SupabaseConstants.placesTable).update({
      'name': name,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      if (imageUrl != null) 'image_url': imageUrl,
    }).eq('id', id);
  }

  // 5. Eliminar un lugar
  Future<void> deletePlace(String id) async {
    await _supabase.from(SupabaseConstants.placesTable).delete().eq('id', id);
  }
}