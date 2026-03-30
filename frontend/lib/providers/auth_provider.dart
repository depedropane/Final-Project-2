import 'package:flutter/foundation.dart';
import '../models/pasien_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Pasien? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  Pasien? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  Future<bool> register(Pasien pasien) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.registerPasien(pasien);

      _isLoading = false;

      if (result['success'] ?? false) {
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'] as String? ?? 'Registrasi gagal';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.loginPasien(email, password);

      _isLoading = false;

      if (result['success'] ?? false) {
        final userData = result['data'] as Map<String, dynamic>?;
        if (userData != null) {
          _currentUser = Pasien(
            pasienId: userData['id'] as int?,
            nama: userData['nama'] as String? ?? '',
            email: userData['email'] as String? ?? '',
          );
          _isAuthenticated = true;
          notifyListeners();
          return true;
        }
      }

      _errorMessage = result['message'] as String? ?? 'Login gagal';
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _apiService.removeToken();
    _currentUser = null;
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
