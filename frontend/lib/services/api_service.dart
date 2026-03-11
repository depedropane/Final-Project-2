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
        return {'success': true, 'message': data['message'], 'data': data['data']};
      }
      return {'success': false, 'message': data['message'] ?? 'Registrasi gagal'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ── Login ────────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> loginPasien(String email, String password) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}${AppConfig.loginPasien}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = data['data']['token'];
        final userData = data['data']['user'];
        await saveToken(token);
        await saveUserData(Pasien.fromJson(userData), userData['pasien_id'] ?? 0);
        return {'success': true, 'message': data['message'], 'data': data['data']};
      }
      return {'success': false, 'message': data['message'] ?? 'Login gagal'};
    } catch (e) {
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
      final url = Uri.parse(
          '${AppConfig.baseUrl}/jadwal-obat/tracking/$jadwalObatId');

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
}