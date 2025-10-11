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
    this.showHeaderActions = false,
    this.centerContent = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
    this.searchHint = 'Search Here',
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
  final String searchHint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: showBottomNav ? _BottomNavigationBar(currentIndex: bottomNavIndex) : null,
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
              showActionIcons: showHeaderActions,
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

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final safeIndex = currentIndex.clamp(0, 4);

    return NavigationBar(
      height: 70,
      selectedIndex: safeIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category),
          label: 'Categories',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border),
          selectedIcon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onDestinationSelected: (index) {
        if (index == safeIndex) return;
        switch (index) {
          case 0:
            context.go(AppRouter.home);
            break;
          case 1:
            context.go(AppRouter.categories);
            break;
          case 2:
            context.go(AppRouter.favorites);
            break;
          case 3:
            context.go(AppRouter.cart);
            break;
          case 4:
            context.go(AppRouter.profile);
            break;
        }
      },
    );
  }
}
