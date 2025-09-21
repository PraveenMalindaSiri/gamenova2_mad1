import 'dart:async';
import 'dart:convert';

import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SellerService {
  static const String basePath = "127.0.0.1:8000";
  static const String productsPath = "/api/myproducts";

  static Future<List<Product>> getSellerGames(String token) async {
    try {
      final url = Uri.http(basePath, productsPath);

      final response = await http.Client()
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final items = (decoded['data'] as List<dynamic>);
        final list = items
            .map((j) => Product.fromJson(j as Map<String, dynamic>))
            .toList();
        return list;
      } else {
        throw Exception(
          "Failed to load Seller's products: ${response.statusCode}",
        );
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception("Loading seller products failed: $e");
    }
  }

  static Future<void> createProduct({
    required Map<String, dynamic> data,
    required String token,
    required XFile photo,
  }) async {
    try {
      final url = Uri.http(basePath, productsPath);
      final req = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields.addAll(
          data.map((k, v) => MapEntry(k, v.toString())),
        ); // transforming all data to string, string map

      if (kIsWeb) {
        final bytes = await photo.readAsBytes();
        req.files.add(
          http.MultipartFile.fromBytes(
            'product_photo',
            bytes,
            filename: photo.name,
          ),
        );
      } else {
        req.files.add(
          await http.MultipartFile.fromPath(
            'product_photo',
            photo.path,
            filename: photo.name,
          ),
        );
      }

      final res = await req.send();

      if (res.statusCode < 200 || res.statusCode >= 300) {
        final body = await res.stream.bytesToString();
        try {
          final json = jsonDecode(body);
          throw Exception(json['message'] ?? 'Failed to create product');
        } catch (_) {
          throw Exception(
            'Failed to create product (${res.statusCode}): $body',
          );
        }
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Creating failed: $e');
    }
  }

  static Future<void> updateProduct({
    required Map<String, dynamic> data,
    required int id,
    required String token,
  }) async {
    try {
      final url = Uri.http(basePath, "$productsPath/$id");
      final res = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode( data),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200 || res.statusCode == 201) {
        return;
      }

      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Failed to update the product');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Updating failed: $e');
    }
  }

  static Future<void> deleteProduct({
    required int id,
    required String token,
  }) async {
    try {
      final url = Uri.http(basePath, "$productsPath/$id");
      final res = await http
          .delete(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));
      if (res.statusCode == 200) {
        return;
      }

      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Failed to delete the product');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Deleting failed: $e');
    }
  }

  static Future<void> restoreProduct({
    required int id,
    required String token,
  }) async {
    try {
      final url = Uri.http(basePath, "$productsPath/$id/restore");
      final res = await http
          .patch(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));
      if (res.statusCode == 200) {
        return;
      }

      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Failed to restore the product');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Restoring failed: $e');
    }
  }
}
