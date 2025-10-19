import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/localization_service.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/widgets/page_container.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/ui_states.dart';
import '../products/models/product.dart';
import '../products/services/product_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Product>> _cartProductsFuture;

  @override
  void initState() {
    super.initState();
    _cartProductsFuture = ProductService().getProducts(
      categoryId: 'men',
      pageSize: 2,
      sortBy: 'latest',
    );
  }

  Future<void> _handleCheckout() async {
    final localization = LocalizationService.instance;
    final overlayState = Overlay.of(context);

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    final overlayEntry = OverlayEntry(
      builder: (context) => _CheckoutOverlay(
        controller: controller,
        processingLabel: localization.getString('cartProcessingOrder'),
      ),
    );

    overlayState.insert(overlayEntry);
    await controller.forward();
    overlayEntry.remove();
    controller.dispose();

    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_shipping, color: Colors.green, size: 40),
            const SizedBox(height: 12),
            Text(
              localization.getString('cartOnTheWayTitle'),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localization.getString('cartAwesomeButton')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = LocalizationService.instance;
    return ScreenScaffold(
      showBackButton: false,
      currentIndex: 2,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: FutureBuilder<List<Product>>(
        future: _cartProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingState();
          }

          if (snapshot.hasError) {
            return PageContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyState(
                    title: localization.getString('cartUnavailableTitle'),
                    message: localization.getString('cartUnavailableMessage'),
                    icon: Icons.shopping_cart_outlined,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _cartProductsFuture = ProductService().getProducts(
                          categoryId: 'men',
                          pageSize: 2,
                          sortBy: 'latest',
                        );
                      });
                    },
                    child: Text(localization.getString('retry')),
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data ?? const <Product>[];
          if (products.isEmpty) {
            return PageContainer(
              child: EmptyState(
                title: localization.getString('cartEmptyTitle'),
                message: localization.getString('cartEmptyMessage'),
                icon: Icons.shopping_cart_outlined,
              ),
            );
          }

          final totalCost = products.fold<double>(
            0,
            (sum, item) => sum + item.price,
          );

          return PageContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.68,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) => ProductCard(
                      product: products[index],
                      onTap: () => context.push(
                        '${AppRouter.productDetail}/${products[index].id}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(localization.getString('total')),
                            Text(
                              CurrencyUtils.format(totalCost),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _handleCheckout,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(localization.getString('checkout')),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CheckoutOverlay extends StatelessWidget {
  const _CheckoutOverlay({
    required this.controller,
    required this.processingLabel,
  });

  final AnimationController controller;
  final String processingLabel;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final progress = animation.value;
          final size = MediaQuery.of(context).size;
          final circleSize = 100 + (progress * 60);
          final checkOpacity = progress.clamp(0.6, 1.0);

          return Stack(
            children: [
              Opacity(
                opacity: progress * 0.6,
                child: Container(color: Colors.black),
              ),
              Center(
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: circleSize - 24,
                        height: circleSize - 24,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: checkOpacity,
                        child: Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: circleSize / 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.25,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: progress,
                  child: Text(
                    processingLabel,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
