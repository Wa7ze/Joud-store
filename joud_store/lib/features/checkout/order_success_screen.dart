import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/ui_states.dart';

class OrderSummary {
  final String orderNumber;
  final int itemCount;
  final double total;
  final DateTime placedAt;
  final double deliveryFee;

  const OrderSummary({
    required this.orderNumber,
    required this.itemCount,
    required this.total,
    required this.placedAt,
    required this.deliveryFee,
  });
}

class OrderSuccessScreen extends StatelessWidget {
  final OrderSummary? summary;

  const OrderSuccessScreen({super.key, this.summary});

  @override
  Widget build(BuildContext context) {
    final localization = LocalizationService.instance;
    final textDirection = localization.textDirection;
    final detailAlign = textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left;

    return ScreenScaffold(
      title: localization.getString('orderSuccessTitle'),
      showBackButton: false,
      currentIndex: 3,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: Align(
        alignment: AlignmentDirectional.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 96,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  localization.getString('orderSuccessHeadline'),
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (summary != null) ...[
                  Align(
                    alignment: textDirection == TextDirection.rtl
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${localization.getString('orderNumber')}: ${summary!.orderNumber}',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: detailAlign,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: textDirection == TextDirection.rtl
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${localization.getString('orderItemsCount')}: ${summary!.itemCount}',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: detailAlign,
                    ),
                  ),
                  Align(
                    alignment: textDirection == TextDirection.rtl
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${localization.getString('orderTotal')}: ${summary!.total.toStringAsFixed(0)} ${localization.getString('currency')}',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: detailAlign,
                    ),
                  ),
                  Align(
                    alignment: textDirection == TextDirection.rtl
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${localization.getString('deliveryFee')}: ${summary!.deliveryFee.toStringAsFixed(0)} ${localization.getString('currency')}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: detailAlign,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: textDirection == TextDirection.rtl
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${localization.getString('orderPlacedAt')}: ${_formatDate(summary!.placedAt)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: detailAlign,
                    ),
                  ),
                ] else ...[
                  Text(
                    localization.getString('orderSuccessFallback'),
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.go(AppRouter.orders),
                      child: Text(localization.getString('viewOrders')),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => context.go(AppRouter.home),
                      child: Text(localization.getString('backToHome')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year - $hour:$minute';
  }
}
