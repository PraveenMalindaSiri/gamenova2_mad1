import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';

class PaymentService {
  static const String base = "127.0.0.1:8000";
  static const String purchasePath = "/api/cart/success";

  static Future<void> payment(String token) async {
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

      if (res.statusCode == 200 ||
          res.statusCode == 201 ||
          res.statusCode == 204) {
        return;
      }
      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Failed to remove Cart item');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Cart delete failed: $e');
    }
  }
}
