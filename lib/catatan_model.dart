import 'package:latlong2/latlong.dart';

class CatatanModel {
  final LatLng position;
  final String note;
  final String address;
  final String jenis; // Tambahan untuk Tugas 1 (Rumah/Toko/Kantor)

  CatatanModel({
    required this.position,
    required this.note,
    required this.address,
    required this.jenis,
  });

  // Konversi ke JSON untuk disimpan (Tugas 3)
  Map<String, dynamic> toJson() {
    return {
      'lat': position.latitude,
      'lng': position.longitude,
      'note': note,
      'address': address,
      'jenis': jenis,
    };
  }

  // Konversi dari JSON saat aplikasi dibuka (Tugas 3)
  factory CatatanModel.fromJson(Map<String, dynamic> json) {
    return CatatanModel(
      position: LatLng(json['lat'], json['lng']),
      note: json['note'],
      address: json['address'],
      jenis: json['jenis'] ?? 'Rumah', // Default jika null
    );
  }
}