import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Retrieve token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Delete token
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Check if token exists
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
