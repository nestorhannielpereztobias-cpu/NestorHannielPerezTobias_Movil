class Place {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final String category;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final DateTime createdAt;

  Place({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    required this.createdAt,
  });

  // Convertir respuesta de Supabase (Map/JSON) a objeto Place
  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      category: map['category'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      imageUrl: map['image_url'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // Convertir objeto Place a Map/JSON para enviar a Supabase
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'image_url': imageUrl,
    };
  }
}