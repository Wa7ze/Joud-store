import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/config/app_config.dart';
import '../../core/router/app_router.dart';
import 'providers/cart_provider.dart';
import 'models/cart_item.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isLoading = false;
  String? _appliedCoupon;
  double _deliveryFee = 0;

  @override
  void initState() {
    super.initState();
    _deliveryFee = AppConfig.deliveryFees['damascus'] ?? 5000;
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    final items = ref.watch(cartProvider);

    return ScreenScaffold(
      title: localizationService.getString('cart'),
      showBackButton: false,
      currentIndex: 3,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: _isLoading
          ? const LoadingState()
          : Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 780),
                child: items.isEmpty
                    ? EmptyState(
                        title: localizationService.getString('emptyCart'),
                        message: 'Ø§Ø¨Ø¯Ø£ Ø¨Ø¥Ø¶Ø§ÙØ© Ù…Ù†ØªØ¬Ø§Øª Ø¥Ù„Ù‰ Ø§Ù„Ø³Ù„Ø© Ù„Ø¥ØªÙ…Ø§Ù… Ø·Ù„Ø¨Ùƒ.',
                        icon: Icons.shopping_cart_outlined,
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return _buildCartItem(items[index]);
                              },
                            ),
                          ),
                          _buildCartSummary(items),
                        ],
                      ),
              ),
            ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.imageUrl == null || item.imageUrl!.isEmpty
                  ? const Center(child: Icon(Icons.image, size: 30))
                  : _buildImage(item.imageUrl!),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (item.size != null || item.color != null) ...[
                    Text(
                      '${item.size ?? ''} ${item.color ?? ''}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Row(
                    children: [
                      Text(
                        '${AppConfig.defaultCurrency} ${item.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if ((item.originalPrice ?? 0) > item.price) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${AppConfig.defaultCurrency} ${(item.originalPrice ?? 0).toStringAsFixed(0)}',
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
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: item.quantity > 1
                      ? () => ref
                          .read(cartProvider.notifier)
                          .updateQuantity(item.id, item.quantity - 1)
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(item.quantity.toString()),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => ref
                      .read(cartProvider.notifier)
                      .updateQuantity(item.id, item.quantity + 1),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _removeItem(item.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(List<CartItem> items) {
    final localizationService = LocalizationService.instance;
    final subtotal = items.fold<double>(0, (sum, item) => sum + item.price * item.quantity);
    final discount = _appliedCoupon != null ? subtotal * 0.1 : 0;
    final total = subtotal - discount + _deliveryFee;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: localizationService.getString('couponCode'),
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyCoupon,
                child: Text(localizationService.getString('applyCoupon')),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizationService.getString('subtotal')),
              Text('${AppConfig.defaultCurrency} ${subtotal.toStringAsFixed(0)}'),
            ],
          ),
          if (_appliedCoupon != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(localizationService.getString('discount')),
                Text(
                  '-${AppConfig.defaultCurrency} ${discount.toStringAsFixed(0)}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ),
          ],
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizationService.getString('delivery')),
              Text('${AppConfig.defaultCurrency} ${_deliveryFee.toStringAsFixed(0)}'),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizationService.getString('total'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '${AppConfig.defaultCurrency} ${total.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: items.isNotEmpty ? _proceedToCheckout : null,
              child: Text(localizationService.getString('checkout')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image));
    }
    return Image.asset(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image));
  }

  void _removeItem(String itemId) {
    ref.read(cartProvider.notifier).removeById(itemId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocalizationService.instance.getString('productRemovedFromCart')),
      ),
    );
  }

  void _applyCoupon() {
    setState(() {
      _appliedCoupon = 'SAVE10';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocalizationService.instance.getString('couponApplied')),
      ),
    );
  }

  void _proceedToCheckout() {
    context.go(AppRouter.checkout);
  }
}

