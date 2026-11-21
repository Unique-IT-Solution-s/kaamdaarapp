
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  // ==========================================
  // BASE URL
  // ==========================================

  static const String _baseUrl =
      'http://192.168.1.4:4000/api/v1/auth';

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  static const String _tokenKey = 'kaamdaar_access_token';

  static const Duration _timeout = Duration(seconds: 30);

  // ==========================================
  // TOKEN MANAGEMENT
  // ==========================================

  static Future<void> saveAccessToken(String token) async {
    final cleanToken = token.trim();

    if (cleanToken.isEmpty) {
      throw Exception('Access token is missing.');
    }

    await _storage.write(
      key: _tokenKey,
      value: cleanToken,
    );

    debugPrint('ACCESS TOKEN SAVED SUCCESSFULLY');
  }

  static Future<String?> getAccessToken() async {
    final token = await _storage.read(key: _tokenKey);

    if (token == null || token.trim().isEmpty) {
      debugPrint('ACCESS TOKEN NOT FOUND');
      return null;
    }

    debugPrint('ACCESS TOKEN FOUND');
    debugPrint('TOKEN LENGTH: ${token.trim().length}');

    return token.trim();
  }

  static Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    debugPrint('LOGIN SESSION CLEARED');
  }

  // ==========================================
  // AUTH HEADERS
  // ==========================================

  static Future<Map<String, String>> _authHeaders() async {
    final token = await getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Authentication token is missing. Please login again.',
      );
    }

    debugPrint('AUTH HEADER: ACCESS TOKEN ATTACHED');

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',

      // Custom backend token header
      'accesstoken': token,

      // Standard Bearer authentication
      'Authorization': 'Bearer $token',

      // Alternative custom token header
      'x-access-token': token,
    };
  }

  // ==========================================
  // REQUEST OTP
  // POST /otp/request
  // ==========================================

  static Future<Map<String, dynamic>> requestOtp({
    required String phone,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/otp/request'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'phone': phone.trim(),
            }),
          )
          .timeout(_timeout);

      debugPrint('REQUEST OTP STATUS: ${response.statusCode}');
      debugPrint('REQUEST OTP RESPONSE: ${response.body}');

      return _decodeResponse(response);
    } catch (e) {
      debugPrint('REQUEST OTP ERROR: $e');
      rethrow;
    }
  }

  // ==========================================
  // VERIFY OTP
  // POST /otp/verify
  // ==========================================

  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String sessionInfo,
    required String code,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/otp/verify'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'phone': phone.trim(),
              'sessionInfo': sessionInfo,
              'code': code.trim(),
              'platform': 'ANDROID',
            }),
          )
          .timeout(_timeout);

      debugPrint('VERIFY OTP STATUS: ${response.statusCode}');

      final result = _decodeResponse(response);

      // Save access token after successful OTP verification.
      final data = result['data'];

      if (data is Map) {
        final token = data['accessToken']?.toString();

        if (token != null && token.trim().isNotEmpty) {
          await saveAccessToken(token);
        } else {
          debugPrint('WARNING: OTP response has no accessToken');
        }
      }

      return result;
    } catch (e) {
      debugPrint('VERIFY OTP ERROR: $e');
      rethrow;
    }
  }

  // ==========================================
  // GET LOGGED-IN USER
  // GET /me
  // ==========================================

  static Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/me'),
            headers: await _authHeaders(),
          )
          .timeout(_timeout);

      debugPrint('GET ME STATUS: ${response.statusCode}');
      debugPrint('GET ME RESPONSE: ${response.body}');

      return _decodeResponse(response);
    } catch (e) {
      debugPrint('GET ME ERROR: $e');
      rethrow;
    }
  }

  // ==========================================
  // UPDATE PROFILE
  // PATCH /updateProfileController
  // ==========================================

  static Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      final headers = await _authHeaders();

      final body = {
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'email': email.trim(),
      };

      debugPrint('UPDATE PROFILE REQUEST STARTED');
      debugPrint('PROFILE EMAIL: ${email.trim()}');

      final response = await http
          .patch(
            Uri.parse('$_baseUrl/updateProfileController'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      debugPrint('PROFILE STATUS: ${response.statusCode}');
      debugPrint('PROFILE RESPONSE: ${response.body}');

      final result = _decodeResponse(response);

      final success =
          result['success'] == true ||
          result['status'] == true;

      if (!success) {
        throw Exception(
          result['message']?.toString() ??
              'Profile update failed.',
        );
      }

      return result;
    } catch (e) {
      debugPrint('PROFILE UPDATE ERROR: $e');
      rethrow;
    }
  }

  // ==========================================
  // LOGOUT
  // POST /logout
  // ==========================================

  static Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/logout'),
            headers: await _authHeaders(),
          )
          .timeout(_timeout);

      final result = _decodeResponse(response);

      await clearSession();

      return result;
    } catch (e) {
      debugPrint('LOGOUT ERROR: $e');
      rethrow;
    }
  }

  // ==========================================
  // LOGOUT ALL SESSIONS
  // POST /logout-all
  // ==========================================

  static Future<Map<String, dynamic>> logoutAll() async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/logout-all'),
            headers: await _authHeaders(),
          )
          .timeout(_timeout);

      final result = _decodeResponse(response);

      await clearSession();

      return result;
    } catch (e) {
      debugPrint('LOGOUT ALL ERROR: $e');
      rethrow;
    }
  }

  // ==========================================
  // COMMON RESPONSE HANDLER
  // ==========================================

  static Map<String, dynamic> _decodeResponse(
    http.Response response,
  ) {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception(
        'Invalid server response. HTTP ${response.statusCode}',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid API response format.');
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        decoded['message']?.toString() ??
            'API request failed. HTTP ${response.statusCode}',
      );
    }

    return decoded;
  }
}
