class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String categoryId;
  final String? subcategory;
  final List<String> images;
  final Map<String, List<String>> options;
  final double rating;
  final int reviewCount;
  final bool isInStock;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Clothing-specific fields
  final String? brand;
  final String? material;
  final String? fit;
  final List<String> careInstructions;
  final Map<String, int> sizeStock;
  final List<String> occasions;
  final String? season;
  final String? style;
  final Map<String, String> measurements;
  final String? modelSize;
  final String? modelHeight;

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
    this.careInstructions = const [],
    this.sizeStock = const {},
    this.occasions = const [],
    this.season,
    this.style,
    this.measurements = const {},
    this.modelSize,
    this.modelHeight,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null 
          ? (json['originalPrice'] as num).toDouble()
          : null,
      categoryId: json['categoryId'] as String,
      subcategory: json['subcategory'] as String?,
      images: List<String>.from(json['images'] as List),
      options: Map<String, List<String>>.from(
        (json['options'] as Map).map(
          (key, value) => MapEntry(
            key as String,
            List<String>.from(value as List),
          ),
        ),
      ),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      isInStock: json['isInStock'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      brand: json['brand'] as String?,
      material: json['material'] as String?,
      fit: json['fit'] as String?,
      careInstructions: json['careInstructions'] != null
          ? List<String>.from(json['careInstructions'] as List)
          : [],
      sizeStock: json['sizeStock'] != null
          ? Map<String, int>.from(json['sizeStock'] as Map)
          : {},
      occasions: json['occasions'] != null
          ? List<String>.from(json['occasions'] as List)
          : [],
      season: json['season'] as String?,
      style: json['style'] as String?,
      measurements: json['measurements'] != null
          ? Map<String, String>.from(json['measurements'] as Map)
          : {},
      modelSize: json['modelSize'] as String?,
      modelHeight: json['modelHeight'] as String?,
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
    String? modelHeight,
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
}
