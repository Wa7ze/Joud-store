import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../services/product_service.dart';

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  final notifier = FavoritesNotifier();
  notifier._init();
  return notifier;
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(<String>{});

  static const _favoritesKey = 'favorite_products';
  SharedPreferences? _prefs;

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
    final stored = _prefs!.getStringList(_favoritesKey) ?? <String>[];
    state = stored.toSet();
  }

  Future<void> toggleFavorite(String productId) async {
    final current = state.contains(productId);
    final updated = <String>{...state};
    if (current) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }
    state = updated;
    await _save(updated);
  }

  Future<void> _save(Set<String> favorites) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setStringList(_favoritesKey, favorites.toList());
  }

  bool isFavorite(String productId) => state.contains(productId);
}

/// Provider that resolves favorite product ids into concrete product models.
final favoriteProductsProvider = FutureProvider<List<Product>>((ref) async {
  final favorites = ref.watch(favoritesProvider);
  if (favorites.isEmpty) return const [];

  final service = ProductService();
  final products = <Product>[];
  for (final id in favorites) {
    try {
      final product = await service.getProduct(id);
      products.add(product);
    } catch (_) {
      // Ignore products that can no longer be fetched.
    }
  }
  return products;
});
