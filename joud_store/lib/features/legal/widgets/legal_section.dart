import 'package:flutter/material.dart';
import 'package:sy_store/core/theme/design_tokens.dart';

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
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: DesignTokens.spacing4,
            bottom: DesignTokens.spacing2,
          ),
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: DesignTokens.fontWeightMedium,
            ),
          ),
        ),
        Text(
          content,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
