import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_name');
    final savedEmail = prefs.getString('user_email');

    if (savedName != null && savedEmail != null) {
      _currentUser = UserModel(name: savedName, email: savedEmail);
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_password', password);

    _currentUser = UserModel(name: name, email: email);
    _setLoading(false);
    return true;
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email');
    final savedPass = prefs.getString('user_password');
    final savedName = prefs.getString('user_name');

    if (savedEmail == email && savedPass == password && savedName != null) {
      _currentUser = UserModel(name: savedName!, email: email);

      _setLoading(false);
      return true;
    } else {
      _setLoading(false);
      return false;
    }
  }

  void loginAsGuest() {
    _currentUser = UserModel.guest();
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
