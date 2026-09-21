import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  UserModel? user;
  String? token;
  bool _isAuthenticated = false;
  bool _isBusy = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isBusy => _isBusy;

  Future<void> login(String email, String password) async {
    await _runAuthRequest(() async {
      final result = await _api.login(email, password);
      _setSession(result);
    });
  }

  Future<void> signup(String email, String password, String displayName, String role) async {
    await _runAuthRequest(() async {
      final result = await _api.signup(email, password, displayName, role);
      _setSession(result);
    });
  }

  void _setSession(Map<String, dynamic> result) {
    user = UserModel.fromJson(result['user']);
    token = result['token'];
    _api.setToken(token);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> _runAuthRequest(Future<void> Function() request) async {
    _isBusy = true;
    notifyListeners();
    try {
      await request();
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  void logout() {
    user = null;
    token = null;
    _api.setToken(null);
    _isAuthenticated = false;
    notifyListeners();
  }
}
