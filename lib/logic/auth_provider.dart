import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  static const String _userDataKey = 'user_data';
  static const String _userPasswordKey = 'user_password';
  static const String _sessionStartKey = 'session_start_time';
  static const Duration _sessionDuration = Duration(hours: 1);

  UserModel? _currentUser;
  bool _isLoading = false;
  Timer? _sessionTimer;
  Timer? _periodicCheckTimer;
  DateTime? _sessionStartTime;
  bool _isSessionExpired = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null && !_isSessionExpired;
  bool get isSessionExpired => _isSessionExpired;

  Duration? get remainingSessionTime {
    if (_sessionStartTime == null) return null;
    final elapsed = DateTime.now().difference(_sessionStartTime!);
    final remaining = _sessionDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userDataKey);
    final sessionStartMs = prefs.getInt(_sessionStartKey);

    if (userData == null) {
      return;
    }

    if (sessionStartMs != null) {
      _sessionStartTime = DateTime.fromMillisecondsSinceEpoch(sessionStartMs);
      final elapsed = DateTime.now().difference(_sessionStartTime!);

      if (elapsed >= _sessionDuration) {
        await _handleSessionExpired();
        return;
      }
    }

    final json = jsonDecode(userData) as Map<String, dynamic>;
    _currentUser = UserModel.fromJson(json);
    _isSessionExpired = false;

    if (sessionStartMs != null) {
      _startSessionTimer();
    } else {
      await _initSession();
    }

    notifyListeners();
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    int avatarIndex,
  ) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();

    final user = UserModel(name: name, email: email, avatarIndex: avatarIndex);

    await prefs.setString(_userDataKey, jsonEncode(user.toJson()));
    await prefs.setString(_userPasswordKey, password);

    _currentUser = user;
    _isSessionExpired = false;
    await _initSession();

    _setLoading(false);
    return true;
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userDataKey);
    final savedPass = prefs.getString(_userPasswordKey);

    if (userData != null && savedPass == password) {
      final json = jsonDecode(userData) as Map<String, dynamic>;
      if (json['email'] == email) {
        _currentUser = UserModel.fromJson(json);
        _isSessionExpired = false;
        await _initSession();
        _setLoading(false);
        return true;
      }
    }

    _setLoading(false);
    return false;
  }

  void loginAsGuest() {
    _currentUser = UserModel.guest();
    _isSessionExpired = false;
    _initSession();
    notifyListeners();
  }

  Future<void> updateAvatar(int avatarIndex) async {
    if (_currentUser == null || _currentUser!.isGuest) return;

    _currentUser = _currentUser!.copyWith(avatarIndex: avatarIndex);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(_currentUser!.toJson()));

    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    if (_currentUser == null || _currentUser!.isGuest) return;

    _currentUser = _currentUser!.copyWith(name: name, email: email);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(_currentUser!.toJson()));

    notifyListeners();
  }

  Future<void> updateStats({
    int? gamesPlayed,
    int? gamesWon,
    int? highScore,
  }) async {
    if (_currentUser == null || _currentUser!.isGuest) return;

    _currentUser = _currentUser!.copyWith(
      gamesPlayed: gamesPlayed ?? _currentUser!.gamesPlayed,
      gamesWon: gamesWon ?? _currentUser!.gamesWon,
      highScore: highScore ?? _currentUser!.highScore,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(_currentUser!.toJson()));

    notifyListeners();
  }

  Future<void> addBadge(String badgeId) async {
    if (_currentUser == null || _currentUser!.isGuest) return;
    if (_currentUser!.badges.contains(badgeId)) return;

    final newBadges = [..._currentUser!.badges, badgeId];
    _currentUser = _currentUser!.copyWith(badges: newBadges);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(_currentUser!.toJson()));

    notifyListeners();
  }

  Future<void> logout() async {
    _cancelTimers();
    _currentUser = null;
    _sessionStartTime = null;
    _isSessionExpired = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionStartKey);

    notifyListeners();
  }

  Future<void> _initSession() async {
    _sessionStartTime = DateTime.now();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _sessionStartKey,
      _sessionStartTime!.millisecondsSinceEpoch,
    );

    _startSessionTimer();
  }

  void _startSessionTimer() {
    _cancelTimers();

    if (_sessionStartTime == null) return;

    final elapsed = DateTime.now().difference(_sessionStartTime!);
    final remaining = _sessionDuration - elapsed;

    if (remaining.isNegative || remaining == Duration.zero) {
      _handleSessionExpired();
      return;
    }

    _sessionTimer = Timer(remaining, _handleSessionExpired);

    _periodicCheckTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      notifyListeners();
    });
  }

  Future<void> _handleSessionExpired() async {
    _cancelTimers();
    _isSessionExpired = true;
    _currentUser = null;
    _sessionStartTime = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionStartKey);

    notifyListeners();
  }

  void _cancelTimers() {
    _sessionTimer?.cancel();
    _periodicCheckTimer?.cancel();
    _sessionTimer = null;
    _periodicCheckTimer = null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }
}
