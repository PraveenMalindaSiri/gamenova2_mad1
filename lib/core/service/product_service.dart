import 'dart:async';
import 'dart:convert';

import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  // static const String loginPath = "https://gamenova.duckdns.org/api/login";
  // static const String registerPath =
  //     "https://gamenova.duckdns.org/api/register";

  static const String basePath = "127.0.0.1:8000";
  static const String homePath = "/api/home";
  static const String productsPath = "/api/products";

  static Future<Map<String, List<Product>>> getHomeSreenSections() async {
    try {
      final url = Uri.http(basePath, homePath);

      final response = await http.Client()
          .get(url, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        final latest = (json['latest'] as List)
            .map((e) => Product.fromJson(e))
            .toList();

        final featured = (json['featured'] as List)
            .map((e) => Product.fromJson(e))
            .toList();

        return {'latest': latest, 'featured': featured};
      } else {
        throw Exception('Failed to load Home sections: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Loading home products failed: $e');
    }
  }

  static Future<List<Product>> getAllProducts({
    String type = '',
    String genre = '',
    String platform = '',
  }) async {
    try {
      final params = <String, String>{};
      if (type.isNotEmpty) params['type'] = type;
      if (genre.isNotEmpty) params['genre'] = genre;
      if (platform.isNotEmpty) params['platform'] = platform;

      final url = Uri.http(
        basePath,
        productsPath,
        params.isEmpty ? null : params,
      );

      final response = await http
          .get(url, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final items = (decoded['data'] as List<dynamic>);
        final list = items
            .map((j) => Product.fromJson(j as Map<String, dynamic>))
            .toList();
        print(list);
        return list;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Loading products failed: $e');
    }
  }
}
