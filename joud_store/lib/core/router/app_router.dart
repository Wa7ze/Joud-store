import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/categories/categories_screen.dart';
import '../../features/products/models/product_filters.dart';
import '../../features/products/product_list_screen.dart';
import '../../features/products/screens/product_details_screen.dart';
import '../../features/products/screens/favorites_screen.dart';
import '../../features/products/services/product_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../features/search/search_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/checkout/checkout_screen.dart';
import '../../features/checkout/order_success_screen.dart';
import '../../features/address/address_book_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/orders/order_detail_screen.dart';
import '../../features/coupons/coupons_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/support/support_screen.dart';
import '../../features/legal/terms_screen.dart';
import '../../features/legal/privacy_screen.dart';
import '../../features/legal/return_policy_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String productList = '/products';
  static const String productDetail = '/product';
  static const String favorites = '/favorites';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String addressBook = '/addresses';
  static const String orders = '/orders';
  static const String orderDetail = '/order';
  static const String coupons = '/coupons';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String support = '/support';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String returnPolicy = '/return-policy';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: categories,
        name: 'categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: productList,
        name: 'productList',
        builder: (context, state) {
          final categoryId = state.uri.queryParameters['categoryId'];
          final subcategory = state.uri.queryParameters['subcategory'];
          return ProductListScreen(
            filters: ProductFilters(categoryId: categoryId, subcategory: subcategory),
          );
        },
      ),
      GoRoute(
        path: '$productDetail/:id',
        name: 'productDetail',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return FutureBuilder(
            future: ProductService().getProduct(productId),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingState();
              }
              if (!snapshot.hasData) {
                return const EmptyState(
                  title: '\u0627\u0644\u0645\u0646\u062a\u062c \u063a\u064a\u0631 \u0645\u062a\u0648\u0641\u0631',
                  icon: Icons.info_outline,
                  message: '\u0639\u0630\u0631\u0627\u064b\u060c \u0644\u0645 \u0646\u0639\u062f \u0646\u0633\u062a\u0637\u064a\u0639 \u0627\u0644\u0639\u062b\u0648\u0631 \u0639\u0644\u0649 \u0647\u0630\u0627 \u0627\u0644\u0645\u0646\u062a\u062c.',
                );
              }
              return ProductDetailsScreen(product: snapshot.data!);
            },
          );
        },
      ),
      GoRoute(
        path: favorites,
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: search,
        name: 'search',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'];
          return SearchScreen(initialQuery: query);
        },
      ),
      GoRoute(
        path: cart,
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: orderSuccess,
        name: 'orderSuccess',
        builder: (context, state) {
          final summary = state.extra is OrderSummary ? state.extra as OrderSummary : null;
          return OrderSuccessScreen(summary: summary);
        },
      ),
      GoRoute(
        path: addressBook,
        name: 'addressBook',
        builder: (context, state) => const AddressBookScreen(),
      ),
      GoRoute(
        path: orders,
        name: 'orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '$orderDetail/:id',
        name: 'orderDetail',
        builder: (context, state) {
          final orderId = state.pathParameters['id']!;
          return OrderDetailScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: coupons,
        name: 'coupons',
        builder: (context, state) => const CouponsScreen(),
      ),
      GoRoute(
        path: notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: support,
        name: 'support',
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: terms,
        name: 'terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: privacy,
        name: 'privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: returnPolicy,
        name: 'returnPolicy',
        builder: (context, state) => const ReturnPolicyScreen(),
      ),
    ],
  );
}
