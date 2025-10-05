import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/coupon.dart';
import '../services/mock_data_service.dart';

class CartState {
  final List<CartItem> items;
  final String? couponCode;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;
  final bool isLoading;
  final String? error;

  CartState({
    this.items = const [],
    this.couponCode,
    this.subtotal = 0,
    this.discount = 0,
    this.deliveryFee = 0,
    this.total = 0,
    this.isLoading = false,
    this.error,
  });

  CartState copyWith({
    List<CartItem>? items,
    String? couponCode,
    double? subtotal,
    double? discount,
    double? deliveryFee,
    double? total,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      couponCode: couponCode ?? this.couponCode,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final MockDataService _mockDataService;

  CartNotifier(this._mockDataService) : super(CartState());

  Future<void> addToCart(
    Product product,
    int quantity,
    Map<String, String> selectedOptions,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Check if the product already exists in cart with same options
      final existingItemIndex = state.items.indexWhere(
        (item) =>
            item.productId == product.id &&
            _areOptionsEqual(item.selectedOptions, selectedOptions),
      );

      List<CartItem> updatedItems;
      if (existingItemIndex != -1) {
        // Update existing item quantity
        final existingItem = state.items[existingItemIndex];
        final updatedItem = CartItem(
          productId: product.id,
          selectedOptions: selectedOptions,
          quantity: existingItem.quantity + quantity,
          unitPrice: product.price,
          lineTotal: product.price * (existingItem.quantity + quantity),
        );
        updatedItems = List.from(state.items);
        updatedItems[existingItemIndex] = updatedItem;
      } else {
        // Add new item
        final newItem = CartItem(
          productId: product.id,
          selectedOptions: selectedOptions,
          quantity: quantity,
          unitPrice: product.price,
          lineTotal: product.price * quantity,
        );
        updatedItems = [...state.items, newItem];
      }

      await _recalculateCart(updatedItems);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add item to cart',
      );
    }
  }

  Future<void> updateQuantity(int index, int quantity) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      if (index < 0 || index >= state.items.length) {
        throw Exception('Invalid item index');
      }

      final item = state.items[index];
      final updatedItem = CartItem(
        productId: item.productId,
        selectedOptions: item.selectedOptions,
        quantity: quantity,
        unitPrice: item.unitPrice,
        lineTotal: item.unitPrice * quantity,
      );

      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[index] = updatedItem;

      await _recalculateCart(updatedItems);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update quantity',
      );
    }
  }

  Future<void> removeItem(int index) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      if (index < 0 || index >= state.items.length) {
        throw Exception('Invalid item index');
      }

      final updatedItems = List<CartItem>.from(state.items)..removeAt(index);
      await _recalculateCart(updatedItems);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to remove item',
      );
    }
  }

  Future<void> applyCoupon(String code) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final coupon = await _mockDataService.validateCoupon(code);
      if (coupon == null) {
        throw Exception('Invalid coupon code');
      }

      state = state.copyWith(couponCode: code);
      await _recalculateCart(state.items);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> removeCoupon() async {
    state = state.copyWith(couponCode: null);
    await _recalculateCart(state.items);
  }

  Future<void> updateCart({
    List<CartItem>? items,
    double? deliveryFee,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final currentItems = items ?? state.items;
      final currentDeliveryFee = deliveryFee ?? state.deliveryFee;

      final subtotal = currentItems.fold<double>(
        0,
        (sum, item) => sum + item.lineTotal,
      );

      double discount = 0;
      if (state.couponCode != null) {
        final coupon = await _mockDataService.validateCoupon(state.couponCode!);
        if (coupon != null) {
          discount = coupon.calculateDiscount(subtotal);
        }
      }

      final total = subtotal - discount + currentDeliveryFee;

      state = state.copyWith(
        items: currentItems,
        subtotal: subtotal,
        discount: discount,
        deliveryFee: currentDeliveryFee,
        total: total,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update cart',
      );
    }
  }

  Future<void> _recalculateCart(List<CartItem> items) async {
    await updateCart(items: items);
  }

  bool _areOptionsEqual(
    Map<String, String> options1,
    Map<String, String> options2,
  ) {
    if (options1.length != options2.length) return false;
    return options1.entries.every(
      (e) => options2[e.key] == e.value,
    );
  }

  void clearCart() {
    state = CartState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(MockDataService());
});
