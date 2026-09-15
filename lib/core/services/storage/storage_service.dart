import 'package:shared_preferences/shared_preferences.dart';

/// Minimal key-value persistence wrapper. Kept as a thin adapter so the
/// data layer depends on this interface rather than shared_preferences
/// directly — swapping storage backends later touches only this file.
class StorageService {
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
