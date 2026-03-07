class AppConfig {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';
  
  static const String registerPasien = '/pasien/register';
  static const String loginPasien = '/pasien/login';
  static const String profilePasien = '/pasien/profile';
  
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userDataKey = 'user_data';
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';
}
