import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';

class CouponsScreen extends ConsumerStatefulWidget {
  const CouponsScreen({super.key});

  @override
  ConsumerState<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends ConsumerState<CouponsScreen> {
  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return ScreenScaffold(
      title: localizationService.getString('coupons'),
      body: const EmptyState(
        title: 'لا توجد كوبونات',
        message: 'ستظهر الكوبونات المتاحة هنا',
        icon: Icons.local_offer_outlined,
      ),
    );
  }
}
