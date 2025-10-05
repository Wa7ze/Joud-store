import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/address.dart';

class UserState {
  final User? user;
  final List<Address> addresses;
  final bool isLoading;
  final String? error;

  UserState({
    this.user,
    this.addresses = const [],
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null;

  UserState copyWith({
    User? user,
    List<Address>? addresses,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      user: user ?? this.user,
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState());

  Future<void> login(String phone) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Simulate OTP verification
      await Future.delayed(const Duration(seconds: 1));

      // Mock successful login
      final user = User(
        id: DateTime.now().toString(),
        name: 'Mock User',
        phone: phone,
      );

      // Mock user addresses
      final addresses = [
        Address(
          id: '1',
          userId: user.id,
          governorate: 'Damascus',
          city: 'Damascus City',
          streetDetails: 'Mock Street 123',
          isDefault: true,
        ),
      ];

      state = state.copyWith(
        user: user,
        addresses: addresses,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to login',
      );
    }
  }

  Future<void> logout() async {
    state = UserState();
  }

  Future<void> updateProfile({
    required String name,
    String? email,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      if (state.user == null) throw Exception('User not authenticated');

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedUser = User(
        id: state.user!.id,
        name: name,
        phone: state.user!.phone,
        email: email,
        defaultAddressId: state.user!.defaultAddressId,
      );

      state = state.copyWith(
        user: updatedUser,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update profile',
      );
    }
  }

  Future<void> addAddress(Address address) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      if (state.user == null) throw Exception('User not authenticated');

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedAddresses = List<Address>.from(state.addresses);
      
      // If this is the first address or marked as default, update user's default address
      if (address.isDefault || updatedAddresses.isEmpty) {
        for (var addr in updatedAddresses) {
          if (addr.isDefault) {
            final index = updatedAddresses.indexOf(addr);
            updatedAddresses[index] = addr.copyWith(isDefault: false);
          }
        }
        
        final updatedUser = User(
          id: state.user!.id,
          name: state.user!.name,
          phone: state.user!.phone,
          email: state.user!.email,
          defaultAddressId: address.id,
        );
        
        state = state.copyWith(user: updatedUser);
      }

      updatedAddresses.add(address);

      state = state.copyWith(
        addresses: updatedAddresses,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add address',
      );
    }
  }

  Future<void> updateAddress(Address address) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      if (state.user == null) throw Exception('User not authenticated');

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedAddresses = List<Address>.from(state.addresses);
      final index = updatedAddresses.indexWhere((a) => a.id == address.id);

      if (index == -1) throw Exception('Address not found');

      // Handle default address changes
      if (address.isDefault) {
        for (var addr in updatedAddresses) {
          if (addr.isDefault && addr.id != address.id) {
            final i = updatedAddresses.indexOf(addr);
            updatedAddresses[i] = addr.copyWith(isDefault: false);
          }
        }
        
        final updatedUser = User(
          id: state.user!.id,
          name: state.user!.name,
          phone: state.user!.phone,
          email: state.user!.email,
          defaultAddressId: address.id,
        );
        
        state = state.copyWith(user: updatedUser);
      }

      updatedAddresses[index] = address;

      state = state.copyWith(
        addresses: updatedAddresses,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update address',
      );
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      if (state.user == null) throw Exception('User not authenticated');

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedAddresses = List<Address>.from(state.addresses)
        ..removeWhere((a) => a.id == addressId);

      // If the deleted address was the default one, update user's default address
      if (state.user!.defaultAddressId == addressId) {
        final newDefaultAddress = updatedAddresses.isNotEmpty
            ? updatedAddresses.first.copyWith(isDefault: true)
            : null;

        if (newDefaultAddress != null) {
          final index = updatedAddresses.indexOf(newDefaultAddress);
          updatedAddresses[index] = newDefaultAddress;
        }

        final updatedUser = User(
          id: state.user!.id,
          name: state.user!.name,
          phone: state.user!.phone,
          email: state.user!.email,
          defaultAddressId: newDefaultAddress?.id,
        );

        state = state.copyWith(user: updatedUser);
      }

      state = state.copyWith(
        addresses: updatedAddresses,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete address',
      );
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
