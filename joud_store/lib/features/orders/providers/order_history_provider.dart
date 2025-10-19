import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/order.dart' as core;
import '../services/order_history_service.dart';

final orderHistoryProvider =
    FutureProvider<List<core.Order>>((ref) async {
  final service = OrderHistoryService();
  return service.fetchOrders();
});

