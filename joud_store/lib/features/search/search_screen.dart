import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/router/app_router.dart';
import '../products/models/product.dart';
import 'providers/search_provider.dart';
import 'models/search_suggestion.dart';
import '../../core/widgets/product_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery ?? '';
    if (widget.initialQuery != null) {
      _performSearch(widget.initialQuery!);
    }
    ref.read(searchServiceProvider).init();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    final textDirection = localizationService.textDirection;
    final searchResults = ref.watch(searchResultsProvider);

    return ScreenScaffold(
      title: localizationService.getString('search'),
      showBackButton: true,
      currentIndex: 0,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          tooltip: localizationService.getString('filter'),
          onPressed: () => context.go(AppRouter.productList),
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              textDirection: textDirection,
              decoration: InputDecoration(
                hintText: localizationService.getString('searchPlaceholder'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchResultsProvider.notifier).clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: _performSearch,
              onChanged: (value) {
                _debounceTimer?.cancel();
                _debounceTimer = Timer(
                  const Duration(milliseconds: 300),
                  () => ref.read(searchQueryProvider.notifier).state = value,
                );
              },
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 780),
                child: searchResults.when(
                  data: (products) => products.isNotEmpty
                      ? _buildSearchResults(products)
                      : _buildSearchSuggestions(localizationService),
                  loading: () => const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: LoadingState(),
                  ),
                  error: (_, __) => Center(
                    child: EmptyState(
                      title: localizationService.getString('error'),
                      message: localizationService.getString('searchError'),
                      icon: Icons.error_outline,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => context.go('${AppRouter.productDetail}/${product.id}'),
        );
      },
    );
  }

  Widget _buildSearchSuggestions(LocalizationService localization) {
    final textDirection = localization.textDirection;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment:
            textDirection == TextDirection.rtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Consumer(
            builder: (context, ref, _) {
              final recentSearches = ref.watch(recentSearchesProvider);
              return recentSearches.when(
                data: (searches) => searches.isNotEmpty
                    ? Column(
                        crossAxisAlignment: textDirection == TextDirection.rtl
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Row(
                            textDirection: textDirection,
                            children: [
                              Expanded(
                                child: _buildSectionTitle(
                                  localization.getString('searchRecent'),
                                  textDirection,
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    ref.read(recentSearchesProvider.notifier).clearRecentSearches(),
                                child: Text(localization.getString('searchClearHistory')),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildSearchChips(searches, _onRecentSearchTap),
                          const SizedBox(height: 24),
                        ],
                      )
                    : const SizedBox.shrink(),
                loading: () => const LoadingState(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final trendingSearches = ref.watch(trendingSearchesProvider);
              return trendingSearches.when(
                data: (searches) => searches.isNotEmpty
                    ? Column(
                        crossAxisAlignment: textDirection == TextDirection.rtl
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                            localization.getString('searchTrending'),
                            textDirection,
                          ),
                          const SizedBox(height: 8),
                          _buildSearchChips(searches, _onTrendingSearchTap),
                          const SizedBox(height: 24),
                        ],
                      )
                    : const SizedBox.shrink(),
                loading: () => const LoadingState(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final query = ref.watch(searchQueryProvider);
              if (query.isEmpty) {
                return const SizedBox.shrink();
              }

              final suggestions = ref.watch(searchSuggestionsProvider);
              return suggestions.when(
                data: (items) => items.isNotEmpty
                    ? Column(
                        crossAxisAlignment: textDirection == TextDirection.rtl
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                            localization.getString('searchSuggestions'),
                            textDirection,
                          ),
                          const SizedBox(height: 8),
                          _buildSuggestionsList(items),
                        ],
                      )
                    : const SizedBox.shrink(),
                loading: () => const LoadingState(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, TextDirection textDirection) {
    final textAlign = textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left;
    final alignment = textDirection == TextDirection.rtl
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        textAlign: textAlign,
      ),
    );
  }

  Widget _buildSearchChips(List<String> items, Function(String) onTap) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return ActionChip(
          label: Text(item),
          onPressed: () => onTap(item),
        );
      }).toList(),
    );
  }

  Widget _buildSuggestionsList(List<SearchSuggestion> suggestions) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: suggestions.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: Icon(
            suggestion.type == SuggestionType.category
                ? Icons.category_outlined
                : suggestion.type == SuggestionType.search
                    ? Icons.search
                    : Icons.shopping_bag_outlined,
          ),
          title: Text(suggestion.text),
          subtitle: suggestion.type == SuggestionType.product
              ? Text(suggestion.category ?? '')
              : null,
          onTap: () => _onSuggestionTap(suggestion),
        );
      },
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    ref.read(recentSearchesProvider.notifier).addRecentSearch(query);
    ref.read(searchResultsProvider.notifier).search(query);
  }

  void _onRecentSearchTap(String query) {
    _searchController.text = query;
    _performSearch(query);
  }

  void _onTrendingSearchTap(String query) {
    _searchController.text = query;
    _performSearch(query);
  }

  void _onSuggestionTap(SearchSuggestion suggestion) {
    switch (suggestion.type) {
      case SuggestionType.search:
        _searchController.text = suggestion.text;
        _performSearch(suggestion.text);
        break;
      case SuggestionType.category:
        context.pushNamed(
          'productList',
          queryParameters: {'categoryId': suggestion.category},
        );
        break;
      case SuggestionType.product:
        if (suggestion.productId != null) {
          context.pushNamed('productDetail', pathParameters: {'id': suggestion.productId!});
        }
        break;
      default:
        _searchController.text = suggestion.text;
        _performSearch(suggestion.text);
        break;
    }
  }
}
