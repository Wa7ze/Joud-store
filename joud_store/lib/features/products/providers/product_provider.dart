import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../models/product_filters.dart';
import '../services/product_service.dart';

final productsProvider = FutureProvider.family<List<Product>, ProductFilters>((ref, filters) async {
  final productService = ProductService();
  return productService.getProducts(
    categoryId: filters.categoryId,
    subcategory: filters.subcategory,
    query: filters.searchQuery,
    sortBy: filters.sortBy,
    minPrice: filters.minPrice,
    maxPrice: filters.maxPrice,
  );
});

final productProvider = FutureProvider.family<Product, String>((ref, id) async {
  final productService = ProductService();
  return productService.getProduct(id);
});
