import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';
import '../theme/app_colors.dart';
import 'primary_header.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.body,
    this.headerBottom,
    this.showHeader = true,
    this.showSearchBar = true,
    this.centerContent = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.maxContentWidth = 960,
    this.floatingActionButton,
    this.searchController,
    this.onSearchSubmitted,
    this.onSearchIconPressed,
    this.onBrandTap,
    this.onGlobeTap,
    this.onCurrencyTap,
    this.onCartTap,
    this.onFavoritesTap,
    this.onProfileTap,
    this.onSettingsTap,
    this.searchHint = 'Search Here',
  });

  final Widget body;
  final Widget? headerBottom;
  final bool showHeader;
  final bool showSearchBar;
  final bool centerContent;
  final EdgeInsetsGeometry contentPadding;
  final double maxContentWidth;
  final Widget? floatingActionButton;

  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchIconPressed;
  final VoidCallback? onBrandTap;
  final VoidCallback? onGlobeTap;
  final VoidCallback? onCurrencyTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onFavoritesTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final String searchHint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: floatingActionButton,
      body: Column(
        children: [
          if (showHeader)
            PrimaryHeader(
              searchController: searchController,
              onSearchSubmitted: onSearchSubmitted,
              onSearchIconPressed: onSearchIconPressed,
              onBrandTap: onBrandTap ?? () => context.go(AppRouter.home),
              onGlobeTap: onGlobeTap ?? () => _showComingSoon(context),
              onCurrencyTap: onCurrencyTap ?? () => _showComingSoon(context),
              onCartTap: onCartTap ?? () => context.go(AppRouter.cart),
              onFavoritesTap: onFavoritesTap ?? () => context.go(AppRouter.favorites),
              onProfileTap: onProfileTap ?? () => context.go(AppRouter.profile),
              onSettingsTap: onSettingsTap ?? () => context.go(AppRouter.settings),
              searchHint: searchHint,
              showSearchBar: showSearchBar,
            ),
          if (headerBottom != null)
            SizedBox(
              width: double.infinity,
              child: headerBottom!,
            ),
          Expanded(
            child: SafeArea(
              top: false,
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (!centerContent) {
      if (contentPadding == EdgeInsets.zero) {
        return body;
      }
      return Padding(
        padding: contentPadding,
        child: body,
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(
          padding: contentPadding,
          child: body,
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Coming soon. Stay tuned!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
