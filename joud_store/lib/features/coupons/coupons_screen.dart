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
      currentIndex: 4,
      body: const EmptyState(
        title: 'Ù„Ø§ ØªÙˆØ¬Ø¯ ÙƒÙˆØ¨ÙˆÙ†Ø§Øª Ø­Ø§Ù„ÙŠØ§Ù‹',
        message: 'Ø³Ù†Ø¶ÙŠÙ Ø¹Ø±ÙˆØ¶Ø§Ù‹ Ø¬Ø¯ÙŠØ¯Ø© Ù‚Ø±ÙŠØ¨Ø§Ù‹. ØªØ§Ø¨Ø¹ Ø§Ù„Ø¥Ø´Ø¹Ø§Ø±Ø§Øª Ù„Ù…Ø¹Ø±ÙØ© Ø£Ø­Ø¯Ø« Ø§Ù„ØªØ®ÙÙŠØ¶Ø§Øª.',
        icon: Icons.local_offer_outlined,
      ),
    );
  }
}


