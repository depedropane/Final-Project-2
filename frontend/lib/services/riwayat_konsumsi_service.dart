import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';

class RiwayatKonsumsiObat {
  final int trackingId;
  final int jadwalId;
  final int pasienId;
  final DateTime tanggal;
  final String status; // "taken" atau "missed"
  final String waktu;

  RiwayatKonsumsiObat({
    required this.trackingId,
    required this.jadwalId,
    required this.pasienId,
    required this.tanggal,
    required this.status,
    required this.waktu,
  });

  factory RiwayatKonsumsiObat.fromJson(Map<String, dynamic> json) {
    return RiwayatKonsumsiObat(
      trackingId: json['tracking_id'] ?? 0,
      jadwalId: json['jadwal_id'] ?? 0,
      pasienId: json['pasien_id'] ?? 0,
      tanggal: DateTime.parse(json['tanggal'] ?? DateTime.now().toString()),
      status: json['status'] ?? 'missed',
      waktu: json['waktu'] ?? '00:00',
    );
  }

  Map<String, dynamic> toJson() => {
        'tracking_id': trackingId,
        'jadwal_id': jadwalId,
        'pasien_id': pasienId,
        'tanggal': tanggal.toIso8601String(),
        'status': status,
        'waktu': waktu,
      };
}

class RiwayatKonsumsiService {
  static String get baseUrl => AppConfig.baseUrl;

  // Get all riwayat untuk satu pasien
  static Future<List<RiwayatKonsumsiObat>> getRiwayatByPasien(
      int pasienId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/riwayat/pasien/$pasienId'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'] ?? [];
        return data.map((item) => RiwayatKonsumsiObat.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load riwayat');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get riwayat dalam periode tertentu
  static Future<List<RiwayatKonsumsiObat>> getRiwayatByDateRange(
    int pasienId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final startStr = startDate.toString().split(' ')[0];
      final endStr = endDate.toString().split(' ')[0];

      final response = await http.get(
        Uri.parse(
          '$baseUrl/riwayat/pasien/$pasienId/date-range?start_date=$startStr&end_date=$endStr',
        ),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'] ?? [];
        return data.map((item) => RiwayatKonsumsiObat.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load riwayat');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get compliance stats
  static Future<Map<String, dynamic>> getComplianceStats(int pasienId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/riwayat/compliance/$pasienId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load compliance stats');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create riwayat
  static Future<RiwayatKonsumsiObat> createRiwayat(
      RiwayatKonsumsiObat riwayat) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/riwayat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(riwayat.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return RiwayatKonsumsiObat.fromJson(json['data']);
      } else {
        throw Exception('Failed to create riwayat');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update riwayat
  static Future<void> updateRiwayat(int id, RiwayatKonsumsiObat riwayat) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/riwayat/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(riwayat.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update riwayat');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete riwayat
  static Future<void> deleteRiwayat(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/riwayat/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete riwayat');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
