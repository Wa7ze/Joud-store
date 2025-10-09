import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/models/order.dart' as core;
import 'providers/order_history_provider.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizationService = LocalizationService.instance;
    final ordersAsync = ref.watch(orderHistoryProvider);

    return ScreenScaffold(
      title: localizationService.getString('orderDetails'),
      showBackButton: true,
      currentIndex: 4,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: ordersAsync.when(
        loading: () => const LoadingState(),
        error: (_, __) => const EmptyState(
          title: 'تعذر تحميل تفاصيل الطلب',
          message: 'يرجى المحاولة لاحقاً.',
        ),
        data: (orders) {
          core.Order? order;
          for (final item in orders) {
            if (item.id == orderId) {
              order = item;
              break;
            }
          }

          if (order == null) {1;};final orderData = order!;final currency = AppConfig.defaultCurrency;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 780),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _DetailTile(
                    title: 'رقم الطلب',
                    value: orderData.id,
                    leading: Icons.confirmation_number,
                  ),
                  _DetailTile(
                    title: 'الحالة',
                    value: _statusLabel(orderData.orderStatus),
                    leading: Icons.local_shipping,
                  ),
                  _DetailTile(
                    title: 'التاريخ',
                    value: _formatDateTime(orderData.createdAt),
                    leading: Icons.calendar_today,
                  ),
                  _DetailTile(
                    title: 'طريقة الدفع',
                    value: orderData.paymentMethod == core.PaymentMethod.cashOnDelivery
                        ? 'الدفع عند الاستلام'
                        : 'بطاقة مصرفية',
                    leading: Icons.payment,
                  ),
                  const SizedBox(height: 16),
                  Text('عنوان التوصيل', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _AddressCard(address: orderData.addressSnapshot),
                  const SizedBox(height: 16),
                  Text('المنتجات', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...orderData.items.map(
                    (item) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.shopping_bag),
                        title: Text('منتج ${item.productId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('الكمية: ${item.quantity}'),
                            for (final entry in item.selectedOptions.entries)
                              Text('${entry.key}: ${entry.value}'),
                          ],
                        ),
                        trailing: Text('${item.lineTotal.toStringAsFixed(0)} $currency'),
                      ),
                    ),
                  ),
                  const Divider(),
                  _SummaryRow(
                    label: 'المجموع الفرعي',
                    value: '${orderData.subtotal.toStringAsFixed(0)} $currency',
                  ),
                  _SummaryRow(
                    label: 'رسوم التوصيل',
                    value: '${orderData.deliveryFee.toStringAsFixed(0)} $currency',
                  ),
                  if (orderData.discount > 0)
                    _SummaryRow(
                      label: 'الخصم',
                      value: '-${orderData.discount.toStringAsFixed(0)} $currency',
                      accent: Colors.red,
                    ),
                  const Divider(),
                  _SummaryRow(
                    label: 'الإجمالي',
                    value: '${orderData.total.toStringAsFixed(0)} $currency',
                    isBold: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _statusLabel(core.OrderStatus status) {
    return switch (status) {
      core.OrderStatus.placed => 'تم الاستلام',
      core.OrderStatus.confirmed => 'قيد التحضير',
      core.OrderStatus.outForDelivery => 'قيد التوصيل',
      core.OrderStatus.delivered => 'تم التسليم',
      core.OrderStatus.cancelled => 'أُلغي',
    };
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
  final String title;
  final String value;
  final IconData leading;

  const _DetailTile({
    required this.title,
    required this.value,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(leading),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final Map<String, dynamic> address;

  const _AddressCard({required this.address});

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
                child: Text('${entry.key}: ${entry.value}'),
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? accent;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final style = isBold
        ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style?.copyWith(color: accent)),
        ],
      ),
    );
  }
}

