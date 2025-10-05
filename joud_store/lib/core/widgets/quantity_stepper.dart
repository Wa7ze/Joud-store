import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class QuantityStepper extends StatelessWidget {
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;
  final bool enabled;

  const QuantityStepper({
    Key? key,
    required this.value,
    this.minValue = 1,
    this.maxValue = 999,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canDecrease = value > minValue && enabled;
    final canIncrease = value < maxValue && enabled;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            onPressed: canDecrease ? () => onChanged(value - 1) : null,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 40),
            padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacing2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: Text(
              value.toString(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: enabled ? null : theme.disabledColor,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            onPressed: canIncrease ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _StepperButton({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: onPressed,
      padding: const EdgeInsets.all(DesignTokens.spacing2),
      constraints: const BoxConstraints(
        minHeight: DesignTokens.minTouchTarget,
        minWidth: DesignTokens.minTouchTarget,
      ),
    );
  }
}
