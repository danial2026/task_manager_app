import 'package:jwt_decoder/jwt_decoder.dart';

class JWTUtils {
  static Future<bool> isTokenExpired(String? token) async {
    if (token == null) return false;

    return JwtDecoder.isExpired(token);
  }

  static Future<int?> getUserId(String? token) async {
    if (token == null) return null;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    return decodedToken['sub'] ?? 0;
  }

  static Future<String?> getUserEmail(String? token) async {
    if (token == null) return null;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    return decodedToken['email'];
  }

  static Future<bool> isEmailVerified(String? token) async {
    if (token == null) return false;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    return decodedToken['emailVerified'];
  }

  static Future<bool> isLoggedIn(String? token) async {
    if (token == null || token == '') return false;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    return decodedToken['sub'] is int;
  }
}
