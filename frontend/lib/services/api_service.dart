import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/pasien_model.dart';
import '../models/jadwal_obat_model.dart';
import 'package:flutter/foundation.dart';

// ─── Riwayat Konsumsi Obat Model ──────────────────────────────────────────────
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

class ApiService {
  // ── Token helpers ────────────────────────────────────────────────────────────
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConfig.tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.tokenKey, token);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.tokenKey);
    await prefs.remove(AppConfig.userIdKey);
    await prefs.remove(AppConfig.userDataKey);
  }

  Future<void> saveUserData(Pasien pasien, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConfig.userIdKey, userId);
    await prefs.setString(AppConfig.userDataKey, jsonEncode(pasien.toJson()));
  }

  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConfig.userIdKey);
  }

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.userRoleKey, role);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConfig.userRoleKey);
  }

  // ── Register ─────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> registerPasien(Pasien pasien) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}${AppConfig.registerPasien}');
      debugPrint('Registering to: $url');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pasien.toJson()),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'],
          'data': data['data']
        };
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Registrasi gagal'
      };
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ── Login Pasien ────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> loginPasien(
      String email, String password) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}${AppConfig.loginPasien}');
      debugPrint('Login Pasien to: $url');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String?;
        final userData = data['data'] as Map<String, dynamic>?;
        final message = data['message'] as String? ?? 'Login berhasil';

        if (token != null && userData != null) {
          await saveToken(token);
          await saveUserRole('pasien');

          // Create Pasien object from response data
          final pasien = Pasien(
            pasienId: userData['id'] as int?,
            nama: userData['nama'] as String? ?? '',
            email: userData['email'] as String? ?? '',
          );

          await saveUserData(pasien, userData['id'] as int? ?? 0);
          return {'success': true, 'message': message, 'data': userData};
        }
      }

      // Handle error response
      try {
        final data = jsonDecode(response.body);
        final message = data['message'] as String? ?? 'Login gagal';
        return {'success': false, 'message': message};
      } catch (_) {
        return {'success': false, 'message': 'Login gagal'};
      }
    } catch (e) {
      debugPrint('Login Pasien Error: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ── Login Nakes (Admin) ──────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> loginNakes(String email, String password) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}${AppConfig.loginNakes}');
      debugPrint('Login Nakes to: $url');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String?;
        final userData = data['data'] as Map<String, dynamic>?;
        final message = data['message'] as String? ?? 'Login berhasil';

        if (token != null && userData != null) {
          await saveToken(token);
          await saveUserRole('nakes');
          return {'success': true, 'message': message, 'data': userData};
        }
      }

      // Handle error response
      try {
        final data = jsonDecode(response.body);
        final message = data['message'] as String? ?? 'Login gagal';
        return {'success': false, 'message': message};
      } catch (_) {
        return {'success': false, 'message': 'Login gagal'};
      }
    } catch (e) {
      debugPrint('Login Nakes Error: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ── Jadwal Obat Hari Ini ──────────────────────────────────────────────────────
  // GET /api/v1/jadwal-obat/:pasien_id
  Future<List<JadwalObatItem>> getJadwalObatHariIni(int pasienId) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/jadwal-obat/$pasienId');
      debugPrint('Fetching jadwal: $url');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['data'] ?? [];
        return list.map((e) => JadwalObatItem.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getJadwalObat: $e');
      return [];
    }
  }

  // ── Update Status Tracking ────────────────────────────────────────────────────
  // PUT /api/v1/jadwal-obat/tracking/:jadwal_obat_id
  Future<bool> updateStatusTracking({
    required int jadwalObatId,
    required int pasienId,
    required int nakesId,
    required String status,
  }) async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/jadwal-obat/tracking/$jadwalObatId');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'pasien_id': pasienId,
          'nakes_id': nakesId,
          'status': status,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updateTracking: $e');
      return false;
    }
  }

  // ── Riwayat Konsumsi ──────────────────────────────────────────────────────────
  // GET /api/v1/riwayat/pasien/:pasien_id
  Future<List<RiwayatKonsumsiObat>> getRiwayatByPasien(int pasienId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/riwayat/pasien/$pasienId'),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'] ?? [];
        return data.map((item) => RiwayatKonsumsiObat.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getRiwayatByPasien: $e');
      return [];
    }
  }

  // GET /api/v1/riwayat/pasien/:pasien_id/date-range
  Future<List<RiwayatKonsumsiObat>> getRiwayatByDateRange(
    int pasienId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final startStr = startDate.toString().split(' ')[0];
      final endStr = endDate.toString().split(' ')[0];
      final response = await http.get(
        Uri.parse(
            '${AppConfig.baseUrl}/riwayat/pasien/$pasienId/date-range?start_date=$startStr&end_date=$endStr'),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'] ?? [];
        return data.map((item) => RiwayatKonsumsiObat.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getRiwayatByDateRange: $e');
      return [];
    }
  }

  // GET /api/v1/riwayat/compliance/:pasien_id
  Future<Map<String, dynamic>> getComplianceStats(int pasienId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/riwayat/compliance/$pasienId'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'taken_doses': 0, 'total_doses': 0, 'percentage': 0};
    } catch (e) {
      debugPrint('Error getComplianceStats: $e');
      return {'taken_doses': 0, 'total_doses': 0, 'percentage': 0};
    }
  }

  // POST /api/v1/riwayat
  Future<RiwayatKonsumsiObat?> createRiwayat(
      RiwayatKonsumsiObat riwayat) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/riwayat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(riwayat.toJson()),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return RiwayatKonsumsiObat.fromJson(json['data']);
      }
      return null;
    } catch (e) {
      debugPrint('Error createRiwayat: $e');
      return null;
    }
  }

  // PUT /api/v1/riwayat/:id
  Future<bool> updateRiwayat(int id, RiwayatKonsumsiObat riwayat) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConfig.baseUrl}/riwayat/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(riwayat.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updateRiwayat: $e');
      return false;
    }
  }

  // DELETE /api/v1/riwayat/:id
  Future<bool> deleteRiwayat(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppConfig.baseUrl}/riwayat/$id'),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error deleteRiwayat: $e');
      return false;
    }
  }
}
