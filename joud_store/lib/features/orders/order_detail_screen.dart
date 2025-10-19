import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/currency_utils.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/localization/localization_service.dart';
import '../../core/models/order.dart' as core;
import '../../core/widgets/ui_states.dart';
import 'providers/order_history_provider.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;
  
  get currency => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = LocalizationService.instance;
    final ordersAsync = ref.watch(orderHistoryProvider);
    final isRtl = localization.textDirection == TextDirection.rtl;

    return ScreenScaffold(
      title: localization.getString('orderDetails'),
      showBackButton: true,
      currentIndex: 3,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: ordersAsync.when(
        loading: () => const LoadingState(),
        error: (_, __) => const EmptyState(
          title: 'Unable to load order',
          message: 'Please try again in a moment.',
        ),
        data: (orders) {
          core.Order? order;
          for (final candidate in orders) {
            if (candidate.id == orderId) {
              order = candidate;
              break;
            }
          }

          if (order == null) {
            return const EmptyState(
              title: 'Order not found',
              message: 'We could not find the order you are looking for.',
            );
          }

          final textAlign = isRtl ? TextAlign.right : TextAlign.left;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 780),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _DetailTile(
                    title: localization.getString('orderNumber'),
                    value: order.id,
                    leading: Icons.confirmation_number,
                    textAlign: textAlign,
                  ),
                  _DetailTile(
                    title: localization.getString('orderStatus'),
                    value: _statusLabel(order.orderStatus, localization),
                    leading: Icons.local_shipping,
                    textAlign: textAlign,
                  ),
                  _DetailTile(
                    title: localization.getString('orderDate'),
                    value: _formatDateTime(order.createdAt),
                    leading: Icons.calendar_today,
                    textAlign: textAlign,
                  ),
                  _DetailTile(
                    title: localization.getString('paymentMethod'),
                    value:
                        order.paymentMethod == core.PaymentMethod.cashOnDelivery
                        ? localization.getString('cashOnDelivery')
                        : localization.getString('onlinePayment'),
                    leading: Icons.payment,
                    textAlign: textAlign,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localization.getString('deliveryAddress'),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: textAlign,
                  ),
                  const SizedBox(height: 8),
                  _AddressCard(
                    address: order.addressSnapshot,
                    textAlign: textAlign,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localization.getString('items'),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: textAlign,
                  ),
                  const SizedBox(height: 8),
                  ...order.items.map(
                    (item) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.shopping_bag),
                        title: Text(
                          '${localization.getString('product')} ${item.productId}',
                          textAlign: textAlign,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${localization.getString('quantity')}: ${item.quantity}',
                              textAlign: textAlign,
                            ),
                            for (final entry in item.selectedOptions.entries)
                              Text(
                                '${entry.key}: ${entry.value}',
                                textAlign: textAlign,
                              ),
                          ],
                        ),
                        trailing: Text(
                          '${item.lineTotal.toStringAsFixed(0)} $currency',
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  _SummaryRow(
                    label: localization.getString('subtotal'),
                    value: '${order.subtotal.toStringAsFixed(0)} $currency',
                    textAlign: textAlign,
                  ),
                  _SummaryRow(
                    label: localization.getString('deliveryFee'),
                    value: CurrencyUtils.format(order.deliveryFee),
                    textAlign: textAlign,
                  ),
                  if (order.discount > 0)
                    _SummaryRow(
                      label: localization.getString('discount'),
                      value: '-${CurrencyUtils.format(order.discount)}',
                      textAlign: textAlign,
                      accent: Colors.red,
                    ),
                  const Divider(),
                  _SummaryRow(
                    label: localization.getString('total'),
                    value: CurrencyUtils.format(order.total),
                    isBold: true,
                    textAlign: textAlign,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _statusLabel(
    core.OrderStatus status,
    LocalizationService localization,
  ) {
    switch (status) {
      case core.OrderStatus.placed:
        return localization.getString('orderPlaced');
      case core.OrderStatus.confirmed:
        return localization.getString('orderConfirmed');
      case core.OrderStatus.outForDelivery:
        return localization.getString('orderOutForDelivery');
      case core.OrderStatus.delivered:
        return localization.getString('orderDelivered');
      case core.OrderStatus.cancelled:
        return localization.getString('orderCancelled');
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year • $hour:$minute';
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.title,
    required this.value,
    required this.leading,
    required this.textAlign,
  });

  final String title;
  final String value;
  final IconData leading;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(leading),
      title: Text(title, textAlign: textAlign),
      subtitle: Text(value, textAlign: textAlign),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.textAlign});

  final Map<String, dynamic> address;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in address.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '${entry.key}: ${entry.value}',
                  textAlign: textAlign,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.textAlign,
    this.isBold = false,
    this.accent,
  });

  final String label;
  final String value;
  final TextAlign textAlign;
  final bool isBold;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyLarge;
    final textStyle = isBold
        ? baseStyle?.copyWith(fontWeight: FontWeight.bold)
        : baseStyle;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: textStyle, textAlign: textAlign),
          ),
          const SizedBox(width: 12),
          Text(value, style: textStyle?.copyWith(color: accent)),
        ],
      ),
    );
  }
}
