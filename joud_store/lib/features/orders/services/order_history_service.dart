import 'dart:async';
import '../../../core/models/order.dart' as core;

class OrderHistoryService {
  Future<List<core.Order>> fetchOrders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockOrders;
  }

  List<core.Order> get _mockOrders {
    final now = DateTime.now();
    return [
      core.Order(
        id: '#458210',
        userId: 'user-1',
        items: [
          core.CartItem(
            productId: '1023',
            selectedOptions: {'المقاس': 'M', 'اللون': 'أسود'},
            quantity: 1,
            unitPrice: 380000,
            lineTotal: 380000,
          ),
          core.CartItem(
            productId: '1077',
            selectedOptions: {'المقاس': '42', 'اللون': 'أزرق'},
            quantity: 1,
            unitPrice: 420000,
            lineTotal: 420000,
          ),
        ],
        subtotal: 800000,
        deliveryFee: 5000,
        discount: 0,
        total: 805000,
        paymentMethod: core.PaymentMethod.cashOnDelivery,
        paymentStatus: core.PaymentStatus.unpaid,
        orderStatus: core.OrderStatus.outForDelivery,
        addressSnapshot: {
          'المدينة': 'دمشق',
          'المنطقة': 'المزة اوتوستراد',
          'الهاتف': '+963 999 123 456',
        },
        createdAt: now.subtract(const Duration(days: 2, hours: 4)),
        couponCode: null,
      ),
      core.Order(
        id: '#457901',
        userId: 'user-1',
        items: [
          core.CartItem(
            productId: '1180',
            selectedOptions: {'المقاس': 'L', 'اللون': 'بيج'},
            quantity: 1,
            unitPrice: 540000,
            lineTotal: 540000,
          ),
        ],
        subtotal: 540000,
        deliveryFee: 5000,
        discount: 40000,
        total: 505000,
        paymentMethod: core.PaymentMethod.cashOnDelivery,
        paymentStatus: core.PaymentStatus.paid,
        orderStatus: core.OrderStatus.delivered,
        addressSnapshot: {
          'المدينة': 'دمشق',
          'المنطقة': 'البرامكة',
          'الهاتف': '+963 999 123 456',
        },
        createdAt: now.subtract(const Duration(days: 12)),
        couponCode: 'RAMADAN10',
      ),
      core.Order(
        id: '#455332',
        userId: 'user-1',
        items: [
          core.CartItem(
            productId: '990',
            selectedOptions: {'المقاس': 'S', 'اللون': 'وردي'},
            quantity: 2,
            unitPrice: 220000,
            lineTotal: 440000,
          ),
        ],
        subtotal: 440000,
        deliveryFee: 8000,
        discount: 0,
        total: 448000,
        paymentMethod: core.PaymentMethod.cashOnDelivery,
        paymentStatus: core.PaymentStatus.paid,
        orderStatus: core.OrderStatus.cancelled,
        addressSnapshot: {
          'المدينة': 'حمص',
          'المنطقة': 'حي الوعر',
          'الهاتف': '+963 988 111 222',
        },
        createdAt: now.subtract(const Duration(days: 28)),
        couponCode: null,
      ),
    ];
  }
}

