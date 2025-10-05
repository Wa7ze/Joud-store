import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;

    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: _getButtonStyle(theme),
          child: _buildButtonContent(),
        );
      case ButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: _getButtonStyle(theme),
          child: _buildButtonContent(),
        );
      case ButtonVariant.ghost:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: _getButtonStyle(theme),
          child: _buildButtonContent(),
        );
    }
  }

  Widget _buildButtonContent() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size == ButtonSize.small ? DesignTokens.spacing2 : DesignTokens.spacing3,
        vertical: size == ButtonSize.small ? DesignTokens.spacing1 : DesignTokens.spacing2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: size == ButtonSize.small ? 16 : 20),
            SizedBox(width: DesignTokens.spacing2),
          ],
          if (isLoading)
            SizedBox(
              width: size == ButtonSize.small ? 16 : 20,
              height: size == ButtonSize.small ? 16 : 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  variant == ButtonVariant.primary ? Colors.white : DesignTokens.primaryColor,
                ),
              ),
            )
          else
            Text(
              text,
              style: TextStyle(
                fontSize: size == ButtonSize.small ? 14 : 16,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
        ],
      ),
    );
  }

  ButtonStyle _getButtonStyle(ThemeData theme) {
    final minHeight = size == ButtonSize.small
        ? DesignTokens.minTouchTarget - 16
        : DesignTokens.minTouchTarget;

    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(Size(0, minHeight)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
      ),
    );
  }
}

enum ButtonVariant {
  primary,
  secondary,
  ghost,
}

enum ButtonSize {
  small,
  medium,
}
