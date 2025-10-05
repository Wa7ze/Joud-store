import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;
  
  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return ScreenScaffold(
      title: localizationService.getString('orderDetails'),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('تفاصيل الطلب'),
            SizedBox(height: 16),
            Text('تفاصيل الطلب ستظهر هنا'),
          ],
        ),
      ),
    );
  }
}
