import 'dart:convert';

import 'package:gamenova2_mad1/core/models/order_item.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class PaymentService {
  // static const String base = "127.0.0.1:8000";
  static const String base = "192.168.1.100:8000";
  static const String purchasePath = "/api/cart/success";
  static const String itemsPath = "/api/orders/items";

  static Future<int> payment(String token) async {
    try {
      final url = Uri.http(base, purchasePath);

      final res = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body)['order_id'];
      }
      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Failed to remove Cart item');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Cart delete failed: $e');
    }
  }

  static Future<List<OrderItem>> orders(String token, int id) async {
    try {
      final url = Uri.http(base, "$itemsPath/$id");

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
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final items = (body['data'] as List)
            .map((j) => OrderItem.fromJson(j as Map<String, dynamic>))
            .toList();
        return items;
      }
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to load order items',
      );
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Orders loading failed: $e');
    }
  }
}
