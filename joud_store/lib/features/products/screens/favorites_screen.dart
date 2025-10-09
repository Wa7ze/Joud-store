import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/ui_states.dart';
import '../../products/providers/favorites_provider.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/router/app_router.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteProductsProvider);

    return ScreenScaffold(
      title: 'المفضلة',
      showBackButton: true,
      currentIndex: 2,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: favoritesAsync.when(
        loading: () => const LoadingState(),
        error: (_, __) => const EmptyState(
          title: 'تعذر تحميل المفضلة',
          message: 'حاول مجدداً بعد قليل.',
          icon: Icons.favorite_border,
        ),
        data: (products) {
          if (products.isEmpty) {
            return const EmptyState(
              title: 'لا توجد منتجات مفضلة',
              message: 'اضغط على أيقونة القلب لإضافة منتج إلى المفضلة.',
              icon: Icons.favorite_border,
            );
          }

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 780),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
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
                    onTap: () => context.push('${AppRouter.productDetail}/${product.id}'),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
