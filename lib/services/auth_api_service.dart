
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  static const String _baseUrl = 'http://192.168.1.5:4000/api/v1/auth';

  static Future<Map<String, dynamic>> requestOtp({
    required String phone,
  }) async {
    final uri = Uri.parse('$_baseUrl/otp/request');

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'phone': phone}),
        )
        .timeout(const Duration(seconds: 30));

    return _decodeResponse(response);
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String sessionInfo,
    required String code,
  }) async {
    final uri = Uri.parse('$_baseUrl/otp/verify');

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'phone': phone,
            'sessionInfo': sessionInfo,
            'code': code,
            'platform': 'ANDROID',
          }),
        )
        .timeout(const Duration(seconds: 30));

    return _decodeResponse(response);
  }

  static Map<String, dynamic> _decodeResponse(
    http.Response response,
  ) {
    final dynamic decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid server response.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        decoded['message']?.toString() ?? 'Request failed.',
      );
    }

    return decoded;
  }
}
