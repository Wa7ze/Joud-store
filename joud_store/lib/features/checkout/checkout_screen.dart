import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/app_config.dart';
import '../../core/localization/localization_service.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/ui_states.dart';
import '../cart/models/cart_item.dart';
import '../cart/providers/cart_provider.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    final cartItems = ref.watch(cartProvider);
    final steps = [
      localizationService.getString('checkoutStepAddress'),
      localizationService.getString('checkoutStepDelivery'),
      localizationService.getString('checkoutStepPayment'),
      localizationService.getString('checkoutStepReview'),
    ];

    return ScreenScaffold(
      title: localizationService.getString('checkout'),
      currentIndex: 3,
      showBackButton: true,
      centerContent: false,
      contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 16),
      body: cartItems.isEmpty
          ? EmptyState(
              title: localizationService.getString('emptyCart'),
              message: localizationService.getString('checkoutEmptyMessage'),
              icon: Icons.shopping_bag_outlined,
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 16),
                  child: Stepper(
                    currentStep: _currentStep,
                    controlsBuilder: (_, __) => const SizedBox.shrink(),
                    steps: steps
                        .asMap()
                        .entries
                        .map(
                          (entry) => Step(
                            title: Text(entry.value),
                            content: const SizedBox.shrink(),
                            isActive: _currentStep >= entry.key,
                          ),
                        )
                        .toList(),
                    onStepTapped: (step) => setState(() => _currentStep = step),
                  ),
                ),
                Expanded(child: _buildStepContent(cartItems, localizationService)),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      OutlinedButton(
                        onPressed: _currentStep > 0
                            ? () => setState(() => _currentStep--)
                            : null,
                        child: Text(localizationService.getString('back')),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentStep < steps.length - 1) {
                            setState(() => _currentStep++);
                          } else {
                            _placeOrder(cartItems);
                          }
                        },
                        child: Text(
                          _currentStep < steps.length - 1
                              ? localizationService.getString('next')
                              : localizationService.getString('placeOrder'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStepContent(List<CartItem> items, LocalizationService localization) {
    final textDirection = localization.textDirection;
    switch (_currentStep) {
      case 0:
        return _StepInfo(
          title: localization.getString('checkoutAddressTitle'),
          description: localization.getString('checkoutAddressDescription'),
          textDirection: textDirection,
        );
      case 1:
        return _StepInfo(
          title: localization.getString('checkoutDeliveryTitle'),
          description: localization.getString('checkoutDeliveryDescription'),
          textDirection: textDirection,
        );
      case 2:
        return _StepInfo(
          title: localization.getString('checkoutPaymentTitle'),
          description: localization.getString('checkoutPaymentDescription'),
          textDirection: textDirection,
        );
      case 3:
        return _buildReview(items, localization);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildReview(List<CartItem> items, LocalizationService localization) {
    final currency = AppConfig.defaultCurrency;
    final deliveryFee = AppConfig.deliveryFees['damascus'] ?? 5000;
    final subtotal =
        items.fold<double>(0, (sum, item) => sum + item.price * item.quantity);
    final total = subtotal + deliveryFee;
    final textDirection = localization.textDirection;
    final textAlign = textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: ListView(
        children: [
          Text(
            localization.getString('checkoutReviewTitle'),
            style: theme.textTheme.titleLarge,
            textAlign: textAlign,
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImage(item.productId),
              ),
              title: Text(item.productId, textAlign: textAlign),
              subtitle: Text(
                '${item.quantity} × ${item.price.toStringAsFixed(0)} $currency',
                textAlign: textAlign,
              ),
              trailing: Text(
                '${(item.price * item.quantity).toStringAsFixed(0)} $currency',
                textAlign: textDirection == TextDirection.rtl ? TextAlign.left : TextAlign.right,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _ReviewRow(
            label: localization.getString('checkoutSubtotalLabel'),
            value: '${subtotal.toStringAsFixed(0)} $currency',
            textDirection: textDirection,
          ),
          _ReviewRow(
            label: localization.getString('checkoutDeliveryFeeLabel'),
            value: '${deliveryFee.toStringAsFixed(0)} $currency',
            textDirection: textDirection,
          ),
          const Divider(),
          _ReviewRow(
            label: localization.getString('checkoutTotalLabel'),
            value: '${total.toStringAsFixed(0)} $currency',
            isEmphasized: true,
            textDirection: textDirection,
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: 48,
        height: 48,
        errorBuilder: (_, __, ___) => const Icon(Icons.image),
      );
    }
    return Image.asset(
      url,
      fit: BoxFit.cover,
      width: 48,
      height: 48,
      errorBuilder: (_, __, ___) => const Icon(Icons.image),
    );
  }

  void _placeOrder(List<CartItem> items) {
    if (items.isEmpty) return;

    final deliveryFee = AppConfig.deliveryFees['damascus'] ?? 5000;
    final subtotal =
        items.fold<double>(0, (sum, item) => sum + item.price * item.quantity);
    final total = subtotal + deliveryFee;
    final itemCount =
        items.fold<int>(0, (sum, item) => sum + item.quantity);
    final now = DateTime.now();
    final orderNumber =
        '#${(now.millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0')}';

    ref.read(cartProvider.notifier).clearCart();

    final summary = OrderSummary(
      orderNumber: orderNumber,
      itemCount: itemCount,
      total: total,
      placedAt: now,
      deliveryFee: deliveryFee,
    );

    if (mounted) {
      context.go(AppRouter.orderSuccess, extra: summary);
    }
  }
}

class _StepInfo extends StatelessWidget {
  final String title;
  final String description;
  final TextDirection textDirection;

  const _StepInfo({
    required this.title,
    required this.description,
    required this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textAlign = textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left;
    final crossAxisAlignment =
        textDirection == TextDirection.rtl ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(title, style: theme.textTheme.titleLarge, textAlign: textAlign),
          const SizedBox(height: 12),
          Text(description, style: theme.textTheme.bodyLarge, textAlign: textAlign),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isEmphasized;
  final TextDirection textDirection;

  const _ReviewRow({
    required this.label,
    required this.value,
    required this.textDirection,
    this.isEmphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = isEmphasized
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : theme.textTheme.bodyLarge;
    final textAlign = textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left;

    final children = textDirection == TextDirection.rtl
        ? [
            Text(value, style: style, textAlign: textAlign),
            Text(label, style: style, textAlign: textAlign),
          ]
        : [
            Text(label, style: style, textAlign: textAlign),
            Text(value, style: style, textAlign: textAlign),
          ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}
