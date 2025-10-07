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
    await Future.delayed(const Duration(milliseconds: 800));

    // Return mock data now
    final mockProducts = _getMockProducts();

    // Filter products based on category and subcategory
    return mockProducts.where((product) {
      if (categoryId != null && product.categoryId != categoryId) {
        return false;
      }
      if (subcategory != null && product.subcategory != subcategory) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<Product> getProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final products = _getMockProducts();
    return products.firstWhere(
      (product) => product.id == id,
      orElse: () => throw Exception('Product not found'),
    );
  }

  List<Product> _getMockProducts() {
    final now = DateTime.now();
    return [
      // Men's Products
      Product(
        id: 'mens_shirt_1',
        name: 'قميص قطني كاجوال',
        description: '''قميص قطني مريح بأكمام طويلة مناسب للإرتداء اليومي
• قماش قطني 100% مريح وعالي الجودة
• تصميم عصري مناسب لجميع المناسبات
• متوفر بعدة ألوان وأحجام
• سهل العناية والغسيل''',
        price: 12000,
        originalPrice: 15000,
        categoryId: 'mens',
        subcategory: 'قمصان',
        images: ['https://picsum.photos/200/300?random=1'],
        options: {'size': ['S', 'M', 'L', 'XL'], 'color': ['أبيض', 'أزرق', 'أسود']},
        rating: 4.5,
        reviewCount: 128,
        isInStock: true,
        brand: 'Classic Wear',
        material: '100% قطن',
        fit: 'Regular Fit',
        careInstructions: ['غسيل بماء بارد', 'كي على درجة حرارة متوسطة'],
        style: 'كاجوال',
        occasions: ['يومي', 'عمل'],
        season: 'جميع المواسم',
        modelSize: 'M',
        modelHeight: '180 سم',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
        measurements: {
          'الطول': '75 سم',
          'عرض الصدر': '55 سم',
          'طول الكم': '65 سم',
        },
        sizeStock: {
          'S': 5,
          'M': 8,
          'L': 10,
          'XL': 6,
        },
      ),
      Product(
        id: 'mens_shirt_2',
        name: 'قميص أكسفورد رسمي',
        description: '''قميص رسمي أنيق مناسب للمناسبات الرسمية والعمل
• قماش أكسفورد عالي الجودة
• قصة ضيقة تناسب الجسم
• أزرار لؤلؤية اللون
• ياقة كلاسيكية''',
        price: 15000,
        originalPrice: 18000,
        categoryId: 'mens',
        subcategory: 'قمصان',
        images: ['https://picsum.photos/200/300?random=11'],
        options: {'size': ['S', 'M', 'L', 'XL'], 'color': ['أبيض', 'أزرق فاتح', 'وردي فاتح']},
        rating: 4.7,
        reviewCount: 85,
        isInStock: true,
        brand: 'Business Elite',
        material: '100% قطن مصري',
        fit: 'Slim Fit',
        careInstructions: ['تنظيف جاف', 'كي على درجة حرارة متوسطة'],
        style: 'رسمي',
        occasions: ['عمل', 'مناسبات رسمية'],
        season: 'جميع المواسم',
        modelSize: 'M',
        modelHeight: '182 سم',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
        measurements: {
          'الطول': '77 سم',
          'عرض الصدر': '54 سم',
          'طول الكم': '66 سم',
        },
        sizeStock: {
          'S': 3,
          'M': 6,
          'L': 8,
          'XL': 4,
        },
      ),
      Product(
        id: 'mens_pants_1',
        name: 'بنطلون جينز كلاسيك',
        description: '''بنطلون جينز كلاسيكي بقصة مستقيمة
• قماش دينم عالي الجودة
• مريح في الارتداء
• جيوب متعددة
• مناسب للإطلالة اليومية''',
        price: 18000,
        originalPrice: null,
        categoryId: 'mens',
        subcategory: 'بناطيل',
        images: ['https://picsum.photos/200/300?random=2'],
        options: {'size': ['30', '32', '34', '36'], 'color': ['أزرق', 'أسود']},
        rating: 4.3,
        reviewCount: 95,
        isInStock: true,
        brand: 'Denim Co',
        material: '98% قطن، 2% ليكرا',
        fit: 'Regular Fit',
        careInstructions: ['غسيل بماء بارد', 'عدم استخدام المجفف'],
        style: 'كاجوال',
        occasions: ['يومي'],
        season: 'جميع المواسم',
        modelSize: '32',
        modelHeight: '185 سم',
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now,
        measurements: {
          'الطول': '102 سم',
          'عرض الخصر': '82 سم',
        },
        sizeStock: {
          '30': 4,
          '32': 8,
          '34': 6,
          '36': 5,
        },
      ),
      
      // Women's Products
      Product(
        id: 'womens_dress_1',
        name: 'فستان سهرة أنيق',
        description: '''فستان سهرة طويل بتصميم أنيق
• قماش حرير فاخر
• تطريز يدوي راقي
• بطانة داخلية ناعمة
• إطلالة مثالية للمناسبات''',
        price: 35000,
        originalPrice: 45000,
        categoryId: 'womens',
        subcategory: 'فساتين',
        images: ['https://picsum.photos/200/300?random=3'],
        options: {'size': ['S', 'M', 'L'], 'color': ['أحمر', 'أسود', 'ذهبي']},
        rating: 4.8,
        reviewCount: 64,
        isInStock: true,
        brand: 'Elegance',
        material: 'حرير',
        fit: 'Slim Fit',
        careInstructions: ['تنظيف جاف فقط'],
        style: 'أنيق',
        occasions: ['سهرة', 'مناسبات'],
        season: 'جميع المواسم',
        modelSize: 'S',
        modelHeight: '175 سم',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
        measurements: {
          'الطول': '150 سم',
          'عرض الصدر': '86 سم',
          'عرض الخصر': '70 سم',
        },
        sizeStock: {
          'S': 3,
          'M': 5,
          'L': 4,
        },
      ),
      Product(
        id: 'womens_abaya_2',
        name: 'عباية مطرزة فاخرة',
        description: '''عباية عصرية بتطريز راقي
• قماش كريب فاخر
• تطريز يدوي مميز
• تصميم عصري أنيق
• مناسبة للمناسبات الخاصة''',
        price: 28000,
        originalPrice: 32000,
        categoryId: 'womens',
        subcategory: 'عبايات',
        images: ['https://picsum.photos/200/300?random=12'],
        options: {'size': ['S', 'M', 'L', 'XL'], 'color': ['أسود']},
        rating: 4.9,
        reviewCount: 73,
        isInStock: true,
        brand: 'Abaya Elegance',
        material: 'كريب حرير',
        fit: 'Regular Fit',
        careInstructions: ['تنظيف جاف فقط', 'كي على درجة حرارة منخفضة'],
        style: 'عصري',
        occasions: ['مناسبات خاصة', 'سهرة'],
        season: 'جميع المواسم',
        modelSize: 'M',
        modelHeight: '168 سم',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now,
        measurements: {
          'الطول': '58 سم',
          'عرض الكتف': '42 سم',
        },
        sizeStock: {
          'S': 4,
          'M': 6,
          'L': 5,
          'XL': 3,
        },
      ),
      
      // Kids' Products
      Product(
        id: 'kids_shirt_1',
        name: 'قميص أطفال كاجوال',
        description: '''قميص قطني مريح للأطفال
• قماش قطني ناعم صديق للبشرة
• أزرار آمنة وسهلة الاستخدام
• تصميم مرح ومريح
• سهل العناية والغسيل''',
        price: 8000,
        originalPrice: 10000,
        categoryId: 'kids',
        subcategory: 'ملابس أولاد',
        images: ['https://picsum.photos/200/300?random=13'],
        options: {'size': ['4', '6', '8', '10'], 'color': ['أزرق', 'أحمر', 'أخضر']},
        rating: 4.6,
        reviewCount: 42,
        isInStock: true,
        brand: 'Kids Comfort',
        material: '100% قطن عضوي',
        fit: 'Regular Fit',
        careInstructions: ['غسيل بماء دافئ', 'تجنب المبيضات'],
        style: 'كاجوال',
        occasions: ['يومي', 'مدرسة'],
        season: 'جميع المواسم',
        modelSize: '6',
        modelHeight: '116 سم',
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now,
        measurements: {
          'الطول': '45 سم',
          'عرض الصدر': '35 سم',
          'طول الكم': '40 سم',
        },
        sizeStock: {
          '4': 6,
          '6': 8,
          '8': 7,
          '10': 5,
        },
      ),
      Product(
        id: 'kids_dress_2',
        name: 'فستان بناتي مزركش',
        description: '''فستان أنيق للمناسبات الخاصة
• قماش ساتان ناعم مع تول
• تطريز يدوي جميل
• فيونكة كبيرة في الخلف
• بطانة داخلية مريحة''',
        price: 18000,
        originalPrice: 22000,
        categoryId: 'kids',
        subcategory: 'ملابس بنات',
        images: ['https://picsum.photos/200/300?random=14'],
        options: {'size': ['4', '6', '8', '10'], 'color': ['وردي', 'أبيض', 'أزرق فاتح']},
        rating: 4.8,
        reviewCount: 56,
        isInStock: true,
        brand: 'Little Princess',
        material: 'ساتان وتول',
        fit: 'Princess Cut',
        careInstructions: ['تنظيف جاف فقط', 'تخزين في كيس قماشي'],
        style: 'أنيق',
        occasions: ['حفلات', 'مناسبات خاصة'],
        season: 'جميع المواسم',
        modelSize: '6',
        modelHeight: '118 سم',
        createdAt: now.subtract(const Duration(days: 18)),
        updatedAt: now,
        measurements: {
          'الطول': '65 سم',
          'عرض الصدر': '32 سم',
          'عرض الخصر': '30 سم',
        },
        sizeStock: {
          '4': 4,
          '6': 6,
          '8': 5,
          '10': 3,
        },
      ),
      
      // Formal Wear
      Product(
        id: 'formal_suit_2',
        name: 'طقم بدلة رسمية',
        description: '''بدلة رسمية فاخرة للمناسبات الخاصة
• قماش صوف إيطالي فاخر
• بطانة حريرية داخلية
• جاكيت بزر واحد
• بنطلون بقصة مستقيمة
• صدرية متناسقة''',
        price: 65000,
        originalPrice: 75000,
        categoryId: 'formal',
        subcategory: 'بدلات رجالية',
        images: ['https://picsum.photos/200/300?random=15'],
        options: {'size': ['48', '50', '52', '54'], 'color': ['أسود', 'كحلي', 'رمادي']},
        rating: 4.9,
        reviewCount: 38,
        isInStock: true,
        brand: 'Elegance Elite',
        material: 'صوف إيطالي 120s',
        fit: 'Slim Fit',
        careInstructions: ['تنظيف جاف فقط', 'تخزين في كيس مخصص'],
        style: 'رسمي',
        occasions: ['أعراس', 'مناسبات رسمية', 'حفلات'],
        season: 'جميع المواسم',
        modelSize: '50',
        modelHeight: '182 سم',
        createdAt: now.subtract(const Duration(days: 12)),
        updatedAt: now,
        measurements: {
          'طول الجاكيت': '74 سم',
          'عرض الكتف': '44 سم',
          'طول الكم': '64 سم',
          'طول البنطلون': '106 سم',
        },
        sizeStock: {
          '48': 2,
          '50': 4,
          '52': 3,
          '54': 2,
        },
      ),
      Product(
        id: 'formal_tuxedo_1',
        name: 'توكسيدو أسود فاخر',
        description: '''بدلة توكسيدو فاخرة للمناسبات المسائية
• قماش صوف وحرير مميز
• طية صدر من الساتان
• أزرار مغلفة بالحرير
• ربطة عنق فراشية
• حزام خصر حريري''',
        price: 85000,
        originalPrice: 95000,
        categoryId: 'formal',
        subcategory: 'توكسيدو',
        images: ['https://picsum.photos/200/300?random=16'],
        options: {'size': ['48', '50', '52', '54'], 'color': ['أسود']},
        rating: 5.0,
        reviewCount: 24,
        isInStock: true,
        brand: 'Black Tie',
        material: 'مزيج صوف وحرير',
        fit: 'Slim Fit',
        careInstructions: ['تنظيف جاف فقط', 'تخزين في كيس مخصص', 'حماية من الرطوبة'],
        style: 'رسمي فاخر',
        occasions: ['حفلات مسائية', 'مناسبات VIP'],
        season: 'جميع المواسم',
        modelSize: '50',
        modelHeight: '184 سم',
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now,
        measurements: {
          'طول الجاكيت': '73 سم',
          'عرض الكتف': '45 سم',
          'طول الكم': '65 سم',
          'طول البنطلون': '108 سم',
        },
        sizeStock: {
          '48': 2,
          '50': 3,
          '52': 2,
          '54': 1,
        },
      ),
    ];
  }
}
