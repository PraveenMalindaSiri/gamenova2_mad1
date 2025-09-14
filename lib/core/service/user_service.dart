import 'dart:async';
import 'dart:convert';

import 'package:gamenova2_mad1/core/models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String loginPath = "/api/login";
  static const String registerPath = "/api/register";

  static Future<User> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse(loginPath),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"email": email, "password": password}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = jsonDecode(response.body)['user'] as Map<String, dynamic>;
        return User.fromJson(user);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to LogIn');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  static Future<User> register({required Map<String, dynamic> data}) async {
    try {
      final response = await http
          .post(
            Uri.parse(registerPath),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = jsonDecode(response.body)['user'] as Map<String, dynamic>;
        return User.fromJson(user);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to Register');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Registering failed: $e');
    }
  }
}
