import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/widgets/product_card.dart';
import 'models/product.dart';
import 'models/product_filters.dart';
import 'services/product_service.dart';

class ProductListScreen extends StatefulWidget {
  final ProductFilters filters;

  const ProductListScreen({super.key, required this.filters});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _service = ProductService();
  final _scrollController = ScrollController();
  final List<Product> _products = [];

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetch({bool refresh = false}) async {
    try {
      if (refresh) {
        setState(() {
          _page = 1;
          _hasMore = true;
          _products.clear();
        });
      }
      if (!_hasMore) return;
      setState(() {
        if (_page == 1) {
          _isLoading = true;
        } else {
          _isLoadingMore = true;
        }
        _error = null;
      });

      final list = await _service.getProducts(
        categoryId: widget.filters.categoryId,
        subcategory: widget.filters.subcategory,
        query: widget.filters.searchQuery,
        sortBy: widget.filters.sortBy,
        minPrice: widget.filters.minPrice,
        maxPrice: widget.filters.maxPrice,
        sizes: widget.filters.selectedSizes,
        colors: widget.filters.selectedColors,
        styles: widget.filters.selectedStyles,
        occasions: widget.filters.selectedOccasions,
        page: _page,
        pageSize: 24,
      );

      setState(() {
        if (refresh) _products.clear();
        _products.addAll(list);
        _isLoading = false;
        _isLoadingMore = false;
        if (list.length < 24) _hasMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _error = e.toString();
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 300) {
      if (!_isLoadingMore && _hasMore) {
        _page++;
        _fetch();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;

    Widget content;
    if (_isLoading) {
      content = const LoadingState();
    } else if (_error != null) {
      content = EmptyState(
        title: localizationService.getString('error'),
        message: _error,
      );
    } else if (_products.isEmpty) {
      content = const EmptyState(
        title: 'لا توجد منتجات',
        message: 'جرّب تعديل عوامل التصفية أو ابحث عن مصطلح آخر.',
      );
    } else {
      content = RefreshIndicator(
        onRefresh: () => _fetch(refresh: true),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: _products.length + (_isLoadingMore ? 2 : 0),
              itemBuilder: (context, index) {
                if (index >= _products.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final product = _products[index];
                return ProductCard(
                  product: product,
                  onTap: () => context.push('${AppRouter.productDetail}/${product.id}'),
                );
              },
            ),
          ),
        ),
      );
    }

    return ScreenScaffold(
      title: localizationService.getString('products'),
      showBackButton: true,
      currentIndex: 1,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: content,
    );
  }
}
