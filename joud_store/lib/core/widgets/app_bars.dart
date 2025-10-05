import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;

  const AppAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.leading,
    this.bottom,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null),
      actions: actions,
      bottom: bottom,
      backgroundColor: backgroundColor,
    );
  }
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final String? hint;
  final List<Widget>? actions;

  const SearchAppBar({
    Key? key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hint,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      titleSpacing: 0,
      title: Container(
        height: 40,
        margin: EdgeInsets.only(
          left: DesignTokens.spacing3,
          right: actions != null ? 0 : DesignTokens.spacing3,
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: (_) => onSubmitted?.call(),
          decoration: InputDecoration(
            hintText: hint ?? 'Search...',
            prefixIcon: const Icon(Icons.search, size: 20),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacing3,
              vertical: 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusCircular),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
          ),
        ),
      ),
      actions: actions,
    );
  }
}
