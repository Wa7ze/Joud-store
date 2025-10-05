class Category {
  final String id;
  final String name;
  final String? description;
  final String? image;
  final String? icon;
  final List<String> subcategories;
  final int productCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.icon,
    required this.subcategories,
    required this.productCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      icon: json['icon'] as String?,
      subcategories: List<String>.from(json['subcategories'] as List),
      productCount: json['productCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'icon': icon,
      'subcategories': subcategories,
      'productCount': productCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    String? icon,
    List<String>? subcategories,
    int? productCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      icon: icon ?? this.icon,
      subcategories: subcategories ?? this.subcategories,
      productCount: productCount ?? this.productCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
