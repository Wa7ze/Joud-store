import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../models/search_suggestion.dart';
import '../../products/widgets/product_grid.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus && _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) return;
    
    // Update search query
    ref.read(searchQueryProvider.notifier).state = query;
    
    // Add to recent searches
    ref.read(recentSearchesProvider.notifier).addRecentSearch(query);
    
    // Perform search
    ref.read(searchResultsProvider.notifier).search(query);
    
    // Clear focus and hide suggestions
    _focusNode.unfocus();
    setState(() {
      _showSuggestions = false;
    });
  }

  void _onSuggestionTap(SearchSuggestion suggestion) {
    String searchQuery = suggestion.text;
    _searchController.text = searchQuery;
    _onSearch(searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'ابحث عن منتجات...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                ref.read(searchResultsProvider.notifier).clear();
              },
            ),
          ),
          textInputAction: TextInputAction.search,
          onChanged: (value) {
            setState(() {
              _showSuggestions = value.isNotEmpty;
            });
            ref.read(searchQueryProvider.notifier).state = value;
          },
          onSubmitted: _onSearch,
        ),
      ),
      body: Column(
        children: [
          if (_showSuggestions) ...[
            Expanded(
              child: _buildSuggestions(),
            ),
          ] else ...[
            _buildSearchContent(),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    final query = _searchController.text;
    
    return ListView(
      children: [
        // Live suggestions based on input
        Consumer(
          builder: (context, ref, child) {
            final suggestions = ref.watch(searchSuggestionsProvider);
            
            return suggestions.when(
              data: (data) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final suggestion in data)
                    ListTile(
                      leading: _getSuggestionIcon(suggestion.type),
                      title: Text(suggestion.text),
                      onTap: () => _onSuggestionTap(suggestion),
                    ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchContent() {
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final query = ref.watch(searchQueryProvider);
          
          if (query.isEmpty) {
            return _buildInitialContent();
          }
          
          final searchResults = ref.watch(searchResultsProvider);
          
          return searchResults.when(
            data: (products) {
              if (products.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد نتائج للبحث عن "$query"',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              }
              
              return ProductGrid(products: products);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text('حدث خطأ: $error'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInitialContent() {
    return ListView(
      children: [
        // Recent searches section
        Consumer(
          builder: (context, ref, child) {
            final recentSearches = ref.watch(recentSearchesProvider);
            
            return recentSearches.when(
              data: (searches) => searches.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'عمليات البحث السابقة',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(recentSearchesProvider.notifier)
                                      .clearRecentSearches();
                                },
                                child: const Text('مسح'),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: searches.length,
                          itemBuilder: (context, index) {
                            final search = searches[index];
                            return ListTile(
                              leading: const Icon(Icons.history),
                              title: Text(search),
                              onTap: () {
                                _searchController.text = search;
                                _onSearch(search);
                              },
                            );
                          },
                        ),
                      ],
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            );
          },
        ),

        // Trending searches section
        Consumer(
          builder: (context, ref, child) {
            final trendingSearches = ref.watch(trendingSearchesProvider);

            return trendingSearches.when(
              data: (searches) => searches.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'الأكثر بحثاً',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: searches
                              .map(
                                (search) => Chip(
                                  label: Text(search),
                                  onDeleted: () {
                                    _searchController.text = search;
                                    _onSearch(search);
                                  },
                                  deleteIcon: const Icon(
                                    Icons.arrow_forward,
                                    size: 18,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }

  Icon _getSuggestionIcon(SuggestionType type) {
    switch (type) {
      case SuggestionType.search:
        return const Icon(Icons.search);
      case SuggestionType.category:
        return const Icon(Icons.category);
      case SuggestionType.subcategory:
        return const Icon(Icons.subdirectory_arrow_right);
      case SuggestionType.product:
        return const Icon(Icons.shopping_bag);
      case SuggestionType.brand:
        return const Icon(Icons.branding_watermark);
      case SuggestionType.style:
        return const Icon(Icons.style);
    }
  }
}