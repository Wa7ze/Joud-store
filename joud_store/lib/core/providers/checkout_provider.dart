import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/address.dart';
import '../models/order.dart';
import '../services/mock_data_service.dart';
import 'cart_provider.dart';
import 'user_provider.dart';

enum CheckoutStep {
  address,
  delivery,
  payment,
  review,
  complete,
}

class CheckoutState {
  final CheckoutStep currentStep;
  final Address? selectedAddress;
  final String? deliveryMethod;
  final PaymentMethod? paymentMethod;
  final Order? completedOrder;
  final bool isLoading;
  final String? error;

  CheckoutState({
    this.currentStep = CheckoutStep.address,
    this.selectedAddress,
    this.deliveryMethod,
    this.paymentMethod,
    this.completedOrder,
    this.isLoading = false,
    this.error,
  });

  bool get canProceed {
    switch (currentStep) {
      case CheckoutStep.address:
        return selectedAddress != null;
      case CheckoutStep.delivery:
        return deliveryMethod != null;
      case CheckoutStep.payment:
        return paymentMethod != null;
      case CheckoutStep.review:
        return true;
      case CheckoutStep.complete:
        return false;
    }
  }

  CheckoutState copyWith({
    CheckoutStep? currentStep,
    Address? selectedAddress,
    String? deliveryMethod,
    PaymentMethod? paymentMethod,
    Order? completedOrder,
    bool? isLoading,
    String? error,
  }) {
    return CheckoutState(
      currentStep: currentStep ?? this.currentStep,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      completedOrder: completedOrder ?? this.completedOrder,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final MockDataService _mockDataService;
  final Ref _ref;

  CheckoutNotifier(this._mockDataService, this._ref) : super(CheckoutState());

  void selectAddress(Address address) {
    state = state.copyWith(selectedAddress: address);
  }

  void selectDeliveryMethod(String method) {
    state = state.copyWith(deliveryMethod: method);
  }

  void selectPaymentMethod(PaymentMethod method) {
    state = state.copyWith(paymentMethod: method);
  }

  Future<void> nextStep() async {
    if (!state.canProceed) return;

    final nextStep = CheckoutStep.values[
        (CheckoutStep.values.indexOf(state.currentStep) + 1)
            .clamp(0, CheckoutStep.values.length - 1)];

    state = state.copyWith(currentStep: nextStep);

    if (nextStep == CheckoutStep.review) {
      await _updateDeliveryFee();
    }
  }

  void previousStep() {
    if (state.currentStep == CheckoutStep.address) return;

    final previousStep = CheckoutStep.values[
        (CheckoutStep.values.indexOf(state.currentStep) - 1)
            .clamp(0, CheckoutStep.values.length - 1)];

    state = state.copyWith(currentStep: previousStep);
  }

  Future<void> _updateDeliveryFee() async {
    if (state.selectedAddress == null) return;

    try {
      state = state.copyWith(isLoading: true);

      final deliveryFee = _mockDataService.getDeliveryFee(
        state.selectedAddress!.governorate,
      );

      // Update cart with new delivery fee
      final cartState = _ref.read(cartProvider);
      await _ref.read(cartProvider.notifier).updateCart(
            items: cartState.items,
            deliveryFee: deliveryFee,
          );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update delivery fee',
      );
    }
  }

  Future<void> placeOrder() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final cartState = _ref.read(cartProvider);
      final userState = _ref.read(userProvider);

      if (!userState.isAuthenticated) {
        throw Exception('User not authenticated');
      }

      if (state.selectedAddress == null ||
          state.deliveryMethod == null ||
          state.paymentMethod == null) {
        throw Exception('Missing required checkout information');
      }

      // Create order
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userState.user!.id,
        items: cartState.items,
        subtotal: cartState.subtotal,
        deliveryFee: cartState.deliveryFee,
        discount: cartState.discount,
        total: cartState.total,
        paymentMethod: state.paymentMethod!,
        paymentStatus: PaymentStatus.unpaid,
        orderStatus: OrderStatus.placed,
        addressSnapshot: state.selectedAddress!.toJson(),
        createdAt: DateTime.now(),
        couponCode: cartState.couponCode,
      );

      // Simulate order creation delay
      await Future.delayed(const Duration(seconds: 1));

      // Clear cart
      _ref.read(cartProvider.notifier).clearCart();

      // Update state to complete
      state = state.copyWith(
        currentStep: CheckoutStep.complete,
        completedOrder: order,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to place order: ${e.toString()}',
      );
    }
  }

  void reset() {
    state = CheckoutState();
  }
}

final checkoutProvider =
    StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier(MockDataService(), ref);
});
