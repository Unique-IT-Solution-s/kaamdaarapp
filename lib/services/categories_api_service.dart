import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_session.dart';

class ServiceCategory {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String? imageUrl;
  final String? icon;
  final bool isActive;
  final bool isFeatured;
  final int sortOrder;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.imageUrl,
    required this.icon,
    required this.isActive,
    required this.isFeatured,
    required this.sortOrder,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    return ServiceCategory(
      id: (json['_id'] ?? '').toString(),
      name: (json['category_name'] ?? 'Service').toString(),
      slug: (json['slug'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      imageUrl: image is Map ? image['url']?.toString() : null,
      icon: json['icon']?.toString(),
      isActive: json['is_active'] == true,
      isFeatured: json['is_featured'] == true,
      sortOrder: int.tryParse('${json['sort_order'] ?? 0}') ?? 0,
    );
  }
}

class CategoriesApiService {
  static const String _url =
      'http://192.168.1.4:4000/api/v1/admin/categories';

  static Future<String> _getToken() async {
    final user = await UserSession.getUser();
    String? token;
    for (final key in ['accessToken', 'access_token', 'token']) {
      final value = user[key];
      if (value is String && value.trim().isNotEmpty) {
        token = value.trim();
        break;
      }
    }
    if (token == null && user['tokens'] is Map) {
      final tokens = Map<String, dynamic>.from(user['tokens'] as Map);
      token = (tokens['accessToken'] ?? tokens['access_token'] ?? tokens['access'])?.toString();
    }
    if (token == null || token.trim().isEmpty) {
      throw Exception('Access token nahi mila. Login response mein accessToken save hona chahiye.');
    }
    return token;
  }

  static Future<List<ServiceCategory>> getCategories() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(_url),
      headers: {
        'Accept': 'application/json',
        'accessToken': token,
        'Authorization': 'Bearer $token',
        'x-access-token': token,
      },
    ).timeout(const Duration(seconds: 25));

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception('Server se invalid response mila.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300 ||
        decoded is! Map || decoded['success'] != true) {
      throw Exception(decoded is Map
          ? (decoded['message']?.toString() ?? 'Categories load nahi hui.')
          : 'Categories load nahi hui.');
    }

    final data = decoded['data'];
    final raw = data is Map ? data['categories'] : null;
    if (raw is! List) return [];
    final categories = raw
        .whereType<Map>()
        .map((item) => ServiceCategory.fromJson(Map<String, dynamic>.from(item)))
        .where((item) => item.id.isNotEmpty && item.isActive)
        .toList();
    categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return categories;
  }
}
