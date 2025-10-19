import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../localization/localization_service.dart';
import '../router/app_router.dart';
import 'primary_header.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.body,
    this.headerBottom,
    this.showHeader = true,
    this.showSearchBar = true,
    this.showHeaderActions = false,
    this.centerContent = true,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    this.maxContentWidth = 960,
    this.floatingActionButton,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.endFloat,
    this.showBottomNav = true,
    this.bottomNavIndex = 0,
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
    this.searchHint,
  });

  final Widget body;
  final Widget? headerBottom;
  final bool showHeader;
  final bool showSearchBar;
  final bool showHeaderActions;
  final bool centerContent;
  final EdgeInsetsGeometry contentPadding;
  final double maxContentWidth;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final bool showBottomNav;
  final int bottomNavIndex;

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
  final String? searchHint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = LocalizationService.instance;
    final effectiveSearchHint =
        searchHint ?? localization.getString('searchPlaceholder');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: showBottomNav
          ? _BottomNavigationBar(currentIndex: bottomNavIndex)
          : null,
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
              onFavoritesTap:
                  onFavoritesTap ?? () => context.go(AppRouter.favorites),
              onProfileTap: onProfileTap ?? () => context.go(AppRouter.profile),
              onSettingsTap:
                  onSettingsTap ?? () => context.go(AppRouter.settings),
              searchHint: effectiveSearchHint,
              showSearchBar: showSearchBar,
              showActionIcons: showHeaderActions,
            ),
          if (headerBottom != null)
            SizedBox(width: double.infinity, child: headerBottom!),
          Expanded(child: SafeArea(top: false, child: _buildBody())),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (!centerContent) {
      if (contentPadding == EdgeInsets.zero) {
        return body;
      }
      return Padding(padding: contentPadding, child: body);
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(padding: contentPadding, child: body),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    final localization = LocalizationService.instance;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(localization.getString('comingSoonGeneric')),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final localization = LocalizationService.instance;
    final destinations = <NavigationDestination>[
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: localization.getString('home'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.favorite_border),
        selectedIcon: const Icon(Icons.favorite),
        label: localization.getString('favorites'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.shopping_cart_outlined),
        selectedIcon: const Icon(Icons.shopping_cart),
        label: localization.getString('cart'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: localization.getString('profile'),
      ),
    ];
    final safeIndex = currentIndex.clamp(0, destinations.length - 1).toInt();

    return NavigationBar(
      height: 70,
      selectedIndex: safeIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: destinations,
      onDestinationSelected: (index) {
        if (index == safeIndex && index != 0) return;
        switch (index) {
          case 0:
            context.go(AppRouter.home);
            break;
          case 1:
            context.go(AppRouter.favorites);
            break;
          case 2:
            context.go(AppRouter.cart);
            break;
          case 3:
            context.go(AppRouter.profile);
            break;
        }
      },
    );
  }
}
