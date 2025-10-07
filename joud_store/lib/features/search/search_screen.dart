import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/router/app_router.dart';
import '../../core/config/app_config.dart';
import '../products/models/product.dart';
import '../products/providers/product_provider.dart';
import '../cart/providers/cart_provider.dart';
import 'providers/search_provider.dart';
import 'services/search_service.dart';
import 'models/search_suggestion.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  
  const SearchScreen({
    super.key,
    this.initialQuery,
  });

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
    
    // Initialize search service
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
    final searchResults = ref.watch(searchResultsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizationService.getString('search')),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: localizationService.getString('search'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchResultsProvider.notifier).clear();
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (query) => _performSearch(query),
              onChanged: (value) {
                if (_debounceTimer?.isActive ?? false) {
                  _debounceTimer!.cancel();
                }
                _debounceTimer = Timer(
                  const Duration(milliseconds: 300),
                  () => ref.read(searchQueryProvider.notifier).state = value,
                );
              },
            ),
          ),
          
          // Search Results or Suggestions
          Expanded(
            child: searchResults.when(
              data: (products) => products.isNotEmpty
                  ? _buildSearchResults(products)
                  : _buildSearchSuggestions(),
              loading: () => const LoadingState(),
              error: (_, __) => Center(
                child: EmptyState(
                  title: localizationService.getString('error'),
                  message: localizationService.getString('searchError'),
                  icon: Icons.error_outline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Product> products) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(context, product);
      },
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          Consumer(
            builder: (context, ref, child) {
              final recentSearches = ref.watch(recentSearchesProvider);
              return recentSearches.when(
                data: (searches) => searches.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('البحث الأخير'),
                          const SizedBox(height: 8),
                          _buildSearchChips(searches, _onRecentSearchTap),
                          const SizedBox(height: 24),
                        ],
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
          
          // Trending Searches
          Consumer(
            builder: (context, ref, child) {
              final trendingSearches = ref.watch(trendingSearchesProvider);
              return trendingSearches.when(
                data: (searches) => searches.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('الأكثر بحثاً'),
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
          
          // Search Suggestions
          if (_searchController.text.isNotEmpty)
            Consumer(
              builder: (context, ref, child) {
                final suggestions = ref.watch(
                  searchSuggestionsProvider,
                );
                return suggestions.when(
                  data: (items) => items.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('اقتراحات البحث'),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
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

  Widget _buildProductListItem(BuildContext context, ProductItem product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => context.go('${AppRouter.productDetail}/${product.id}'),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 30),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Rating
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Price
                    Row(
                      children: [
                        Text(
                          '${AppConfig.defaultCurrency} ${product.price.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (product.originalPrice > product.price) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${AppConfig.defaultCurrency} ${product.originalPrice.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Add to Cart Button
              IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocalizationService.instance.getString('productAddedToCart')),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildProductCard(BuildContext context, Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => context.go('${AppRouter.productDetail}/${product.id}'),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  image: product.images.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(product.images[0]),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: product.images.isEmpty
                    ? const Center(child: Icon(Icons.image, size: 30))
                    : null,
              ),
              
              const SizedBox(width: 12),
              
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${product.reviewCount})',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Price
                    Row(
                      children: [
                        Text(
                          '${AppConfig.defaultCurrency} ${product.price.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (product.originalPrice != null &&
                            product.originalPrice! > product.price) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${AppConfig.defaultCurrency} ${product.originalPrice!.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Add to Cart Button
              Consumer(
                builder: (context, ref, child) {
                  final isInCart = ref.watch(
                    isProductInCartProvider(product.id),
                  );
                  return IconButton(
                    icon: Icon(
                      isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                      color: isInCart
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    onPressed: () {
                      if (isInCart) {
                        ref.read(cartProvider.notifier).removeFromCart(product.id);
                      } else {
                        ref.read(cartProvider.notifier).addToCart(product);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isInCart
                                ? LocalizationService.instance
                                    .getString('productRemovedFromCart')
                                : LocalizationService.instance
                                    .getString('productAddedToCart'),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    
    // Add to recent searches
    ref.read(recentSearchesProvider.notifier).addRecentSearch(query);
    
    // Perform search
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
        context.pushNamed('productDetail', pathParameters: {'id': ?suggestion.productId});
        break;
      default:
        _searchController.text = suggestion.text;
        _performSearch(suggestion.text);
        break;
    }
  }
}

class ProductItem {
  final String id;
  final String name;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final String category;
  final bool isInStock;
  final double rating;

  ProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.category,
    required this.isInStock,
    required this.rating,
  });
}
