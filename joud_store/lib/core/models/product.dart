class ProductAttribute {
  final String name;
  final List<String> values;

  ProductAttribute({
    required this.name,
    required this.values,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      name: json['name'] as String,
      values: (json['values'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'values': values,
    };
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final double price;
  final double? compareAtPrice;
  final String currency;
  final int stock;
  final String sku;
  final List<String> categoryIds;
  final Map<String, ProductAttribute> attributes;
  final bool isActive;
  final double? rating;
  final int reviewCount;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.price,
    this.compareAtPrice,
    this.currency = 'SYP',
    required this.stock,
    required this.sku,
    required this.categoryIds,
    required this.attributes,
    this.isActive = true,
    this.rating,
    this.reviewCount = 0,
  });

  bool get hasDiscount => compareAtPrice != null && compareAtPrice! > price;
  bool get isInStock => stock > 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      images: (json['images'] as List<dynamic>).cast<String>(),
      price: json['price'] as double,
      compareAtPrice: json['compareAtPrice'] as double?,
      currency: json['currency'] as String? ?? 'SYP',
      stock: json['stock'] as int,
      sku: json['sku'] as String,
      categoryIds: (json['categoryIds'] as List<dynamic>).cast<String>(),
      attributes: (json['attributes'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          ProductAttribute.fromJson(value as Map<String, dynamic>),
        ),
      ),
      isActive: json['isActive'] as bool? ?? true,
      rating: json['rating'] as double?,
      reviewCount: json['reviewCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images,
      'price': price,
      'compareAtPrice': compareAtPrice,
      'currency': currency,
      'stock': stock,
      'sku': sku,
      'categoryIds': categoryIds,
      'attributes': attributes.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'isActive': isActive,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}
