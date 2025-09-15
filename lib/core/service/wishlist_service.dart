import 'dart:convert';

import 'package:gamenova2_mad1/core/models/wishlist.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class WishlistService {
  static const String base = "http://127.0.0.1:8000";
  static const String wishlistPath = "/api/wishlist";

  static Future<List<WishlistItem>> getWishlist(String token) async {
    try {
      final url = Uri.http(base, wishlistPath);

      final response = await http
          .get(url, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final items = (decoded['data'] as List<dynamic>);
        final list = items
            .map((j) => WishlistItem.fromJson(j as Map<String, dynamic>))
            .toList();
        // print(list);
        return list;
      } else {
        throw Exception('Failed to load wishlist: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Loading wishlist failed: $e');
    }
  }

  static Future<WishlistItem> addToWishlist({
    // required String token,
    required int productId,
    int quantity = 1,
  }) async {
    try {
      final url = Uri.parse('$base$wishlistPath');
      final res = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // 'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'product_id': productId, 'quantity': quantity}),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data =
            (jsonDecode(res.body) as Map<String, dynamic>)['data']
                as Map<String, dynamic>;
        return WishlistItem.fromJson(data);
      }

      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Failed to add wishlist');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Wishlist add failed: $e');
    }
  }

  static Future<WishlistItem> updateWishlistItem({
    // required String token,
    required int id,
    required int quantity,
  }) async {
    try {
      final url = Uri.parse('$base$wishlistPath/$id');
      final res = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // 'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'quantity': quantity}),
          )
          .timeout(const Duration(seconds: 30));
      if (res.statusCode == 200) {
        final data =
            (jsonDecode(res.body) as Map<String, dynamic>)['data']
                as Map<String, dynamic>;
        return WishlistItem.fromJson(data);
      }
      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Failed to update wishlist item');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Wishlist update failed: $e');
    }
  }

  static Future<void> deleteWishlistItem({
    // required String token,
    required int id,
  }) async {
    try {
      final url = Uri.parse('$base$wishlistPath/$id');
      final res = await http
          .delete(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // 'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));
      if (res.statusCode == 200 || res.statusCode == 204) return;
      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Failed to remove wishlist item');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Wishlist delete failed: $e');
    }
  }
}
