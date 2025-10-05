class CartItem {
  final String productId;
  final Map<String, String> selectedOptions;
  final int quantity;
  final double unitPrice;
  final double lineTotal;

  CartItem({
    required this.productId,
    required this.selectedOptions,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] as String,
      selectedOptions: Map<String, String>.from(json['selectedOptions'] as Map),
      quantity: json['quantity'] as int,
      unitPrice: json['unitPrice'] as double,
      lineTotal: json['lineTotal'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'selectedOptions': selectedOptions,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'lineTotal': lineTotal,
    };
  }

  CartItem copyWith({
    String? productId,
    Map<String, String>? selectedOptions,
    int? quantity,
    double? unitPrice,
    double? lineTotal,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
    );
  }
}

enum PaymentMethod {
  cashOnDelivery,
  creditCard,
  // Add more payment methods as needed
}

enum PaymentStatus {
  unpaid,
  paid,
}

enum OrderStatus {
  placed,
  confirmed,
  outForDelivery,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final Map<String, dynamic> addressSnapshot;
  final DateTime createdAt;
  final String? couponCode;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.addressSnapshot,
    required this.createdAt,
    this.couponCode,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: json['subtotal'] as double,
      deliveryFee: json['deliveryFee'] as double,
      discount: json['discount'] as double,
      total: json['total'] as double,
      paymentMethod: PaymentMethod.values
          .firstWhere((e) => e.toString() == json['paymentMethod']),
      paymentStatus: PaymentStatus.values
          .firstWhere((e) => e.toString() == json['paymentStatus']),
      orderStatus:
          OrderStatus.values.firstWhere((e) => e.toString() == json['orderStatus']),
      addressSnapshot: json['addressSnapshot'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      couponCode: json['couponCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
      'paymentMethod': paymentMethod.toString(),
      'paymentStatus': paymentStatus.toString(),
      'orderStatus': orderStatus.toString(),
      'addressSnapshot': addressSnapshot,
      'createdAt': createdAt.toIso8601String(),
      'couponCode': couponCode,
    };
  }
}
