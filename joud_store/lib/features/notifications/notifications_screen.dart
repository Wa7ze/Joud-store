import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizationService = LocalizationService.instance;

    return ScreenScaffold(
      title: localizationService.getString('notifications'),
      showBackButton: false,
      currentIndex: 2,
      body: const EmptyState(
        title: 'لا توجد إشعارات حالياً',
        message: 'سنخبرك بالعروض وتحديثات الطلبات فور توفرها.',
        icon: Icons.notifications_outlined,
      ),
    );
  }
}
