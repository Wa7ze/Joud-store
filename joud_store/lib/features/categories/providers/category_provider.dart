import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../services/category_service.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final categoryService = CategoryService();
  return categoryService.getCategories();
});

final categoryProvider = FutureProvider.family<Category, String>((ref, id) async {
  final categoryService = CategoryService();
  return categoryService.getCategory(id);
});
