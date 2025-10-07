import '../models/category.dart';

class CategoryService {
  Future<List<Category>> getCategories() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));

    // Return mock data for now
    return [
      Category(
        id: 'mens',
        name: 'رجال',
        description: 'أزياء وملابس رجالية',
        icon: 'man',
        subcategories: [
          'قمصان',
          'بناطيل',
          'جاكيتات',
          'أحذية رجالية',
          'ملابس رياضية',
          'ملابس رسمية',
          'اكسسوارات'
        ],
        productCount: 200,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: 'womens',
        name: 'نساء',
        description: 'أزياء وملابس نسائية',
        icon: 'woman',
        subcategories: [
          'فساتين',
          'بلوزات',
          'تنانير',
          'بناطيل',
          'عبايات',
          'حجابات',
          'أحذية نسائية',
          'حقائب',
          'اكسسوارات'
        ],
        productCount: 300,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: 'kids',
        name: 'أطفال',
        description: 'ملابس وأزياء للأطفال',
        icon: 'child_care',
        subcategories: [
          'ملابس أولاد',
          'ملابس بنات',
          'ملابس أطفال حديثي الولادة',
          'أحذية أطفال',
          'اكسسوارات أطفال'
        ],
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
        productCount: 150,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: 'formal',
        name: 'ملابس رسمية',
        description: 'ملابس رسمية للمناسبات',
        icon: 'business',
        subcategories: [
          'بدلات رجالية',
          'فساتين سهرة',
          'أزياء رسمية للأطفال',
          'أحذية رسمية',
          'اكسسوارات رسمية'
        ],
        productCount: 100,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: 'sports',
        name: 'ملابس رياضية',
        description: 'ملابس وأزياء رياضية',
        icon: 'sports',
        subcategories: [
          'ملابس رياضية رجالية',
          'ملابس رياضية نسائية',
          'ملابس رياضية للأطفال',
          'أحذية رياضية',
          'اكسسوارات رياضية'
        ],
        productCount: 120,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: 'accessories',
        name: 'اكسسوارات',
        description: 'اكسسوارات وإضافات',
        icon: 'diamond',
        subcategories: [
          'مجوهرات',
          'ساعات',
          'نظارات',
          'أحزمة',
          'قبعات وطواقي',
          'شالات ووشاحات'
        ],
        productCount: 180,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: 'seasonal',
        name: 'مجموعات موسمية',
        description: 'أزياء موسمية خاصة',
        icon: 'event',
        subcategories: [
          'ملابس الصيف',
          'ملابس الشتاء',
          'ملابس العيد',
          'ملابس رمضان',
          'عروض خاصة'
        ],
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
