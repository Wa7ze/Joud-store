import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/localization_service.dart';
import '../../core/router/app_router.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/widgets/page_container.dart';
import '../../core/widgets/screen_scaffold.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/models/order.dart' as core;
import 'providers/order_history_provider.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = LocalizationService.instance;
    final ordersAsync = ref.watch(orderHistoryProvider);

    return ScreenScaffold(
      title: localization.getString('orders'),
      showBackButton: true,
      currentIndex: 3,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: ordersAsync.when(
        loading: () => const LoadingState(),
        error: (_, __) => PageContainer(
          child: EmptyState(
            title: localization.getString('ordersLoadErrorTitle'),
            message: localization.getString('ordersLoadErrorMessage'),
            icon: Icons.warning_amber_rounded,
          ),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return PageContainer(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: EmptyState(
                title: localization.getString('noOrders'),
                message: localization.getString('noOrdersMessage'),
                icon: Icons.shopping_bag_outlined,
              ),
            );
          }

          return PageContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ListView.separated(
              itemBuilder: (context, index) => _OrderCard(
                order: orders[index],
                localization: localization,
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: orders.length,
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.localization,
  });

  final core.Order order;
  final LocalizationService localization;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textAlign = localization.textDirection == TextDirection.rtl
        ? TextAlign.right
        : TextAlign.left;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => context.push('${AppRouter.orderDetail}/${order.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order.id, style: theme.textTheme.titleMedium),
                  _StatusChip(status: order.orderStatus, localization: localization),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _formatDate(order.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.shopping_bag,
                      size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '${localization.getString('orderItemsCount')}: ${order.items.length}',
                    textAlign: textAlign,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.attach_money,
                      size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '${CurrencyUtils.format(order.total)} (${order.paymentStatus == core.PaymentStatus.paid ? localization.getString('orderPaid') : localization.getString('orderPendingPayment')})',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
    required this.localization,
  });

  final core.OrderStatus status;
  final LocalizationService localization;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      core.OrderStatus.placed =>
        (localization.getString('orderPlaced'), colors.primary),
      core.OrderStatus.confirmed =>
        (localization.getString('orderConfirmed'), colors.secondary),
      core.OrderStatus.outForDelivery =>
        (localization.getString('orderOutForDelivery'), colors.tertiary),
      core.OrderStatus.delivered =>
        (localization.getString('orderDelivered'), Colors.green),
      core.OrderStatus.cancelled =>
        (localization.getString('orderCancelled'), Colors.redAccent),
    };

    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }
}
