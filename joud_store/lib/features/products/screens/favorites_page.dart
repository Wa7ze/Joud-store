import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/widgets/page_container.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/ui_states.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<Product>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _fetchFavorites();
  }

  Future<List<Product>> _fetchFavorites() {
    return ProductService().getProducts(
      categoryId: 'women',
      pageSize: 5,
      sortBy: 'latest',
    );
  }

  Future<void> _refreshFavorites() async {
    setState(() {
      _favoritesFuture = _fetchFavorites();
    });
    await _favoritesFuture;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      showBackButton: false,
      currentIndex: 1,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: FutureBuilder<List<Product>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingState();
          }

          if (snapshot.hasError) {
            return _ErrorState(onRetry: _refreshFavorites);
          }

          final products = snapshot.data ?? const <Product>[];
          return RefreshIndicator(
            onRefresh: _refreshFavorites,
            color: Theme.of(context).colorScheme.primary,
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                _HeroBanner(
                  productCount: products.length,
                  onShopWomenTap: () =>
                      context.go('${AppRouter.productList}?categoryId=women'),
                ),
                if (products.isEmpty)
                  const _EmptyFavoritesSection()
                else
                  _FavoritesGrid(products: products),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmptyState(
            title: 'Could not load favorites',
            message: 'Please check your connection and try again.',
            icon: Icons.favorite_border,
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.productCount, required this.onShopWomenTap});

  final int productCount;
  final VoidCallback onShopWomenTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = productCount > 0
        ? 'Here are $productCount pieces picked from our women\'s collection.'
        : 'Save your favourite styles and we\'ll surface them here.';

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF8360C3), Color(0xFF2EBF91)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Curated favorites',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.tonalIcon(
            onPressed: onShopWomenTap,
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Shop women\'s collection'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFavoritesSection extends StatelessWidget {
  const _EmptyFavoritesSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: EmptyState(
        title: 'No favorites yet',
        message:
            'Tap the heart on any product to save it to this shortlist for quick access.',
        icon: Icons.favorite_border,
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  const _FavoritesGrid({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.68,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) => ProductCard(product: products[index]),
      ),
    );
  }
}
