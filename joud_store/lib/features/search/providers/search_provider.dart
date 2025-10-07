import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/search_service.dart';
import '../models/search_suggestion.dart';
import '../../products/models/product.dart';

// Service Provider
final searchServiceProvider = Provider<SearchService>((ref) => SearchService());

// Search Query Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Search Results Provider
final searchResultsProvider = AsyncNotifierProvider<SearchResultsNotifier, List<Product>>(() {
  return SearchResultsNotifier();
});

class SearchResultsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    return [];
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final searchService = ref.read(searchServiceProvider);
      return searchService.searchProducts(query);
    });
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

// Recent Searches Provider
final recentSearchesProvider = AsyncNotifierProvider<RecentSearchesNotifier, List<String>>(() {
  return RecentSearchesNotifier();
});

class RecentSearchesNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    final searchService = ref.read(searchServiceProvider);
    return searchService.getRecentSearches();
  }

  Future<void> addRecentSearch(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final searchService = ref.read(searchServiceProvider);
      await searchService.addRecentSearch(query);
      return searchService.getRecentSearches();
    });
  }

  Future<void> clearRecentSearches() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final searchService = ref.read(searchServiceProvider);
      await searchService.clearRecentSearches();
      return searchService.getRecentSearches();
    });
  }
}

// Trending Searches Provider
final trendingSearchesProvider = AsyncNotifierProvider<TrendingSearchesNotifier, List<String>>(() {
  return TrendingSearchesNotifier();
});

class TrendingSearchesNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    final searchService = ref.read(searchServiceProvider);
    return searchService.getTrendingSearches();
  }
}

// Search Suggestions Provider
final searchSuggestionsProvider = AutoDisposeFamilyAsyncNotifierProvider<SearchSuggestionsNotifier, List<SearchSuggestion>, String>(() {
  return SearchSuggestionsNotifier();
});

class SearchSuggestionsNotifier extends AutoDisposeFamilyAsyncNotifier<List<SearchSuggestion>, String> {
  @override
  Future<List<SearchSuggestion>> build(String query) async {
    if (query.isEmpty) {
      return [];
    }
    final searchService = ref.read(searchServiceProvider);
    return searchService.getSearchSuggestions(query);
  }
}