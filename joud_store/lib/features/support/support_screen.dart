import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/theme/design_tokens.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  // Mock data
  static const String whatsappNumber = '+963912345678';
  static const String phoneNumber = '+963912345678';
  static const String email = 'support@syriastore.com';
  static const String businessHours = '9:00 AM - 6:00 PM';
  static const String workingDays = 'Sunday - Thursday';

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    final theme = Theme.of(context);
    
    return ScreenScaffold(
      title: localizationService.getString('customerSupport'),
      body: ListView(
        padding: const EdgeInsets.all(DesignTokens.spacing4),
        children: [
          // Business Hours Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(DesignTokens.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(width: DesignTokens.spacing2),
                      Text(
                        localizationService.getString('businessHours'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: DesignTokens.fontWeightBold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignTokens.spacing3),
                  Text(
                    businessHours,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: DesignTokens.spacing2),
                  Text(
                    workingDays,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),

          // Contact Options
          Card(
            child: Column(
              children: [
                // WhatsApp
                ListTile(
                  leading: Icon(
                    Icons.message,
                    color: theme.primaryColor,
                    size: 28,
                  ),
                  title: Text(localizationService.getString('whatsapp')),
                  subtitle: const Text(whatsappNumber),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _openWhatsApp,
                ),
                const Divider(),

                // Phone
                ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: theme.primaryColor,
                    size: 28,
                  ),
                  title: Text(localizationService.getString('call')),
                  subtitle: const Text(phoneNumber),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _makeCall,
                ),
                const Divider(),

                // Email
                ListTile(
                  leading: Icon(
                    Icons.email,
                    color: theme.primaryColor,
                    size: 28,
                  ),
                  title: Text(localizationService.getString('email')),
                  subtitle: const Text(email),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _sendEmail,
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),

          // FAQ Section
          Text(
            localizationService.getString('faq'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: DesignTokens.fontWeightBold,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing3),
          _FAQItem(
            question: localizationService.getString('faqDeliveryTime'),
            answer: localizationService.getString('faqDeliveryTimeAnswer'),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          _FAQItem(
            question: localizationService.getString('faqPaymentMethods'),
            answer: localizationService.getString('faqPaymentMethodsAnswer'),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          _FAQItem(
            question: localizationService.getString('faqReturnPolicy'),
            answer: localizationService.getString('faqReturnPolicyAnswer'),
          ),
        ],
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    final url = Uri.parse('https://wa.me/$whatsappNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _makeCall() async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _sendEmail() async {
    final url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            widget.question,
            style: const TextStyle(
              fontWeight: DesignTokens.fontWeightMedium,
            ),
          ),
          trailing: Icon(
            _isExpanded ? Icons.remove : Icons.add,
          ),
          onExpansionChanged: (value) {
            setState(() {
              _isExpanded = value;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                DesignTokens.spacing4,
                0,
                DesignTokens.spacing4,
                DesignTokens.spacing4,
              ),
              child: Text(widget.answer),
            ),
          ],
        ),
      ),
    );
  }
}
