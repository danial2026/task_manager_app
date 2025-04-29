import 'package:shared_preferences/shared_preferences.dart';

class StorageController {
  static const String _accessTokenKey = 'access_token';
  static const String _tokenKey = 'token';
  static const String _user = 'user';

  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  // Token operations
  static Future<void> saveTokens({required String accessToken, required String token}) async {
    final prefs = await _prefs;
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> get getToken async {
    final prefs = await _prefs;
    return prefs.getString(_tokenKey);
  }

  static Future<String?> get getAccessToken async {
    final prefs = await _prefs;
    return prefs.getString(_accessTokenKey);
  }

  static Future<void> get removeToken async {
    final prefs = await _prefs;
    await prefs.remove(_tokenKey);
    await prefs.remove(_accessTokenKey);
  }

  // User data operations
  static Future<void> saveUserData({required String user}) async {
    final prefs = await _prefs;
    await Future.wait([
      prefs.setString(_user, user),
    ]);
  }

  static Future<Map<String, String?>> get getUserData async {
    final prefs = await _prefs;
    return {
      'user': prefs.getString(_user),
    };
  }

  static Future<void> clearUserData() async {
    final prefs = await _prefs;
    await Future.wait([
      prefs.remove(_user),
    ]);
  }

  // Generic operations
  static Future<void> saveData(String key, dynamic value) async {
    final prefs = await _prefs;
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }

  static Future<T?> getData<T>(String key) async {
    final prefs = await _prefs;
    return prefs.get(key) as T?;
  }

  static Future<void> removeData(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }

  static Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}
