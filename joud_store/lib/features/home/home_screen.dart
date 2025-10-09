import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/widgets/app_shell.dart';
import '../products/models/product.dart';
import '../products/services/product_service.dart';
import 'widgets/category_nav_bar.dart';
import 'widgets/category_showcase.dart';
import 'widgets/hero_slideshow.dart';
import 'widgets/marketing_grid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();
  final Map<String, Future<List<Product>>> _categoryFutures = {};

  int _currentCategoryIndex = -1;
  int _previousCategoryIndex = -1;

  static const List<_CategoryLink> _categoryLinks = [
    _CategoryLink(
      label: 'Women',
      queries: [
        _CategoryQuery(categoryId: 'women', subcategory: 'dresses', sortBy: 'latest'),
        _CategoryQuery(categoryId: 'women', subcategory: 'outerwear'),
        _CategoryQuery(categoryId: 'women', styles: ['Modest', 'Minimal']),
      ],
    ),
    _CategoryLink(
      label: 'Men',
      queries: [
        _CategoryQuery(categoryId: 'men', subcategory: 'jackets', sortBy: 'latest'),
        _CategoryQuery(categoryId: 'men', subcategory: 'shirts'),
        _CategoryQuery(categoryId: 'men', styles: ['Sporty', 'Classic']),
      ],
    ),
    _CategoryLink(
      label: 'Boys',
      queries: [
        _CategoryQuery(
          categoryId: 'kids',
          subcategory: 'tshirts',
          sizes: ['6', '8', '10', '12'],
        ),
        _CategoryQuery(
          categoryId: 'kids',
          subcategory: 'sportswear',
          styles: ['Sporty'],
        ),
        _CategoryQuery(
          categoryId: 'kids',
          subcategory: 'jeans',
        ),
      ],
    ),
    _CategoryLink(
      label: 'Girls',
      queries: [
        _CategoryQuery(
          categoryId: 'kids',
          subcategory: 'sets',
          sizes: ['6', '8', '10'],
        ),
        _CategoryQuery(
          categoryId: 'kids',
          subcategory: 'hoodies',
          styles: ['Streetwear', 'Minimal'],
        ),
      ],
    ),
    _CategoryLink(
      label: 'Baby',
      queries: [
        _CategoryQuery(
          categoryId: 'kids',
          subcategory: 'sets',
          sizes: ['2', '4'],
        ),
        _CategoryQuery(
          categoryId: 'kids',
          subcategory: 'tshirts',
          sizes: ['2', '4'],
        ),
      ],
    ),
    _CategoryLink(
      label: 'Beauty',
      queries: [
        _CategoryQuery(
          categoryId: 'women',
          styles: ['Minimal'],
          colors: ['Pink', 'Purple'],
        ),
        _CategoryQuery(
          categoryId: 'women',
          subcategory: 'blouses',
          sortBy: 'latest',
        ),
      ],
    ),
    _CategoryLink(
      label: 'Gifts',
      queries: [
        _CategoryQuery(
          categoryId: 'women',
          subcategory: 'dresses',
          occasions: ['Formal'],
        ),
        _CategoryQuery(
          categoryId: 'men',
          subcategory: 'jackets',
          occasions: ['Formal', 'Casual'],
        ),
        _CategoryQuery(
          categoryId: 'men',
          subcategory: 'sportswear',
          occasions: ['Sports'],
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _showSnackBar('Start typing to discover new looks.');
      return;
    }
    FocusScope.of(context).unfocus();
    final encodedQuery = Uri.encodeComponent(query);
    context.go('${AppRouter.search}?q=$encodedQuery');
  }

  void _handleCategorySelected(int index) {
    if (index < 0 || index >= _categoryLinks.length) return;
    _setCurrentCategory(index);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _setCurrentCategory(int index) {
    if (_currentCategoryIndex == index) return;
    setState(() {
      _previousCategoryIndex = _currentCategoryIndex;
      _currentCategoryIndex = index;
    });
  }

  void _handleLogoTap() {
    if (_currentCategoryIndex == -1) return;
    setState(() {
      _previousCategoryIndex = _currentCategoryIndex;
      _currentCategoryIndex = -1;
    });
    if (mounted) {
      context.go(AppRouter.home);
    }
  }

  Future<List<Product>> _getCategoryProducts(_CategoryLink link) {
    final cacheKey = link.cacheKey;
    return _categoryFutures.putIfAbsent(
      cacheKey,
      () async {
        final responses = await Future.wait([
          for (final query in link.queries)
            _productService.getProducts(
              categoryId: query.categoryId,
              subcategory: query.subcategory,
              styles: query.styles,
              occasions: query.occasions,
              sizes: query.sizes,
              colors: query.colors,
              sortBy: query.sortBy,
              pageSize: 12,
            ),
        ]);
        final Map<String, Product> merged = {};
        for (final list in responses) {
          for (final product in list) {
            merged[product.id] = product;
          }
        }
        final products = merged.values.toList();
        products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return products.take(18).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final currentKey = ValueKey<int>(_currentCategoryIndex);
    final slideOffset = _computePageOffset(_previousCategoryIndex, _currentCategoryIndex, textDirection);

    return AppShell(
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      searchController: _searchController,
      onSearchSubmitted: (_) => _handleSearch(),
      onSearchIconPressed: _handleSearch,
      onGlobeTap: () => _showSnackBar('Global preferences coming soon.'),
      onCurrencyTap: () => _showSnackBar('Currency selection coming soon.'),
      onCartTap: () => context.go(AppRouter.cart),
      onFavoritesTap: () => context.go(AppRouter.favorites),
      onProfileTap: () => context.go(AppRouter.profile),
      onBrandTap: _handleLogoTap,
      headerBottom: CategoryNavBar(
        categories: _categoryLinks.map((item) => item.label).toList(),
        selectedIndex: _currentCategoryIndex,
        onCategorySelected: _handleCategorySelected,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        transitionBuilder: (child, animation) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
          final isIncoming = child.key == currentKey;
          final beginOffset = isIncoming ? slideOffset : Offset(-slideOffset.dx, 0);
          final tween = Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(curved);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: tween,
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: currentKey,
          child: _currentCategoryIndex < 0
              ? _buildHomeContent()
              : _buildCategoryContent(context, _categoryLinks[_currentCategoryIndex], textDirection),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                HeroSlideshow(),
                SizedBox(height: 40),
                MarketingGrid(),
                SizedBox(height: 56),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContent(
    BuildContext context,
    _CategoryLink link,
    TextDirection direction,
  ) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: CategoryShowcase(
              title: link.label,
              productsFuture: _getCategoryProducts(link),
              textDirection: direction,
            ),
          ),
        ),
      ),
    );
  }

  Offset _computePageOffset(int fromIndex, int toIndex, TextDirection direction) {
    if (fromIndex == toIndex) return Offset.zero;
    final bool isRtl = direction == TextDirection.rtl;
    final fromPosition = _positionFor(fromIndex, isRtl);
    final toPosition = _positionFor(toIndex, isRtl);

    if (toPosition > fromPosition) {
      // Moving toward visual end
      final dx = isRtl ? -1.0 : 1.0;
      return Offset(dx, 0);
    } else {
      final dx = isRtl ? 1.0 : -1.0;
      return Offset(dx, 0);
    }
  }

  int _positionFor(int index, bool isRtl) {
    if (index < 0) {
      return isRtl ? _categoryLinks.length : -1;
    }
    return isRtl ? (_categoryLinks.length - 1 - index) : index;
  }
}

class _CategoryLink {
  const _CategoryLink({
    required this.label,
    required this.queries,
  });

  final String label;
  final List<_CategoryQuery> queries;

  String get cacheKey =>
      queries.map((q) => q.cacheKey).join('|');
}

class _CategoryQuery {
  const _CategoryQuery({
    required this.categoryId,
    this.subcategory,
    this.styles,
    this.occasions,
    this.sizes,
    this.colors,
    this.sortBy,
  });

  final String categoryId;
  final String? subcategory;
  final List<String>? styles;
  final List<String>? occasions;
  final List<String>? sizes;
  final List<String>? colors;
  final String? sortBy;

  String get cacheKey =>
      '$categoryId-${subcategory ?? 'all'}-${styles?.join('&') ?? 'any'}-'
      '${occasions?.join('&') ?? 'any'}-${sizes?.join('&') ?? 'any'}-'
      '${colors?.join('&') ?? 'any'}-${sortBy ?? 'default'}';
}
