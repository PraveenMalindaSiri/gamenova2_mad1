import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/models/user.dart';
import 'package:gamenova2_mad1/core/service/user_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _user?.token != null;

  Future<void> login(String email, String password) async {
    _user = await UserService.login(email, password);
    notifyListeners();
  }

  Future<void> register({required Map<String, dynamic> dataReg}) async {
    _user = await UserService.register(data: dataReg);
    notifyListeners();
  }

  Future<void> logout() async {
    await UserService.logout(token!);
    _user = null;
    notifyListeners();
  }

  String? get token => _user?.token;
  String? get role => _user?.role;
  int? get userId => _user?.id;
}
