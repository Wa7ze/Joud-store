import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sy_store/core/localization/localization_service.dart';
import 'package:sy_store/core/widgets/ui_states.dart';
import 'package:sy_store/core/theme/design_tokens.dart';
import 'package:sy_store/features/legal/widgets/legal_section.dart';

class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    final theme = Theme.of(context);
    
    return ScreenScaffold(
      title: localizationService.getString('privacyPolicy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizationService.getString('privacyPolicyTitle'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: DesignTokens.fontWeightBold,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              localizationService.getString('privacyPolicyIntro'),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: DesignTokens.spacing4),
            
            // Data Collection
            LegalSection(
              title: localizationService.getString('dataCollectionTitle'),
              content: localizationService.getString('dataCollectionContent'),
            ),
            
            // Data Usage
            LegalSection(
              title: localizationService.getString('dataUsageTitle'),
              content: localizationService.getString('dataUsageContent'),
            ),
            
            // Data Protection
            LegalSection(
              title: localizationService.getString('dataProtectionTitle'),
              content: localizationService.getString('dataProtectionContent'),
            ),
            
            // Cookies
            LegalSection(
              title: localizationService.getString('cookiesTitle'),
              content: localizationService.getString('cookiesContent'),
            ),
            
            // Third Parties
            LegalSection(
              title: localizationService.getString('thirdPartyTitle'),
              content: localizationService.getString('thirdPartyContent'),
            ),
            
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              localizationService.getString('privacyLastUpdated'),
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
