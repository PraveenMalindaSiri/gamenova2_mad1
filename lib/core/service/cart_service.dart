import 'dart:convert';

import 'package:gamenova2_mad1/core/models/cart.dart';
import 'package:gamenova2_mad1/core/models/cart_db.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class CartService {
  static const String base = "127.0.0.1:8000";
  static const String cartPath = "/api/cart";

  static Future<List<CartItem>> getCart(int userId) {
    return CartDB().getCart(userId);
  }

  static Future<void> removeItem(int userId, int productId) {
    return CartDB().removeItem(userId: userId, productId: productId);
  }

  static Future<CartItem> addToCart({
    required String token,
    required int productId,
    int quantity = 1,
  }) async {
    try {
      final url = Uri.parse('$base$cartPath');
      final res = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'product_id': productId, 'quantity': quantity}),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data =
            (jsonDecode(res.body) as Map<String, dynamic>)['data']
                as Map<String, dynamic>;
        return CartItem.fromJson(data);
      }

      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Failed to add Cart');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Cart add failed: $e');
    }
  }

  static Future<void> deleteCartItem({
    required String token,
    required int id,
  }) async {
    try {
      final url = Uri.parse('$base$cartPath/$id');
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
      if (res.statusCode == 200 || res.statusCode == 204) return;
      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Failed to remove Cart item');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Cart delete failed: $e');
    }
  }
}
