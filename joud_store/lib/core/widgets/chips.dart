import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? color;

  const AppChip({
    Key? key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? theme.primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCircular),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacing3,
            vertical: DesignTokens.spacing2,
          ),
          decoration: BoxDecoration(
            color: selected
                ? chipColor.withOpacity(0.1)
                : theme.dividerColor.withOpacity(0.1),
            border: Border.all(
              color: selected ? chipColor : theme.dividerColor,
            ),
            borderRadius: BorderRadius.circular(DesignTokens.radiusCircular),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: selected ? chipColor : theme.disabledColor,
                ),
                const SizedBox(width: DesignTokens.spacing1),
              ],
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: selected ? chipColor : null,
                  fontWeight: selected ? DesignTokens.fontWeightMedium : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final double? size;
  final EdgeInsets? padding;
  final bool outlined;

  const Badge({
    Key? key,
    required this.text,
    this.color,
    this.textColor,
    this.size,
    this.padding,
    this.outlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = color ?? theme.primaryColor;

    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacing2,
            vertical: DesignTokens.spacing1,
          ),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : badgeColor,
        border: outlined ? Border.all(color: badgeColor) : null,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
      ),
      child: Text(
        text,
        style: (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
          color: outlined
              ? badgeColor
              : (textColor ?? theme.colorScheme.onPrimary),
          fontSize: size,
          fontWeight: DesignTokens.fontWeightMedium,
        ),
      ),
    );
  }
}
