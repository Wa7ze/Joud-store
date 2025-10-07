import 'dart:convert';

/// Clothing-focused Product model with variants/options.
class Product {
  final String id;
  final String name;
  final String description;
  final double price;               // current price (after discount if compareAtPrice != null)
  final double? originalPrice;      // pre-discount price (aka compare-at)
  final String categoryId;          // e.g., "men", "women", "kids", or subcategory id
  final String? subcategory;        // e.g., "jeans", "tshirts", "abayas"
  final List<String> images;        // image urls or asset paths
  final Map<String, List<String>> options; // {"size": ["S","M"], "color": ["Black","Blue"]}
  final double rating;              // 0..5
  final int reviewCount;
  final bool isInStock;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Clothing-specific fields
  final String? brand;
  final String? material;           // cotton, denim, wool blend...
  final String? fit;                // regular, slim, oversized
  final List<String>? careInstructions; // ["Machine wash cold", "Do not bleach"]
  final Map<String, int>? sizeStock; // stock per size (for quickest checks)
  final List<String>? occasions;    // casual, formal, sports
  final String? season;             // spring, summer, fall, winter
  final String? style;              // streetwear, modest, classic, sporty
  final Map<String, String>? measurements; // e.g., {"length": "70cm"}
  final String? modelSize;          // e.g., "M"
  final double? modelHeight;        // in cm

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.categoryId,
    this.subcategory,
    required this.images,
    required this.options,
    required this.rating,
    required this.reviewCount,
    required this.isInStock,
    required this.createdAt,
    required this.updatedAt,
    this.brand,
    this.material,
    this.fit,
    this.careInstructions,
    this.sizeStock,
    this.occasions,
    this.season,
    this.style,
    this.measurements,
    this.modelSize,
    this.modelHeight,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? categoryId,
    String? subcategory,
    List<String>? images,
    Map<String, List<String>>? options,
    double? rating,
    int? reviewCount,
    bool? isInStock,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? brand,
    String? material,
    String? fit,
    List<String>? careInstructions,
    Map<String, int>? sizeStock,
    List<String>? occasions,
    String? season,
    String? style,
    Map<String, String>? measurements,
    String? modelSize,
    double? modelHeight,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      categoryId: categoryId ?? this.categoryId,
      subcategory: subcategory ?? this.subcategory,
      images: images ?? this.images,
      options: options ?? this.options,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isInStock: isInStock ?? this.isInStock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      brand: brand ?? this.brand,
      material: material ?? this.material,
      fit: fit ?? this.fit,
      careInstructions: careInstructions ?? this.careInstructions,
      sizeStock: sizeStock ?? this.sizeStock,
      occasions: occasions ?? this.occasions,
      season: season ?? this.season,
      style: style ?? this.style,
      measurements: measurements ?? this.measurements,
      modelSize: modelSize ?? this.modelSize,
      modelHeight: modelHeight ?? this.modelHeight,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      categoryId: json['categoryId'] as String,
      subcategory: json['subcategory'] as String?,
      images: (json['images'] as List<dynamic>).cast<String>(),
      options: (json['options'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as List<dynamic>).cast<String>()),
      ),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      isInStock: json['isInStock'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      brand: json['brand'] as String?,
      material: json['material'] as String?,
      fit: json['fit'] as String?,
      careInstructions: (json['careInstructions'] as List<dynamic>?)?.cast<String>(),
      sizeStock: (json['sizeStock'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, (v as num).toInt())),
      occasions: (json['occasions'] as List<dynamic>?)?.cast<String>(),
      season: json['season'] as String?,
      style: json['style'] as String?,
      measurements: (json['measurements'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v.toString())),
      modelSize: json['modelSize'] as String?,
      modelHeight: (json['modelHeight'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'categoryId': categoryId,
      'subcategory': subcategory,
      'images': images,
      'options': options,
      'rating': rating,
      'reviewCount': reviewCount,
      'isInStock': isInStock,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'brand': brand,
      'material': material,
      'fit': fit,
      'careInstructions': careInstructions,
      'sizeStock': sizeStock,
      'occasions': occasions,
      'season': season,
      'style': style,
      'measurements': measurements,
      'modelSize': modelSize,
      'modelHeight': modelHeight,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
