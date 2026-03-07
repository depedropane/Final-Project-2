import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/pasien_model.dart';

class ApiService {
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

  Future<Map<String, dynamic>> registerPasien(Pasien pasien) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}${AppConfig.registerPasien}');
      
      print('Registering to: $url');
      print('Data: ${jsonEncode(pasien.toJson())}');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pasien.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'],
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
          'error': data['error'],
        };
      }
    } catch (e) {
      print('Error: $e');
      return {
        'success': false,
        'message': 'Network error: $e',
        'error': e.toString(),
      };
    }
  }

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
        await saveUserData(Pasien.fromJson(userData), userData['pasien_id']);

        return {'success': true, 'message': data['message'], 'data': data['data']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}