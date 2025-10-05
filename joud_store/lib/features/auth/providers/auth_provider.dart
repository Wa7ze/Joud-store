import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthService());
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState.unauthenticated());

  Future<void> signIn(String phoneNumber, String otp) async {
    state = const AuthState.loading();
    try {
      final user = await _authService.signIn(phoneNumber, otp);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signUp(String name, String phoneNumber, String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _authService.signUp(name, phoneNumber, email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signOut() async {
    state = const AuthState.loading();
    try {
      await _authService.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    state = const AuthState.loading();
    try {
      await _authService.sendOtp(phoneNumber);
      state = const AuthState.otpSent();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}
