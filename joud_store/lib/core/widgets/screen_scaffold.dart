import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';
import '../theme/app_colors.dart';
import 'app_shell.dart';

class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold({
    super.key,
    required this.body,
    this.title,
    this.subtitle,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.floatingActionButton,
    this.currentIndex = 0,
    this.showBottomNav = false,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.endFloat,
    this.centerContent = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    this.maxContentWidth = 960,
    this.headerBottom,
    this.showHeader = true,
    this.showSearchBar = true,
    this.searchController,
    this.onSearchSubmitted,
    this.onSearchIconPressed,
    this.onBrandTap,
    this.onGlobeTap,
    this.onCurrencyTap,
    this.onCartTap,
    this.onFavoritesTap,
    this.onProfileTap,
    this.searchHint = 'Search Here',
  });

  final Widget body;
  final String? title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final int currentIndex; // kept for backwards compatibility
  final bool showBottomNav;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final bool centerContent;
  final EdgeInsetsGeometry contentPadding;
  final double maxContentWidth;
  final Widget? headerBottom;
  final bool showHeader;
  final bool showSearchBar;

  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchIconPressed;
  final VoidCallback? onBrandTap;
  final VoidCallback? onGlobeTap;
  final VoidCallback? onCurrencyTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onFavoritesTap;
  final VoidCallback? onProfileTap;
  final String searchHint;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      body: _buildBody(context),
      headerBottom: headerBottom,
      showHeader: showHeader,
      showSearchBar: showSearchBar,
      showHeaderActions: false,
      showBottomNav: showBottomNav,
      bottomNavIndex: currentIndex,
      centerContent: centerContent,
      contentPadding: contentPadding,
      maxContentWidth: maxContentWidth,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      searchController: searchController,
      onSearchSubmitted: onSearchSubmitted ?? (query) => _handleSearch(context, query),
      onSearchIconPressed: onSearchIconPressed,
      onBrandTap: onBrandTap,
      onGlobeTap: onGlobeTap,
      onCurrencyTap: onCurrencyTap,
      onCartTap: onCartTap,
      onFavoritesTap: onFavoritesTap,
      onProfileTap: onProfileTap,
      searchHint: searchHint,
    );
  }

  Widget _buildBody(BuildContext context) {
    final headlineStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        );
    final subtitleStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.onSurfaceVariant,
        );

    if (title == null && !showBackButton && (actions == null || actions!.isEmpty) && subtitle == null) {
      return body;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showBackButton)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
              ),
            if (title != null)
              Expanded(
                child: Text(title!, style: headlineStyle),
              )
            else
              const Spacer(),
            if (actions != null) ...actions!,
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: showBackButton ? 48 : 0),
            child: Text(subtitle!, style: subtitleStyle),
          ),
        ],
        const SizedBox(height: 24),
        body,
      ],
    );
  }

  void _handleSearch(BuildContext context, String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Type what you are looking for.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }
    final encoded = Uri.encodeComponent(trimmed);
    context.go('${AppRouter.search}?q=$encoded');
  }
}
