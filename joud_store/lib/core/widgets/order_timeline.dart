import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

enum OrderStatus {
  placed,
  confirmed,
  outForDelivery,
  delivered,
  cancelled
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.placed:
        return Icons.shopping_cart;
      case OrderStatus.confirmed:
        return Icons.check_circle;
      case OrderStatus.outForDelivery:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.home;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }
}

class OrderTimeline extends StatelessWidget {
  final OrderStatus currentStatus;
  final DateTime orderDate;
  final Map<OrderStatus, DateTime>? statusDates;

  const OrderTimeline({
    Key? key,
    required this.currentStatus,
    required this.orderDate,
    this.statusDates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statuses = currentStatus == OrderStatus.cancelled
        ? [OrderStatus.placed, OrderStatus.cancelled]
        : OrderStatus.values.where((s) => s != OrderStatus.cancelled).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: statuses.length,
      itemBuilder: (context, index) {
        final status = statuses[index];
        final isActive = getStatusValue(status) <= getStatusValue(currentStatus);
        final statusDate = status == OrderStatus.placed
            ? orderDate
            : statusDates?[status];

        return IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 64,
                child: Icon(
                  status.icon,
                  color: isActive ? theme.primaryColor : theme.disabledColor,
                ),
              ),
              if (index != statuses.length - 1)
                Container(
                  width: 2,
                  margin: const EdgeInsets.symmetric(
                    vertical: DesignTokens.spacing2,
                  ),
                  color: isActive ? theme.primaryColor : theme.dividerColor,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(DesignTokens.spacing3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isActive ? null : theme.disabledColor,
                          fontWeight: isActive
                              ? DesignTokens.fontWeightBold
                              : null,
                        ),
                      ),
                      if (statusDate != null) ...[
                        const SizedBox(height: DesignTokens.spacing1),
                        Text(
                          _formatDate(statusDate),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.disabledColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int getStatusValue(OrderStatus status) {
    return OrderStatus.values.indexOf(status);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
