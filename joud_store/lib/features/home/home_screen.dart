import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/localization_service.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_shell.dart';
import '../../core/utils/currency_utils.dart';
import '../products/models/product.dart';
import '../products/services/product_service.dart';
import '../../core/widgets/page_container.dart';
import '../settings/providers/settings_provider.dart';
import 'widgets/category_nav_bar.dart';
import 'widgets/category_showcase.dart';
import 'widgets/brand_focus_section.dart';
import 'widgets/hero_slideshow.dart';
import 'widgets/marketing_grid.dart';
import 'widgets/newsletter_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();
  final Map<String, Future<List<Product>>> _categoryFutures = {};
  final ScrollController _homeScrollController = ScrollController();
  late final VoidCallback _homeScrollListener;
  final Map<int, ScrollController> _categoryControllers = {};
  final TextEditingController _newsletterController = TextEditingController();

  int _currentCategoryIndex = -1;
  int _previousCategoryIndex = -1;
  bool _showScrollToTop = false;
  bool _isSubmittingNewsletter = false;

  static const Map<String, String> _currencyLabelKeys = {
    'SYP': 'currencyNameSYP',
    'USD': 'currencyNameUSD',
    'TRY': 'currencyNameTRY',
  };

  static const List<_CategoryLink> _categoryLinks = [
    _CategoryLink(
      labelKey: 'categoryWomen',
      queries: [
        _CategoryQuery(
          categoryId: 'women',
          subcategory: 'dresses',
          sortBy: 'latest',
        ),
        _CategoryQuery(categoryId: 'women', subcategory: 'outerwear'),
        _CategoryQuery(categoryId: 'women', styles: ['Modest', 'Minimal']),
      ],
    ),
    _CategoryLink(
      labelKey: 'categoryMen',
      queries: [
        _CategoryQuery(
          categoryId: 'men',
          subcategory: 'jackets',
          sortBy: 'latest',
        ),
        _CategoryQuery(categoryId: 'men', subcategory: 'shirts'),
        _CategoryQuery(categoryId: 'men', styles: ['Sporty', 'Classic']),
      ],
    ),
    _CategoryLink(
      labelKey: 'categoryBoys',
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
        _CategoryQuery(categoryId: 'kids', subcategory: 'jeans'),
      ],
    ),
    _CategoryLink(
      labelKey: 'categoryGirls',
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
      labelKey: 'categoryBaby',
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
      labelKey: 'categoryBeauty',
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
      labelKey: 'categoryGifts',
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
  void initState() {
    super.initState();
    _homeScrollListener = _onHomeScroll;
    _homeScrollController.addListener(_homeScrollListener);
  }

  @override
  void dispose() {
    _homeScrollController
      ..removeListener(_homeScrollListener)
      ..dispose();
    for (final controller in _categoryControllers.values) {
      controller.dispose();
    }
    _searchController.dispose();
    _newsletterController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _showSnackBar(LocalizationService.instance.getString('homeSearchPrompt'));
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
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  void _handleScroll(ScrollController controller) {
    if (!controller.hasClients || !controller.position.hasContentDimensions)
      return;
    final maxExtent = controller.position.maxScrollExtent;
    final shouldShow = maxExtent > 0 && controller.offset >= maxExtent * 0.5;
    if (shouldShow != _showScrollToTop) {
      setState(() {
        _showScrollToTop = shouldShow;
      });
    }
  }

  void _onHomeScroll() => _handleScroll(_homeScrollController);

  void _scrollToTop() {
    final controller = _currentScrollController;
    if (!controller.hasClients) return;
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
    setState(() => _showScrollToTop = false);
  }

  void _submitNewsletter(String email) {
    final trimmed = email.trim();
    final emailRegex = RegExp(r'^[\w\-.]+@[\w-]+\.[\w\-.]+$');
    if (trimmed.isEmpty || !emailRegex.hasMatch(trimmed)) {
      _showSnackBar('Please enter a valid email address.');
      return;
    }
    if (_isSubmittingNewsletter) return;
    setState(() => _isSubmittingNewsletter = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _isSubmittingNewsletter = false);
      _newsletterController.clear();
      _showSnackBar(
        'Thanks for subscribing! Check your inbox for a confirmation.',
      );
    });
  }

  void _setCurrentCategory(int index) {
    if (_currentCategoryIndex == index) return;
    setState(() {
      _previousCategoryIndex = _currentCategoryIndex;
      _currentCategoryIndex = index;
    });
    _scrollToTop();
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
    _scrollToTop();
  }

  Future<List<Product>> _getCategoryProducts(_CategoryLink link) {
    final cacheKey = link.cacheKey;
    return _categoryFutures.putIfAbsent(cacheKey, () async {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = LocalizationService.instance;
    final settings = ref.watch(settingsProvider);
    final textDirection = Directionality.of(context);
    final currentKey = ValueKey<int>(_currentCategoryIndex);
    final slideOffset = _computePageOffset(
      _previousCategoryIndex,
      _currentCategoryIndex,
      textDirection,
    );

    return AppShell(
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      showHeaderActions: false,
      showBottomNav: true,
      bottomNavIndex: 0,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      searchController: _searchController,
      onSearchSubmitted: (_) => _handleSearch(),
      onSearchIconPressed: _handleSearch,
      onGlobeTap: () =>
          _showSnackBar(localization.getString('globalPreferencesComingSoon')),
      onCurrencyTap: _showCurrencySelector,
      onCartTap: () => context.go(AppRouter.cart),
      onFavoritesTap: () => context.go(AppRouter.favorites),
      onProfileTap: () => context.go(AppRouter.profile),
      onBrandTap: _handleLogoTap,
      headerBottom: CategoryNavBar(
        categories: _categoryLinks
            .map((item) => localization.getString(item.labelKey))
            .toList(),
        selectedIndex: _currentCategoryIndex,
        onCategorySelected: _handleCategorySelected,
      ),
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        transitionBuilder: (child, animation) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          final isIncoming = child.key == currentKey;
          final beginOffset = isIncoming
              ? slideOffset
              : Offset(-slideOffset.dx, 0);
          final tween = Tween<Offset>(
            begin: beginOffset,
            end: Offset.zero,
          ).animate(curved);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(position: tween, child: child),
          );
        },
        child: KeyedSubtree(
          key: currentKey,
          child: _currentCategoryIndex < 0
              ? _buildHomeView(settings, localization)
              : _buildCategoryView(
                  _categoryLinks[_currentCategoryIndex],
                  textDirection,
                  localization,
                ),
        ),
      ),
    );
  }

  Future<void> _showCurrencySelector() async {
    final localization = LocalizationService.instance;
    final settings = ref.read(settingsProvider);
    final currentCode = settings.currency;
    final options = CurrencyUtils.availableCurrencies;

    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(
                    localization.getString('homeCurrencySheetTitle'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    localization.getString('homeCurrencySheetSubtitle'),
                  ),
                ),
                for (final code in options)
                  RadioListTile<String>(
                    value: code,
                    groupValue: currentCode,
                    onChanged: (value) => Navigator.of(sheetContext).pop(value),
                    title: Text(_currencyLabel(code, localization)),
                    subtitle: Text(code),
                  ),
                TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: Text(
                    localization.getString('homeCurrencySheetCancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || selected == null || selected == currentCode) {
      return;
    }

    await ref.read(settingsProvider.notifier).setCurrency(selected);
  }

  Widget _buildHomeView(
    SettingsState settings,
    LocalizationService localization,
  ) {
    final currencyName = _currencyLabel(settings.currency, localization);
    return SingleChildScrollView(
      controller: _homeScrollController,
      child: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: OutlinedButton.icon(
                onPressed: _showCurrencySelector,
                icon: const Icon(Icons.currency_exchange),
                label: Text(
                  "${localization.getString('homeCurrencyButtonLabel')} "
                  "($currencyName - ${settings.currency})",
                ),
              ),
            ),
            const SizedBox(height: 24),
            const HeroSlideshow(),
            const SizedBox(height: 40),
            const MarketingGrid(),
            const SizedBox(height: 40),
            const BrandFocusSection(),
            const SizedBox(height: 36),
            NewsletterSection(
              controller: _newsletterController,
              onSubmit: _submitNewsletter,
              isSubmitting: _isSubmittingNewsletter,
            ),
            const SizedBox(height: 56),
          ],
        ),
      ),
    );
  }

  String _currencyLabel(String code, LocalizationService localization) {
    return localization.getString(_currencyLabelKeys[code] ?? code);
  }

  Widget _buildCategoryView(
    _CategoryLink link,
    TextDirection direction,
    LocalizationService localization,
  ) {
    final controller = _ensureCategoryController(_currentCategoryIndex);
    return SingleChildScrollView(
      controller: controller,
      child: PageContainer(
        child: CategoryShowcase(
          title: localization.getString(link.labelKey),
          productsFuture: _getCategoryProducts(link),
          textDirection: direction,
        ),
      ),
    );
  }

  ScrollController get _currentScrollController => _currentCategoryIndex < 0
      ? _homeScrollController
      : _ensureCategoryController(_currentCategoryIndex);

  ScrollController _ensureCategoryController(int index) {
    return _categoryControllers.putIfAbsent(index, () {
      final controller = ScrollController();
      controller.addListener(() => _handleScroll(controller));
      return controller;
    });
  }

  Offset _computePageOffset(
    int fromIndex,
    int toIndex,
    TextDirection direction,
  ) {
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
  const _CategoryLink({required this.labelKey, required this.queries});

  final String labelKey;
  final List<_CategoryQuery> queries;

  String get cacheKey => queries.map((q) => q.cacheKey).join('|');
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
