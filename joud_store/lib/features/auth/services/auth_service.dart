import '../../../core/models/user.dart';

class AuthService {
  Future<void> sendOtp(String phoneNumber) async {
    // TODO: Implement actual OTP sending logic
    // For now, we'll simulate a delay
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<User> signIn(String phoneNumber, String otp) async {
    // TODO: Implement actual sign in logic
    // For now, we'll return a mock user
    await Future.delayed(const Duration(seconds: 1));
    
    return User(
      id: 'mock-id',
      name: 'Mock User',
      phone: phoneNumber,
      email: null,
    );
  }

  Future<User> signUp(String name, String phoneNumber, String email, String password) async {
    // TODO: Implement actual sign up logic
    // For now, we'll return a mock user
    await Future.delayed(const Duration(seconds: 1));
    
    return User(
      id: 'mock-id',
      name: name,
      phone: phoneNumber,
      email: email,
    );
  }

  Future<void> signOut() async {
    // TODO: Implement actual sign out logic
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
