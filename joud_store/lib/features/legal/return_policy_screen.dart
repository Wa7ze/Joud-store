import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sy_store/core/localization/localization_service.dart';
import 'package:sy_store/core/widgets/ui_states.dart';
import 'package:sy_store/core/theme/design_tokens.dart';
import 'package:sy_store/features/legal/widgets/legal_section.dart';

class ReturnPolicyScreen extends ConsumerStatefulWidget {
  const ReturnPolicyScreen({super.key});

  @override
  ConsumerState<ReturnPolicyScreen> createState() => _ReturnPolicyScreenState();
}

class _ReturnPolicyScreenState extends ConsumerState<ReturnPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    final theme = Theme.of(context);
    
    return ScreenScaffold(
      title: localizationService.getString('returnPolicy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizationService.getString('returnPolicyTitle'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: DesignTokens.fontWeightBold,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              localizationService.getString('returnPolicyIntro'),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: DesignTokens.spacing4),
            
            // Return Eligibility
            LegalSection(
              title: localizationService.getString('eligibilityTitle'),
              content: localizationService.getString('eligibilityContent'),
            ),
            
            // Return Process
            LegalSection(
              title: localizationService.getString('processTitle'),
              content: localizationService.getString('processContent'),
            ),
            
            // Refunds
            LegalSection(
              title: localizationService.getString('refundsTitle'),
              content: localizationService.getString('refundsContent'),
            ),
            
            // Non-Returnable Items
            LegalSection(
              title: localizationService.getString('nonReturnableTitle'),
              content: localizationService.getString('nonReturnableContent'),
            ),
            
            // Damaged Items
            LegalSection(
              title: localizationService.getString('damagesTitle'),
              content: localizationService.getString('damagesContent'),
            ),
            
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              localizationService.getString('returnLastUpdated'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
