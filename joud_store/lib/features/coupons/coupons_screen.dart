import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';

class CouponsScreen extends ConsumerWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizationService = LocalizationService.instance;

    return ScreenScaffold(
      title: localizationService.getString('coupons'),
      showBackButton: true,
      currentIndex: 3,
      body: const EmptyState(
        title: 'لا توجد كوبونات حالياً',
        message:
            'سنضيف عروضاً جديدة قريباً. تابع الإشعارات لمعرفة أحدث التخفيضات.',
        icon: Icons.local_offer_outlined,
      ),
    );
  }
}
