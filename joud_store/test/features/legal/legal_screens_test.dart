import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sy_store/core/localization/localization_service.dart';
import 'package:sy_store/features/legal/privacy_screen.dart';
import 'package:sy_store/features/legal/return_policy_screen.dart';
import 'package:sy_store/features/legal/terms_screen.dart';
import 'package:sy_store/features/legal/widgets/legal_section.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  setUpAll(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
  });

  tearDownAll(() {
    debugDefaultTargetPlatformOverride = null;
  });

  group('Terms Screen Tests', () {
    testWidgets('renders terms screen with all sections', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TermsScreen(),
          ),
        ),
      );

      expect(find.text(LocalizationService.instance.getString('termsOfService')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('termsOfServiceTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('accountTermsTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('purchaseTermsTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('deliveryTermsTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('cancellationTermsTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('privacyTermsTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('changesTermsTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('termsLastUpdated')), findsOneWidget);
    });
  });

  group('Privacy Policy Screen Tests', () {
    testWidgets('renders privacy policy screen with all sections', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PrivacyScreen(),
          ),
        ),
      );

      expect(find.text(LocalizationService.instance.getString('privacyPolicy')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('privacyPolicyTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('dataCollectionTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('dataUsageTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('dataProtectionTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('cookiesTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('thirdPartyTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('privacyLastUpdated')), findsOneWidget);
    });
  });

  group('Return Policy Screen Tests', () {
    testWidgets('renders return policy screen with all sections', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ReturnPolicyScreen(),
          ),
        ),
      );

      expect(find.text(LocalizationService.instance.getString('returnPolicy')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('returnPolicyTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('eligibilityTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('processTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('refundsTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('nonReturnableTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('damagesTitle')), findsOneWidget);
      expect(find.text(LocalizationService.instance.getString('returnLastUpdated')), findsOneWidget);
    });
  });

  group('LegalSection Widget Tests', () {
    testWidgets('renders legal section with title and content', (WidgetTester tester) async {
      const title = 'Test Title';
      const content = 'Test Content';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  LegalSection(
                    title: title,
                    content: content,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(content), findsOneWidget);
    });
  });
}
