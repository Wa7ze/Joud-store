import 'package:shared_preferences/shared_preferences.dart';
import '../models/search_suggestion.dart';
import '../../products/models/product.dart';
import '../../products/services/product_service.dart';
import '../../categories/services/category_service.dart';
import '../../../core/localization/localization_service.dart';

class SearchService {
  static const _maxRecentSearches = 10;
  static const _recentSearchesKey = 'recent_searches';

  final _productService = ProductService();
  final _categoryService = CategoryService();
  late final SharedPreferences _prefs;

  // Singleton instance
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal();

  // Initialize
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Get recent searches
  Future<List<String>> getRecentSearches() async {
    final searches = _prefs.getStringList(_recentSearchesKey);
    return searches ?? [];
  }

  // Add a recent search
  Future<void> addRecentSearch(String query) async {
    final searches = await getRecentSearches();
    if (searches.contains(query)) {
      searches.remove(query);
    }
    searches.insert(0, query);
    if (searches.length > _maxRecentSearches) {
      searches.removeLast();
    }
    await _prefs.setStringList(_recentSearchesKey, searches);
  }

  // Clear recent searches
  Future<void> clearRecentSearches() async {
    await _prefs.remove(_recentSearchesKey);
  }

  // Get trending searches based on current season and popular items
  Future<List<String>> getTrendingSearches() async {
    final now = DateTime.now();
    final month = now.month;
    final categories = await _categoryService.getCategories();
    final localization = LocalizationService.instance;

    final seasonalSuggestions = {
      'spring': [
        localization.getString('trendSpringFreshLayers'),
        localization.getString('trendSpringRamadanLooks'),
        localization.getString('trendSpringLightFabrics'),
      ],
      'summer': [
        localization.getString('trendSummerLinen'),
        localization.getString('trendSummerBeachwear'),
        localization.getString('trendSummerEvening'),
      ],
      'fall': [
        localization.getString('trendFallLayers'),
        localization.getString('trendFallEarthTones'),
        localization.getString('trendFallBackToSchool'),
      ],
      'winter': [
        localization.getString('trendWinterCoats'),
        localization.getString('trendWinterKnitwear'),
        localization.getString('trendWinterAccessories'),
      ],
    };

    late final List<String> seasonal;
    if (month >= 3 && month <= 5) {
      seasonal = seasonalSuggestions['spring']!;
    } else if (month >= 6 && month <= 8) {
      seasonal = seasonalSuggestions['summer']!;
    } else if (month >= 9 && month <= 11) {
      seasonal = seasonalSuggestions['fall']!;
    } else {
      seasonal = seasonalSuggestions['winter']!;
    }

    final popularCategories = categories
        .where((c) => c.productCount > 100)
        .take(3)
        .map((c) => c.name)
        .toList();

    final styles = [
      localization.getString('trendStyleCasual'),
      localization.getString('trendStyleEvening'),
      localization.getString('trendStyleModest'),
      localization.getString('trendStyleKids'),
    ];
    final occasions = [
      localization.getString('trendOccasionWork'),
      localization.getString('trendOccasionWedding'),
      localization.getString('trendOccasionUniversity'),
      localization.getString('trendOccasionFamily'),
    ];

    final suggestions = <String>{};
    suggestions.addAll(seasonal);
    suggestions.addAll(popularCategories);
    suggestions.addAll(styles.take(2));
    suggestions.addAll(occasions.take(2));

    return suggestions.toList();
  }

  // Get smart search suggestions based on input
  // Search products by query
  Future<List<Product>> searchProducts(String query) async {
    final lowercaseQuery = query.toLowerCase();
    final products = await _productService.getProducts();

    // First exact matches, then partial matches
    final exactMatches = <Product>[];
    final partialMatches = <Product>[];

    for (final product in products) {
      final String searchText = [
        product.name,
        product.description,
        product.brand ?? '',
        product.style ?? '',
        product.material ?? '',
        product.fit ?? '',
        product.occasions,
        product.season ?? '',
      ].join(' ').toLowerCase();

      if (product.name.toLowerCase() == lowercaseQuery ||
          (product.brand?.toLowerCase() ?? '') == lowercaseQuery) {
        exactMatches.add(product);
      } else if (searchText.contains(lowercaseQuery)) {
        partialMatches.add(product);
      }
    }

    return [...exactMatches, ...partialMatches];
  }

  Future<List<SearchSuggestion>> getSearchSuggestions(String input) async {
    if (input.isEmpty) return [];

    final suggestions = <SearchSuggestion>[];
    final lowercaseInput = input.toLowerCase();

    // Get all products and categories
    final products = await _productService.getProducts();
    final categories = await _categoryService.getCategories();

    // Add matching category suggestions
    suggestions.addAll(
      categories
          .where((c) => c.name.toLowerCase().contains(lowercaseInput))
          .map((c) => SearchSuggestion(
                text: c.name,
                type: SuggestionType.category,
                category: c.id,
              ))
          .take(2),
    );

    // Add matching subcategory suggestions
    for (final category in categories) {
      suggestions.addAll(
        category.subcategories
            .where((s) => s.toLowerCase().contains(lowercaseInput))
            .map((s) => SearchSuggestion(
                  text: s,
                  type: SuggestionType.subcategory,
                  category: category.id,
                  subcategory: s,
                ))
            .take(1),
      );
    }

    // Add matching brand suggestions
    final brands = products
        .where((p) => p.brand != null)
        .map((p) => p.brand!)
        .toSet()
        .where((b) => b.toLowerCase().contains(lowercaseInput));
    suggestions.addAll(
      brands.map((b) => SearchSuggestion(
            text: b,
            type: SuggestionType.brand,
          )),
    );

    // Add matching style suggestions
    final styles = products
        .where((p) => p.style != null)
        .map((p) => p.style!)
        .toSet()
        .where((s) => s.toLowerCase().contains(lowercaseInput));
    suggestions.addAll(
      styles.map((s) => SearchSuggestion(
            text: s,
            type: SuggestionType.style,
          )),
    );

    // Add matching product name suggestions
    suggestions.addAll(
      products
          .where((p) => p.name.toLowerCase().contains(lowercaseInput))
          .map((p) => SearchSuggestion(
                text: p.name,
                type: SuggestionType.product,
                productId: p.id,
              ))
          .take(3),
    );

    return suggestions;
  }
}
