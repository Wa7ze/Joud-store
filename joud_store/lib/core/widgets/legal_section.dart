import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class LegalSection extends StatelessWidget {
  final String title;
  final String content;

  const LegalSection({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: DesignTokens.fontWeightBold,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            content,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
