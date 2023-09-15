import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtils {
  static void setSession(String token, String role, String expireAt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('TOKEN', token);
    await prefs.setString('ROLE', role);
    await prefs.setString('EXPIRE', expireAt);
  }

  static void deleteSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
