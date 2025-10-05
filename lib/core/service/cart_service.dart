import 'dart:convert';

import 'package:gamenova2_mad1/core/models/cart.dart';
import 'package:gamenova2_mad1/core/models/cartItems_db.dart';
import 'package:gamenova2_mad1/core/models/cart_db.dart';
import 'package:gamenova2_mad1/core/service/product_service.dart';
import 'package:gamenova2_mad1/core/utility/api_routes.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class CartService {
  static const String base = ApiRoutes.base;
  static const String cartPath = ApiRoutes.cartPath;

  static final CartDB _db = CartDB();

  static Future<List<CartItem>> getCart(int userId) {
    return _db.getCart(userId);
  }

  // check if an item is in db, if not,  add it to db
  static Future<void> _updateProductCache(int productId) async {
    final cache = CartItemsDb();
    final existing = await cache.getAnItem(productId);
    if (existing != null) return;
    try {
      final p = await ProductService.getProductDetails(productId.toString());
      await cache.saveAnItem(p);
    } catch (_) {}
  }

  static Future<void> addItem(int userId, int productId, int amount) async {
    if (amount <= 0) amount = 1;
    await _db.addItem(userId: userId, productId: productId, amount: amount);
    await _updateProductCache(productId);
    return;
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

      final url = Uri.https(base, "$cartPath/sync");

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
      final url = Uri.https(base, cartPath);

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
      final url = Uri.https(base, cartPath);
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
      final url = Uri.https(base, "$cartPath/$id");
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
