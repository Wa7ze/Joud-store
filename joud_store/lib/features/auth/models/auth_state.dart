import '../../../core/models/user.dart';

enum AuthStatus {
  unauthenticated,
  authenticated,
  loading,
  error,
  otpSent,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState._({
    required this.status,
    this.user,
    this.errorMessage,
  });

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.loading() : this._(status: AuthStatus.loading);

  const AuthState.error(String message)
      : this._(status: AuthStatus.error, errorMessage: message);

  const AuthState.otpSent() : this._(status: AuthStatus.otpSent);

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
  bool get isOtpSent => status == AuthStatus.otpSent;
}
