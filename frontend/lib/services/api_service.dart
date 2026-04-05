import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/pasien_model.dart';
import '../models/jadwal_obat_model.dart';
import 'package:flutter/foundation.dart';

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

  // ── Get Compliance Stats ──────────────────────────────────────────────────────
  // GET /api/v1/riwayat/compliance/:pasien_id
  Future<Map<String, dynamic>> getComplianceStats(int pasienId) async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/riwayat/compliance/$pasienId');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'takenDoses': data['taken_doses'] ?? 0,
          'totalDoses': data['total_doses'] ?? 0,
          'percentage': data['percentage'] ?? 0.0,
        };
      }
      return {'success': false, 'percentage': 0.0, 'takenDoses': 0, 'totalDoses': 0};
    } catch (e) {
      debugPrint('Error getComplianceStats: $e');
      return {'success': false, 'percentage': 0.0, 'takenDoses': 0, 'totalDoses': 0};
    }
  }

  // ── Get Tracking by Date Range ────────────────────────────────────────────────
  // GET /api/v1/riwayat/pasien/:pasien_id/date-range?start_date=...&end_date=...
  Future<List<Map<String, dynamic>>> getTrackingByDateRange({
    required int pasienId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final startStr = startDate.toIso8601String().split('T')[0];
      final endStr = endDate.toIso8601String().split('T')[0];

      final url = Uri.parse(
        '${AppConfig.baseUrl}/riwayat/pasien/$pasienId/date-range?start_date=$startStr&end_date=$endStr',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] is List) {
          return List<Map<String, dynamic>>.from(
            (data['data'] as List).map((item) => item as Map<String, dynamic>),
          );
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error getTrackingByDateRange: $e');
      return [];
    }
  }

  // ── Get Tracking by Pasien ID ─────────────────────────────────────────────────
  // GET /api/v1/riwayat/pasien/:pasien_id
  Future<List<Map<String, dynamic>>> getTrackingByPasien(int pasienId) async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/riwayat/pasien/$pasienId');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] is List) {
          return List<Map<String, dynamic>>.from(
            (data['data'] as List).map((item) => item as Map<String, dynamic>),
          );
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error getTrackingByPasien: $e');
      return [];
    }
  }
}
