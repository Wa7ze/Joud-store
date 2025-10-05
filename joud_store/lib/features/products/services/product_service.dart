import '../models/product.dart';

class ProductService {
  Future<List<Product>> getProducts({
    String? categoryId,
    String? subcategory,
    String? query,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
  }) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));

    // Return mock data for now
    return List.generate(
      20,
      (index) => Product(
        id: 'product_$index',
        name: 'منتج ${index + 1}',
        description: 'وصف المنتج ${index + 1}',
        price: 10000 + (index * 5000),
        originalPrice: index % 2 == 0 ? 15000 + (index * 5000) : null,
        categoryId: categoryId ?? 'general',
        subcategory: subcategory,
        images: [
          'https://picsum.photos/200/300?random=$index',
        ],
        options: {
          'اللون': ['أحمر', 'أزرق', 'أسود'],
          'الحجم': ['صغير', 'وسط', 'كبير'],
        },
        rating: 4.0 + (index % 5) * 0.2,
        reviewCount: 10 + index,
        isInStock: index % 3 != 0,
        createdAt: DateTime.now().subtract(Duration(days: index)),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<Product> getProduct(String id) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock data for now
    final index = int.tryParse(id.split('_').last) ?? 0;
    return Product(
      id: id,
      name: 'منتج ${index + 1}',
      description: '''
وصف تفصيلي للمنتج ${index + 1}

- ميزة 1
- ميزة 2
- ميزة 3

معلومات إضافية عن المنتج وتفاصيل أخرى.
''',
      price: 10000 + (index * 5000),
      originalPrice: index % 2 == 0 ? 15000 + (index * 5000) : null,
      categoryId: 'general',
      subcategory: null,
      images: List.generate(
        3,
        (i) => 'https://picsum.photos/400/600?random=${index * 3 + i}',
      ),
      options: {
        'اللون': ['أحمر', 'أزرق', 'أسود'],
        'الحجم': ['صغير', 'وسط', 'كبير'],
      },
      rating: 4.0 + (index % 5) * 0.2,
      reviewCount: 10 + index,
      isInStock: index % 3 != 0,
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now(),
    );
  }
}
