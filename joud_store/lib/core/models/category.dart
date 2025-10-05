class Category {
  final String id;
  final String name;
  final String? parentId;
  final String image;
  final int order;

  Category({
    required this.id,
    required this.name,
    this.parentId,
    required this.image,
    this.order = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parentId'] as String?,
      image: json['image'] as String,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parentId': parentId,
      'image': image,
      'order': order,
    };
  }
}
