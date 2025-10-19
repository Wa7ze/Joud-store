import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/localization_service.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/page_container.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/ui_states.dart';
import '../models/product.dart';
import '../providers/favorites_provider.dart';
import '../services/product_service.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  static const _suggestedCount = 6;

  List<Product>? _suggestions;
  bool _isLoadingSuggestions = true;
  bool _hasSuggestionError = false;

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    setState(() {
      _isLoadingSuggestions = true;
      _hasSuggestionError = false;
    });
    try {
      final results = await ProductService().getRandomProducts(_suggestedCount);
      if (!mounted) return;
      setState(() {
        _suggestions = results;
        _isLoadingSuggestions = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _suggestions = const <Product>[];
        _isLoadingSuggestions = false;
        _hasSuggestionError = true;
      });
    }
  }

  Future<void> _onRefresh() async {
    ref.invalidate(favoriteProductsProvider);
    await ref.read(favoriteProductsProvider.future);
    await _loadSuggestions();
  }

  Future<void> _confirmClearFavorites(BuildContext context) async {
    final localization = LocalizationService.instance;
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localization.getString('favoritesClearConfirmTitle')),
        content: Text(localization.getString('favoritesClearConfirmMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(localization.getString('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(localization.getString('clear')),
          ),
        ],
      ),
    );

    if (shouldClear == true) {
      await ref.read(favoritesProvider.notifier).clearAll();
      if (!mounted) return;
      ref.invalidate(favoriteProductsProvider);
      await _loadSuggestions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = LocalizationService.instance;
    final favoriteIds = ref.watch(favoritesProvider);
    final favoritesAsync = ref.watch(favoriteProductsProvider);

    return ScreenScaffold(
      title: localization.getString('favorites'),
      showBackButton: false,
      currentIndex: 1,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: favoritesAsync.when(
        loading: () => const LoadingState(),
        error: (_, __) => _buildErrorContent(context),
        data: (favorites) => RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: _onRefresh,
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              _HeroHeader(
                favoritesCount: favoriteIds.length,
                hasFavorites: favorites.isNotEmpty,
                onExploreTap: () => context.go(AppRouter.home),
                onClearTap: favorites.isNotEmpty
                    ? () => _confirmClearFavorites(context)
                    : null,
              ),
              if (favorites.isEmpty)
                const _EmptyFavoritesState()
              else
                _FavoritesGrid(products: favorites),
              const SizedBox(height: 16),
              _SuggestionsBlock(
                isLoading: _isLoadingSuggestions,
                hasError: _hasSuggestionError,
                products: _suggestions ?? const <Product>[],
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context) {
    final localization = LocalizationService.instance;
    return PageContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmptyState(
            title: localization.getString('favoritesUnavailableTitle'),
            message: localization.getString('favoritesUnavailableMessage'),
            icon: Icons.favorite_border,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => ref.refresh(favoriteProductsProvider),
            child: Text(localization.getString('retry')),
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.favoritesCount,
    required this.hasFavorites,
    required this.onExploreTap,
    this.onClearTap,
  });

  final int favoritesCount;
  final bool hasFavorites;
  final VoidCallback onExploreTap;
  final VoidCallback? onClearTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = LocalizationService.instance;
    final subtitle = hasFavorites
        ? (favoritesCount == 1
                  ? localization.getString('favoritesHeaderSubtitleSingular')
                  : localization.getString('favoritesHeaderSubtitlePlural'))
              .replaceAll('{count}', favoritesCount.toString())
        : localization.getString('favoritesHeaderSubtitleEmpty');

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2B5876), Color(0xFF4E4376)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization.getString('favorites'),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: onExploreTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2B5876),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.explore_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(localization.getString('favoritesExploreButton')),
                    ],
                  ),
                ),
                if (hasFavorites && onClearTap != null)
                  OutlinedButton.icon(
                    onPressed: onClearTap,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: Text(localization.getString('favoritesClearButton')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavoritesState extends StatelessWidget {
  const _EmptyFavoritesState();

  @override
  Widget build(BuildContext context) {
    final localization = LocalizationService.instance;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: EmptyState(
        title: localization.getString('favoritesEmptyTitle'),
        message: localization.getString('favoritesEmptyMessage'),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
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

class _SuggestionsBlock extends StatelessWidget {
  const _SuggestionsBlock({
    required this.isLoading,
    required this.hasError,
    required this.products,
  });

  final bool isLoading;
  final bool hasError;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = LocalizationService.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.getString('favoritesSuggestionsTitle'),
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const LoadingState()
          else if (hasError)
            EmptyState(
              title: localization.getString('favoritesSuggestionsOfflineTitle'),
              message: localization.getString(
                'favoritesSuggestionsOfflineMessage',
              ),
              icon: Icons.wifi_off,
            )
          else if (products.isEmpty)
            EmptyState(
              title: localization.getString('favoritesSuggestionsEmptyTitle'),
              message: localization.getString(
                'favoritesSuggestionsEmptyMessage',
              ),
              icon: Icons.hourglass_bottom,
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.68,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  ProductCard(product: products[index]),
            ),
        ],
      ),
    );
  }
}
