import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/localization/localization_service.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/models/order.dart' as core;
import 'providers/order_history_provider.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizationService = LocalizationService.instance;
    final ordersAsync = ref.watch(orderHistoryProvider);

    return ScreenScaffold(
      title: localizationService.getString('orders'),
      showBackButton: true,
      currentIndex: 4,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: ordersAsync.when(
        loading: () => const LoadingState(),
        error: (_, __) => const EmptyState(
          title: 'تعذر تحميل الطلبات',
          message: 'حاول مرةً أخرى لاحقاً.',
          icon: Icons.warning_amber_rounded,
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return const EmptyState(
              title: 'لا توجد طلبات بعد',
              message: 'ابدأ التسوق لإضافة أول طلب لك.',
              icon: Icons.shopping_bag_outlined,
            );
          }

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 780),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return _OrderCard(order: order);
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: orders.length,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final core.Order order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = AppConfig.defaultCurrency;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.push('${AppRouter.orderDetail}/${order.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order.id, style: theme.textTheme.titleMedium),
                  _StatusChip(status: order.orderStatus),
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
                  Icon(Icons.shopping_bag, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('عدد المنتجات: ${order.items.length}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.attach_money, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '${order.total.toStringAsFixed(0)} $currency (${order.paymentStatus == core.PaymentStatus.paid ? 'مدفوع' : 'قيد الدفع'})',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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
  final core.OrderStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      core.OrderStatus.placed => ('تم الاستلام', colors.primary),
      core.OrderStatus.confirmed => ('قيد التحضير', colors.secondary),
      core.OrderStatus.outForDelivery => ('قيد التوصيل', colors.tertiary),
      core.OrderStatus.delivered => ('تم التسليم', Colors.green),
      core.OrderStatus.cancelled => ('أُلغي', Colors.redAccent),
    };

    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }
}
