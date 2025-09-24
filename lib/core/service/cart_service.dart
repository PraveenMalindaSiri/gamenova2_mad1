import 'dart:convert';

import 'package:gamenova2_mad1/core/models/cart.dart';
import 'package:gamenova2_mad1/core/models/cart_db.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class CartService {
  // static const String base = "127.0.0.1:8000";
  static const String base = "192.168.1.100:8000";
  static const String cartPath = "/api/cart";
  static const String purchasePath = "/api/cart/success";

  static final CartDB _db = CartDB();

  static Future<List<CartItem>> getCart(int userId) {
    return _db.getCart(userId);
  }

  static Future<void> addItem(int userId, int productId, int amount) {
    if (amount <= 0) amount = 1;
    return _db.addItem(userId: userId, productId: productId, amount: amount);
  }

  static Future<bool> isInUserCart(int userId, int productId) {
    return _db.isInCart(userId, productId);
  }

  static Future<void> removeItem(int userId, int productId) {
    return _db.removeItem(userId: userId, productId: productId);
  }

  static Future<void> cleanCart(int uid) async {
    return _db.clearCart(uid);
  }

  static Future<void> syncCart(String token, int userid) async {
    try {
      final cart = await _db.cartToMap(userid);

      final url = Uri.http(base, "$cartPath/sync");

      final res = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(cart),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200 || res.statusCode == 201) {
        return;
      }

      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Failed to sync the cart');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Syncing failed: $e');
    }
  }

  static Future<List<CartItem>> getCartAPI(String token) async {
    try {
      final url = Uri.http(base, cartPath);

      final response = await http
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
            .map((j) => CartItem.fromJson(j as Map<String, dynamic>))
            .toList();
        // print(list);
        return list;
      } else {
        throw Exception('Failed to load Cart: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Loading Cart failed: $e');
    }
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
