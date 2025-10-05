import '../models/category.dart';

class CategoryService {
  Future<List<Category>> getCategories() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));

    // Return mock data for now
    return [
      Category(
        id: 'electronics',
        name: 'إلكترونيات',
        description: 'أجهزة إلكترونية وملحقاتها',
        icon: 'devices',
        subcategories: ['هواتف', 'لابتوب', 'تلفزيون', 'سماعات'],
        productCount: 150,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: 'clothing',
        name: 'ملابس',
        description: 'ملابس للجميع',
        icon: 'checkroom',
        subcategories: ['رجال', 'نساء', 'أطفال', 'أحذية'],
        productCount: 300,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: 'home',
        name: 'منزل',
        description: 'مستلزمات وأثاث منزلي',
        icon: 'home',
        subcategories: ['أثاث', 'ديكور', 'مطبخ', 'حديقة'],
        productCount: 200,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: 'sports',
        name: 'رياضة',
        description: 'معدات وملابس رياضية',
        icon: 'sports',
        subcategories: ['لياقة', 'رياضات', 'معدات', 'ملابس رياضية'],
        productCount: 100,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: 'books',
        name: 'كتب',
        description: 'كتب متنوعة',
        icon: 'menu_book',
        subcategories: ['روايات', 'تعليمية', 'أطفال', 'مراجع'],
        productCount: 250,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: 'toys',
        name: 'ألعاب',
        description: 'ألعاب للأطفال',
        icon: 'toys',
        subcategories: ['أطفال', 'تعليمية', 'إلكترونية', 'ألعاب فيديو'],
        productCount: 120,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: 'beauty',
        name: 'جمال',
        description: 'منتجات العناية والتجميل',
        icon: 'face',
        subcategories: ['مكياج', 'عناية', 'عطور', 'صحة'],
        productCount: 180,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: 'automotive',
        name: 'سيارات',
        description: 'مستلزمات السيارات',
        icon: 'directions_car',
        subcategories: ['قطع غيار', 'إكسسوارات', 'صيانة', 'تنظيف'],
        productCount: 90,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  Future<Category> getCategory(String id) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    final categories = await getCategories();
    return categories.firstWhere(
      (category) => category.id == id,
      orElse: () => throw Exception('Category not found'),
    );
  }
}
