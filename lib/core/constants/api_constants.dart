class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1'; // Local dev default for Android emulator
  
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String groupsEndpoint = '/groups';
  static const String myGroupsEndpoint = '/members/me/groups';
}
