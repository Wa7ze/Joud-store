import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/design_tokens.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;

  const AppTextField({
    Key? key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.textDirection,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
      borderSide: BorderSide(
        color: theme.dividerColor,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: DesignTokens.fontWeightMedium,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing2),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          onChanged: onChanged,
          validator: validator,
          inputFormatters: inputFormatters,
          textDirection: textDirection,
          maxLines: maxLines,
          minLines: minLines,
          autofocus: autofocus,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefix,
            suffixIcon: suffix,
            filled: true,
            fillColor: enabled 
                ? theme.cardColor 
                : theme.disabledColor.withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing4,
              vertical: DesignTokens.spacing3,
            ),
            border: defaultBorder,
            enabledBorder: defaultBorder,
            focusedBorder: defaultBorder.copyWith(
              borderSide: BorderSide(
                color: theme.primaryColor,
                width: 2,
              ),
            ),
            errorBorder: defaultBorder.copyWith(
              borderSide: BorderSide(
                color: theme.colorScheme.error,
              ),
            ),
            focusedErrorBorder: defaultBorder.copyWith(
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
