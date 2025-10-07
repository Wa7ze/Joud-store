import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../products/models/product.dart';

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, Product>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Map<String, Product>> {
  CartNotifier() : super({});

  void addToCart(Product product) {
    state = {...state, product.id: product};
  }

  void removeFromCart(String productId) {
    final newState = Map<String, Product>.from(state);
    newState.remove(productId);
    state = newState;
  }

  void clearCart() {
    state = {};
  }
}

// A provider to check if a product is in the cart
final isProductInCartProvider = StateProvider.family<bool, String>((ref, productId) {
  final cart = ref.watch(cartProvider);
  return cart.containsKey(productId);
});