import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:mis_lugares_favoritos/models/place_model.dart';
import 'package:mis_lugares_favoritos/services/location_service.dart';
import 'package:mis_lugares_favoritos/services/places_service.dart';

class AddEditPlaceScreen extends StatefulWidget {
  final Place? place;

  const AddEditPlaceScreen({super.key, this.place});

  @override
  State<AddEditPlaceScreen> createState() => _AddEditPlaceScreenState();
}

class _AddEditPlaceScreenState extends State<AddEditPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _placesService = PlacesService();
  final _locationService = LocationService();

  String _selectedCategory = 'Restaurante';
  final List<String> _categories = [
    'Restaurante',
    'Parque',
    'Cafetería',
    'Museo',
    'Mirador',
    'Otro'
  ];

  LatLng? _selectedLocation;
  File? _selectedImage;
  bool _isLoading = false;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    if (widget.place != null) {
      _nameController.text = widget.place!.name;
      _descController.text = widget.place!.description ?? '';
      _selectedCategory = widget.place!.category;
      _selectedLocation = LatLng(widget.place!.latitude, widget.place!.longitude);
    } else {
      _fetchCurrentLocation();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocation() async {
    final location = await _locationService.getCurrentLocation();
    if (location != null && mounted) {
      setState(() {
        _selectedLocation = location;
      });
      _mapController.move(location, 15.0);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _savePlace() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una ubicación en el mapa')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? imageUrl = widget.place?.imageUrl;

      if (_selectedImage != null) {
        final uploadedUrl = await _placesService.uploadImage(_selectedImage!);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      if (widget.place == null) {
        await _placesService.createPlace(
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          category: _selectedCategory,
          latitude: _selectedLocation!.latitude,
          longitude: _selectedLocation!.longitude,
          imageUrl: imageUrl,
        );
      } else {
        await _placesService.updatePlace(
          id: widget.place!.id,
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          category: _selectedCategory,
          latitude: _selectedLocation!.latitude,
          longitude: _selectedLocation!.longitude,
          imageUrl: imageUrl,
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.place != null;
    final defaultPosition = _selectedLocation ?? const LatLng(22.1565, -100.9855); // San Luis Potosí por defecto

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Lugar' : 'Nuevo Lugar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isLoading ? null : _savePlace,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Sección Imagen
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => SafeArea(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Galería'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImage(ImageSource.gallery);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Cámara'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _pickImage(ImageSource.camera);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity),
                              )
                            : (widget.place?.imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(widget.place!.imageUrl!, fit: BoxFit.cover, width: double.infinity),
                                  )
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                                      SizedBox(height: 8),
                                      Text('Toca para agregar una fotografía', style: TextStyle(color: Colors.grey)),
                                    ],
                                  )),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campos de texto
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del lugar *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Ingresa un nombre' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dropdown Categoría
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                      ),
                      items: _categories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 20),

                    // Mapa OpenStreetMap con flutter_map
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ubicación (toca en el mapa para marcar):',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.my_location, color: Colors.indigo),
                          tooltip: 'Mi ubicación actual',
                          onPressed: _fetchCurrentLocation,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: defaultPosition,
                            initialZoom: 14.0,
                            onTap: (_, point) {
                              setState(() {
                                _selectedLocation = point;
                              });
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.mis_lugares_favoritos',
                            ),
                            if (_selectedLocation != null)
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: _selectedLocation!,
                                    width: 40,
                                    height: 40,
                                    child: const Icon(
                                      Icons.location_on,
                                      size: 40,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _savePlace,
                      icon: const Icon(Icons.save),
                      label: Text(isEditing ? 'Actualizar Lugar' : 'Guardar Lugar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}