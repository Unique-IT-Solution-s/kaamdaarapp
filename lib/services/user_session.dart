import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSession {
  UserSession._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _userKey = 'kaamdaar_cached_user';

  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user));
  }

  static Future<Map<String, dynamic>> getUser() async {
    final raw = await _storage.read(key: _userKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final value = jsonDecode(raw);
      if (value is Map) return Map<String, dynamic>.from(value);
    } catch (_) {}
    return {};
  }

  static Future<void> updateUser(Map<String, dynamic> updates) async {
    final current = await getUser();
    current.addAll(updates);
    await saveUser(current);
  }

  static Future<void> clearUser() => _storage.delete(key: _userKey);
}
