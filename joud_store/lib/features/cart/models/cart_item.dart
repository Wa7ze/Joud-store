class CartItem {
  final String id; // unique per product + variant
  final String productId;
  final String name;
  final double price;
  final double? originalPrice;
  final int quantity;
  final String? imageUrl;
  final String? size;
  final String? color;

  const CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.originalPrice,
    this.quantity = 1,
    this.imageUrl,
    this.size,
    this.color,
  });

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    double? originalPrice,
    int? quantity,
    String? imageUrl,
    String? size,
    String? color,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }
}

