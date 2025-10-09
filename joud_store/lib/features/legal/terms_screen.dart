import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/theme/design_tokens.dart';
import 'widgets/legal_section.dart';

class TermsScreen extends ConsumerStatefulWidget {
  const TermsScreen({super.key});

  @override
  ConsumerState<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends ConsumerState<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    final theme = Theme.of(context);
    
    return ScreenScaffold(
      title: localizationService.getString('termsOfService'),
      showBackButton: true,
      currentIndex: 3,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(DesignTokens.spacing4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(
              localizationService.getString('termsOfServiceTitle'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: DesignTokens.fontWeightBold,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing4),
            Text(
              localizationService.getString('termsOfServiceIntro'),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: DesignTokens.spacing4),
            
            // Account Terms
            LegalSection(
              title: localizationService.getString('accountTermsTitle'),
              content: localizationService.getString('accountTermsContent'),
            ),
            
            // Purchase Terms
            LegalSection(
              title: localizationService.getString('purchaseTermsTitle'),
              content: localizationService.getString('purchaseTermsContent'),
            ),
            
            // Delivery Terms
            LegalSection(
              title: localizationService.getString('deliveryTermsTitle'),
              content: localizationService.getString('deliveryTermsContent'),
            ),
            
            // Cancellation Terms
            LegalSection(
              title: localizationService.getString('cancellationTermsTitle'),
              content: localizationService.getString('cancellationTermsContent'),
            ),
            
            // Privacy
            LegalSection(
              title: localizationService.getString('privacyTermsTitle'),
              content: localizationService.getString('privacyTermsContent'),
            ),
            
            // Changes to Terms
            LegalSection(
              title: localizationService.getString('changesTermsTitle'),
              content: localizationService.getString('changesTermsContent'),
            ),
            
              const SizedBox(height: DesignTokens.spacing4),
              Text(
                localizationService.getString('termsLastUpdated'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );  
  }
}
