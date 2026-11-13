import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String baseUrl = 'http://192.168.1.15:4000';

  static Future<Map<String, dynamic>> requestOtp(
    String phone,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/otp/request'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(data.toString());
  }
}