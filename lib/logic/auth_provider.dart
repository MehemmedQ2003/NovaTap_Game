import 'dart:convert';
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
    final userData = prefs.getString('user_data');

    if (userData != null) {
      final json = jsonDecode(userData) as Map<String, dynamic>;
      _currentUser = UserModel.fromJson(json);
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password, int avatarIndex) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();

    final user = UserModel(
      name: name,
      email: email,
      avatarIndex: avatarIndex,
    );

    await prefs.setString('user_data', jsonEncode(user.toJson()));
    await prefs.setString('user_password', password);

    _currentUser = user;
    _setLoading(false);
    return true;
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    final savedPass = prefs.getString('user_password');

    if (userData != null && savedPass == password) {
      final json = jsonDecode(userData) as Map<String, dynamic>;
      if (json['email'] == email) {
        _currentUser = UserModel.fromJson(json);
        _setLoading(false);
        return true;
      }
    }

    _setLoading(false);
    return false;
  }

  void loginAsGuest() {
    _currentUser = UserModel.guest();
    notifyListeners();
  }

  Future<void> updateAvatar(int avatarIndex) async {
    if (_currentUser == null || _currentUser!.isGuest) return;

    _currentUser = _currentUser!.copyWith(avatarIndex: avatarIndex);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(_currentUser!.toJson()));

    notifyListeners();
  }

  Future<void> updateStats({int? gamesPlayed, int? gamesWon, int? highScore}) async {
    if (_currentUser == null || _currentUser!.isGuest) return;

    _currentUser = _currentUser!.copyWith(
      gamesPlayed: gamesPlayed ?? _currentUser!.gamesPlayed,
      gamesWon: gamesWon ?? _currentUser!.gamesWon,
      highScore: highScore ?? _currentUser!.highScore,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(_currentUser!.toJson()));

    notifyListeners();
  }

  Future<void> addBadge(String badgeId) async {
    if (_currentUser == null || _currentUser!.isGuest) return;
    if (_currentUser!.badges.contains(badgeId)) return;

    final newBadges = [..._currentUser!.badges, badgeId];
    _currentUser = _currentUser!.copyWith(badges: newBadges);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(_currentUser!.toJson()));

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
