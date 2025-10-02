import 'dart:async';
import 'dart:convert';

import 'package:gamenova2_mad1/core/models/user.dart';
import 'package:gamenova2_mad1/core/utility/api_routes.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String base = ApiRoutes.base;
  static const String loginPath = ApiRoutes.loginPath;
  static const String registerPath = ApiRoutes.registerPath;
  static const String logoutPath = ApiRoutes.logoutPath;

  static Future<User> login(String email, String password) async {
    try {
      final url = Uri.https(base, loginPath);

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
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
      final url = Uri.https(base, registerPath);

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
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

  static Future<void> logout(String token) async {
    if (token.isEmpty) {
      return;
    }

    try {
      final url = Uri.https(base, logoutPath);

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to LogOut');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('LogOut failed: $e');
    }
  }
}
