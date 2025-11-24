// Import paket yang dibutuhkan
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'catatan_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const MapScreen());
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
  
}

class _MapScreenState extends State<MapScreen> {
  final List<CatatanModel> _savedNotes = [];
  final MapController _mapController = MapController();

  // Tambahan fungsi ikon marker sesuai tipe
  Icon _getMarkerIcon(String type) {
    if (type == "Restoran") {
      return const Icon(Icons.restaurant, color: Colors.red, size: 35);
    } else if (type == "Rumah") {
      return const Icon(Icons.home, color: Colors.blue, size: 35);
    } else {
      return const Icon(Icons.school, color: Colors.green, size: 35);
    }
  }

  void _showDelete(CatatanModel data) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Hapus Marker"),
        content: Text("Hapus catatan: ${data.note}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _savedNotes.remove(data);
              });
              Navigator.pop(context);
            },
            child: const Text("Hapus"),
          ),
        ],
      );
    },
  );
}

      Future<void> _saveNotes() async {
      final prefs = await SharedPreferences.getInstance();

      List<String> data = _savedNotes.map((note) {
        return jsonEncode({
          "lat": note.position.latitude,
          "lng": note.position.longitude,
          "note": note.note,
          "address": note.address,
          "type": note.type,
        });
      }).toList();

      await prefs.setStringList('saved_notes', data);
    }

    Future<void> _loadNotes() async {
      final prefs = await SharedPreferences.getInstance();
      List<String>? data = prefs.getStringList('saved_notes');

      if (data == null) return;

      _savedNotes.clear();

      for (var item in data) {
        final d = jsonDecode(item);

        _savedNotes.add(
          CatatanModel(
            position: latlong.LatLng(d["lat"], d["lng"]),
            note: d["note"],
            address: d["address"],
            type: d["type"],
          ),
        );
      }

      setState(() {});
    }

      @override
      void initState() {
        super.initState();
        _loadNotes();
      }


  // Fungsi untuk mendapatkan lokasi saat ini
  Future<void> _findMyLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();

    _mapController.move(
      latlong.LatLng(position.latitude, position.longitude),
      15.0,
    );
  }

  // Long press pada peta → tambahkan catatan
  void _handleLongPress(TapPosition tapPosition, latlong.LatLng point) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(point.latitude, point.longitude);

    String address = placemarks.first.street ?? "Alamat tidak dikenal";

    // Tambahan pilih kategori marker
    String? selectedType = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pilih Tipe Lokasi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Restoran"),
                onTap: () => Navigator.pop(context, "Restoran"),
              ),
              ListTile(
                title: const Text("Rumah"),
                onTap: () => Navigator.pop(context, "Rumah"),
              ),
              ListTile(
                title: const Text("Kampus"),
                onTap: () => Navigator.pop(context, "Kampus"),
              ),
            ],
          ),
        );
      },
    );

    if (selectedType == null) return;

    setState(() {
      _savedNotes.add(
        CatatanModel(
          position: point,
          note: "Catatan Baru",
          address: address,
          type: selectedType, 
        ),
      );
    });
     _saveNotes(); // menyimpan setelah menambah marker
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geo-Catatan")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const latlong.LatLng(-6.2, 106.8),
          initialZoom: 13.0,
          onLongPress: _handleLongPress,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),

          MarkerLayer(
            markers: _savedNotes.map(
                  (n) => Marker(
                    point: n.position,
                    child: GestureDetector(
                      onTap: () => _showDelete(n),
                      child: Icon(Icons.location_on, color: Colors.red),
                    ),
                  ),
                ) .toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _findMyLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
