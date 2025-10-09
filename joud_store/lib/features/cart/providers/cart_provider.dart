import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../products/models/product.dart';
import '../models/cart_item.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super(const []);

  String _key(String productId, String? size, String? color) {
    return [productId, size ?? '-', color ?? '-'].join('#');
  }

  // Backward-compatible add from Product (no variant)
  void addToCart(Product product) {
    addCustomItem(
      productId: product.id,
      name: product.name,
      price: product.price,
      originalPrice: product.originalPrice,
      imageUrl: product.images.isNotEmpty ? product.images.first : null,
      size: null,
      color: null,
      quantity: 1,
    );
  }

  void addCustomItem({
    required String productId,
    required String name,
    required double price,
    double? originalPrice,
    String? imageUrl,
    String? size,
    String? color,
    int quantity = 1,
  }) {
    final id = _key(productId, size, color);
    final index = state.indexWhere((e) => e.id == id);
    if (index >= 0) {
      final existing = state[index];
      final updated = existing.copyWith(quantity: existing.quantity + quantity);
      final copy = [...state];
      copy[index] = updated;
      state = copy;
    } else {
      state = [
        ...state,
        CartItem(
          id: id,
          productId: productId,
          name: name,
          price: price,
          originalPrice: originalPrice,
          imageUrl: imageUrl,
          size: size,
          color: color,
          quantity: quantity,
        ),
      ];
    }
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeById(id);
      return;
    }
    final index = state.indexWhere((e) => e.id == id);
    if (index >= 0) {
      final copy = [...state];
      copy[index] = copy[index].copyWith(quantity: quantity);
      state = copy;
    }
  }

  void removeById(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  // Backward-compatible remove by productId (removes all variants)
  void removeFromCart(String productId) {
    state = state.where((e) => e.productId != productId).toList();
  }

  void clearCart() {
    state = const [];
  }
}

// Check if any variant of a product is in the cart
final isProductInCartProvider = StateProvider.family<bool, String>((ref, productId) {
  final items = ref.watch(cartProvider);
  return items.any((e) => e.productId == productId);
});
