class AppConfig {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

  // Pasien Endpoints
  static const String registerPasien = '/pasien/register';
  static const String loginPasien = '/auth/pasien/login';
  static const String profilePasien = '/pasien/profile';

  // Nakes Endpoints
  static const String registerNakes = '/nakes/register';
  static const String loginNakes = '/auth/nakes/login';

  // SharedPreferences Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userDataKey = 'user_data';
  static const String userRoleKey = 'user_role';
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';
}
