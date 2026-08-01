import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  UserModel? user;
  String? token;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    final result = await _api.login(email, password);
    user = UserModel.fromJson(result['user']);
    token = result['token'];
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> signup(String email, String password, String displayName, String role) async {
    final result = await _api.signup(email, password, displayName, role);
    user = UserModel.fromJson(result['user']);
    token = result['token'];
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    user = null;
    token = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
