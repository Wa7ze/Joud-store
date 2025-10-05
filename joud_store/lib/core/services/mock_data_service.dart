import 'dart:math';
import '../models/user.dart';
import '../models/address.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/coupon.dart';
import '../models/notification.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  final _random = Random();

  // Syria Governorates and Cities
  final Map<String, List<String>> syriaLocations = {
    'Damascus': ['Damascus City', 'Jaramana', 'Douma'],
    'Aleppo': ['Aleppo City', 'Al-Bab', 'Azaz'],
    'Homs': ['Homs City', 'Talkalakh', 'Al-Rastan'],
    'Latakia': ['Latakia City', 'Jabla', 'Al-Qardaha'],
    'Hama': ['Hama City', 'Salamiyah', 'Masyaf'],
  };

  // Mock Categories
  final List<Category> categories = [
    Category(
      id: 'cat1',
      name: 'Electronics',
      image: 'assets/images/categories/electronics.jpg',
      order: 1,
    ),
    Category(
      id: 'cat2',
      name: 'Fashion',
      image: 'assets/images/categories/fashion.jpg',
      order: 2,
    ),
    Category(
      id: 'cat3',
      name: 'Home',
      image: 'assets/images/categories/home.jpg',
      order: 3,
    ),
  ];

  // Mock Products
  List<Product> generateProducts() {
    return [
      Product(
        id: 'prod1',
        title: 'Smartphone XYZ',
        description: 'Latest smartphone with amazing features',
        images: ['assets/images/products/phone1.jpg'],
        price: 1200000,
        compareAtPrice: 1500000,
        stock: 10,
        sku: 'PHN001',
        categoryIds: ['cat1'],
        attributes: {
          'color': ProductAttribute(
            name: 'Color',
            values: ['Black', 'White', 'Gold'],
          ),
          'storage': ProductAttribute(
            name: 'Storage',
            values: ['64GB', '128GB'],
          ),
        },
        rating: 4.5,
        reviewCount: 12,
      ),
      // Add more mock products...
    ];
  }

  // Mock Delivery Fees
  final Map<String, double> deliveryFees = {
    'Damascus': 15000,
    'Aleppo': 20000,
    'Homs': 18000,
    'Latakia': 18000,
    'Hama': 18000,
  };

  // Mock Coupons
  final List<Coupon> coupons = [
    Coupon(
      code: 'WELCOME10',
      type: CouponType.percentage,
      value: 10,
      minSubtotal: 500000,
      expiry: DateTime.now().add(const Duration(days: 30)),
      usageLimit: 1000,
    ),
    Coupon(
      code: 'FIXED50K',
      type: CouponType.fixed,
      value: 50000,
      minSubtotal: 1000000,
      expiry: DateTime.now().add(const Duration(days: 15)),
      usageLimit: 500,
    ),
  ];

  // Helper Methods
  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  T getRandomElement<T>(List<T> list) {
    return list[_random.nextInt(list.length)];
  }

  double getDeliveryFee(String governorate) {
    return deliveryFees[governorate] ?? 20000;
  }

  // Mock Data Generation Methods
  Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return categories;
  }

  Future<List<Product>> getProducts({
    String? categoryId,
    String? query,
    int page = 1,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    var products = generateProducts();
    
    if (categoryId != null) {
      products = products.where((p) => p.categoryIds.contains(categoryId)).toList();
    }
    
    if (query != null && query.isNotEmpty) {
      products = products
          .where((p) =>
              p.title.toLowerCase().contains(query.toLowerCase()) ||
              p.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    
    final startIndex = (page - 1) * limit;
    return products.skip(startIndex).take(limit).toList();
  }

  Future<Product?> getProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return generateProducts().firstWhere((p) => p.id == id);
  }

  Future<List<String>> getGovernoratesList() async {
    return syriaLocations.keys.toList();
  }

  Future<List<String>> getCitiesByGovernorate(String governorate) async {
    return syriaLocations[governorate] ?? [];
  }

  Future<Coupon?> validateCoupon(String code) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return coupons.firstWhere(
        (c) => c.code == code && c.isValid,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<Notification>> getNotifications({
    required String userId,
    bool unreadOnly = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final notifications = [
      Notification(
        id: 'notif1',
        title: 'Order Confirmed',
        body: 'Your order #12345 has been confirmed',
        type: NotificationType.order,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        data: {'orderId': '12345'},
      ),
      // Add more notifications...
    ];

    if (unreadOnly) {
      return notifications.where((n) => !n.read).toList();
    }
    return notifications;
  }
}
