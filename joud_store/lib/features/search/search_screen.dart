import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/router/app_router.dart';
import '../../core/config/app_config.dart';

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
  bool _isLoading = false;
  List<String> _recentSearches = [];
  List<String> _trendingSearches = [];
  List<String> _searchSuggestions = [];
  List<ProductItem> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery ?? '';
    _loadSearchData();
    if (widget.initialQuery != null) {
      _performSearch(widget.initialQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadSearchData() {
    // Mock data
    _recentSearches = ['هاتف', 'لابتوب', 'سماعات', 'ساعة ذكية'];
    _trendingSearches = ['أيفون', 'سامسونج', 'ماك بوك', 'إيربودز', 'أبل ووتش'];
    _searchSuggestions = ['هاتف ذكي', 'لابتوب للألعاب', 'سماعات لاسلكية', 'ساعة ذكية'];
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return ScreenScaffold(
      title: localizationService.getString('search'),
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
                          setState(() {
                            _searchResults.clear();
                          });
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (query) => _performSearch(query),
              onChanged: (value) => _onSearchChanged(value),
            ),
          ),
          
          // Search Results or Suggestions
          Expanded(
            child: _searchResults.isNotEmpty
                ? _buildSearchResults()
                : _buildSearchSuggestions(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return _isLoading
        ? const LoadingState()
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final product = _searchResults[index];
              return _buildProductListItem(context, product);
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
          if (_recentSearches.isNotEmpty) ...[
            _buildSectionTitle('البحث الأخير'),
            const SizedBox(height: 8),
            _buildSearchChips(_recentSearches, _onRecentSearchTap),
            const SizedBox(height: 24),
          ],
          
          // Trending Searches
          if (_trendingSearches.isNotEmpty) ...[
            _buildSectionTitle('الأكثر بحثاً'),
            const SizedBox(height: 8),
            _buildSearchChips(_trendingSearches, _onTrendingSearchTap),
            const SizedBox(height: 24),
          ],
          
          // Search Suggestions
          if (_searchSuggestions.isNotEmpty) ...[
            _buildSectionTitle('اقتراحات البحث'),
            const SizedBox(height: 8),
            _buildSearchChips(_searchSuggestions, _onSuggestionTap),
          ],
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

  void _onSearchChanged(String value) {
    setState(() {
      // Update suggestions based on input
      if (value.isNotEmpty) {
        _searchSuggestions = _trendingSearches
            .where((item) => item.toLowerCase().contains(value.toLowerCase()))
            .toList();
      } else {
        _searchSuggestions = ['هاتف ذكي', 'لابتوب للألعاب', 'سماعات لاسلكية', 'ساعة ذكية'];
      }
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    
    setState(() {
      _isLoading = true;
    });
    
    // Add to recent searches
    if (!_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 5) {
        _recentSearches = _recentSearches.take(5).toList();
      }
    }
    
    // Mock search results
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _searchResults = List.generate(10, (index) => ProductItem(
            id: 'search_result_$index',
            name: '$query ${index + 1}',
            price: 10000 + (index * 5000),
            originalPrice: 15000 + (index * 5000),
            imageUrl: '',
            category: 'search',
            isInStock: index % 3 != 0,
            rating: 4.0 + (index % 5) * 0.2,
          ));
        });
      }
    });
  }

  void _onRecentSearchTap(String query) {
    _searchController.text = query;
    _performSearch(query);
  }

  void _onTrendingSearchTap(String query) {
    _searchController.text = query;
    _performSearch(query);
  }

  void _onSuggestionTap(String query) {
    _searchController.text = query;
    _performSearch(query);
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
