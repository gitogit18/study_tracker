import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../core/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._authService) {
    _authService.user.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  final AuthService _authService;
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> signIn() async {
    _setLoading(true);
    await _authService.signInWithGoogle();
    _setLoading(false);
  }

  Future<void> signOut() async {
    _setLoading(true);
    await _authService.signOut();
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
