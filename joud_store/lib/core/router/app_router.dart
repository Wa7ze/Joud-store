import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/categories/categories_screen.dart';
import '../../features/products/product_list_screen.dart';
import '../../features/products/product_detail_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/checkout/checkout_screen.dart';
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
  static const String search = '/search';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
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
      // Splash
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Auth
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
      
      // Main App
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Categories
      GoRoute(
        path: categories,
        name: 'categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      
      // Products
      GoRoute(
        path: productList,
        name: 'productList',
        builder: (context, state) {
          final categoryId = state.uri.queryParameters['categoryId'];
          return ProductListScreen(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: '$productDetail/:id',
        name: 'productDetail',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
      
      // Search
      GoRoute(
        path: search,
        name: 'search',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'];
          return SearchScreen(initialQuery: query);
        },
      ),
      
      // Cart & Checkout
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
      
      // Address Management
      GoRoute(
        path: addressBook,
        name: 'addressBook',
        builder: (context, state) => const AddressBookScreen(),
      ),
      
      // Orders
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
      
      // Coupons
      GoRoute(
        path: coupons,
        name: 'coupons',
        builder: (context, state) => const CouponsScreen(),
      ),
      
      // Notifications
      GoRoute(
        path: notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      
      // Settings & Profile
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
      
      // Support
      GoRoute(
        path: support,
        name: 'support',
        builder: (context, state) => const SupportScreen(),
      ),
      
      // Legal Pages
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
