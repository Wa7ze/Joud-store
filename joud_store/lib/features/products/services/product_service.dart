import 'dart:math';
import '../models/product.dart';
import '../models/product_filters.dart';

/// In-memory mock catalog with realistic clothing data for Syria.
class ProductService {
  static final ProductService _singleton = ProductService._internal();
  factory ProductService() => _singleton;
  ProductService._internal() {
    _seedIfNeeded();
  }

  final List<Product> _catalog = [];
  final _rng = Random(42);

  void _seedIfNeeded() {
    if (_catalog.isNotEmpty) return;

    final now = DateTime.now();

    // Categories & subcategories
    const categories = ['men', 'women', 'kids'];
    const subcats = {
      'men': ['tshirts', 'shirts', 'jeans', 'chinos', 'jackets', 'sportswear'],
      'women': ['blouses', 'dresses', 'abayas', 'jeans', 'skirts', 'outerwear'],
      'kids': ['tshirts', 'hoodies', 'jeans', 'sets', 'sportswear'],
    };

    // Size maps by category
    const sizeMap = {
      'men': ['S','M','L','XL','2XL','3XL'],
      'women': ['XS','S','M','L','XL','2XL'],
      'kids': ['2','4','6','8','10','12','14'],
    };

    // Numeric jeans for men/women (28-40)
    final jeansSizes = List<String>.generate(7, (i) => (28 + i*2).toString());

    const colors = [
      'Black','White','Navy','Blue','Light Blue','Grey',
      'Beige','Brown','Green','Olive','Red','Burgundy','Pink','Purple'
    ];

    const brands = ['ShamWear','Aleppo Denim','Damascus Line','Coast & Cotton','Qasioun Sports'];
    const materials = ['Cotton','Cotton Blend','Denim','Polyester','Viscose','Wool Blend'];
    const fits = ['Regular','Slim','Oversized','Relaxed'];
    const occasions = ['Casual','Formal','Sports'];
    const seasons = ['Spring','Summer','Fall','Winter'];
    const styles = ['Classic','Streetwear','Modest','Sporty','Minimal'];

    int idCounter = 1000;

    // Helper to price by subcategory (SYP)
    double basePrice(String sub) {
      switch (sub) {
        case 'tshirts': return 120000;
        case 'shirts': return 220000;
        case 'jeans': return 380000;
        case 'chinos': return 300000;
        case 'jackets': return 650000;
        case 'sportswear': return 240000;
        case 'blouses': return 230000;
        case 'dresses': return 520000;
        case 'abayas': return 900000;
        case 'skirts': return 280000;
        case 'outerwear': return 700000;
        case 'hoodies': return 260000;
        case 'sets': return 320000;
        default: return 250000;
      }
    }

    Product makeProduct(String cat, String sub) {
      final id = (idCounter++).toString();
      final brand = brands[_rng.nextInt(brands.length)];
      final material = materials[_rng.nextInt(materials.length)];
      final fit = fits[_rng.nextInt(fits.length)];
      final style = styles[_rng.nextInt(styles.length)];
      final season = seasons[_rng.nextInt(seasons.length)];
      final occ = occasions[_rng.nextInt(occasions.length)];
      final name = _titleFor(cat, sub, brand, style);
      final price0 = basePrice(sub);
      final price = (price0 * (0.8 + _rng.nextDouble() * 0.6)).roundToDouble();
      final discount = _rng.nextBool() && _rng.nextInt(5) == 0; // ~20% discounted
      final originalPrice = discount ? (price * (1.10 + _rng.nextDouble()*0.25)) : null;

      // Sizes & stock
      List<String> sizes =
          (sub == 'jeans') ? jeansSizes : sizeMap[cat]!;
      final sizeStock = <String,int>{};
      for (final s in sizes) {
        // random stock 0-8 (some OOS)
        sizeStock[s] = _rng.nextInt(9);
      }
      final isInStock = sizeStock.values.any((v) => v > 0);

      // Color options (pick 3-5)
      final colorCount = 3 + _rng.nextInt(3);
      final colorOpts = _pickN(colors, colorCount);

      // Images: deterministic placeholders per color
      final images = colorOpts.take(1).map((c) => _imageFor(sub, c)).toList();

      return Product(
        id: id,
        name: name,
        description: _descriptionFor(cat, sub, material, fit, style),
        price: price.toDouble(),
        originalPrice: originalPrice?.toDouble(),
        categoryId: cat,
        subcategory: sub,
        images: images,
        options: {
          'size': sizes,
          'color': colorOpts,
        },
        rating: 3.6 + _rng.nextDouble()*1.4,
        reviewCount: 5 + _rng.nextInt(200),
        isInStock: isInStock,
        createdAt: now.subtract(Duration(days: _rng.nextInt(180))),
        updatedAt: now.subtract(Duration(days: _rng.nextInt(30))),
        brand: brand,
        material: material,
        fit: fit,
        careInstructions: [
          'Machine wash cold',
          'Do not bleach',
          'Tumble dry low',
          if (material.contains('Wool')) 'Dry clean preferred',
        ],
        sizeStock: sizeStock,
        occasions: [occ],
        season: season,
        style: style,
        measurements: {
          'Length': _rng.nextInt(20) + 60 >= 0 ? '${_rng.nextInt(20) + 60} cm' : '—',
          'Shoulder': '${_rng.nextInt(10) + 40} cm',
        },
        modelSize: (cat == 'kids') ? null : sizes[sizes.length ~/ 2],
        modelHeight: (cat == 'kids') ? null : 170 + _rng.nextInt(20) + 0.0,
      );
    }

    // Create ~150 products with distribution across categories/subcategories
    for (final cat in categories) {
      final subs = subcats[cat]!;
      for (final sub in subs) {
        final count = 12 + _rng.nextInt(8); // 12..19 per subcat
        for (var i = 0; i < count; i++) {
          _catalog.add(makeProduct(cat, sub));
        }
      }
    }
  }

  // === Public API ===

  Future<List<Product>> getProducts({
    String? categoryId,
    String? subcategory,
    String? query,
    String? sortBy, // "latest", "price_asc", "price_desc", "popularity"
    double? minPrice,
    double? maxPrice,
    List<String>? sizes,
    List<String>? colors,
    List<String>? styles,
    List<String>? occasions,
    int page = 1,
    int pageSize = 24,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));

    Iterable<Product> results = _catalog;

    if (categoryId != null && categoryId.isNotEmpty) {
      results = results.where((p) => p.categoryId == categoryId);
    }
    if (subcategory != null && subcategory.isNotEmpty) {
      results = results.where((p) => p.subcategory == subcategory);
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      results = results.where((p) =>
        p.name.toLowerCase().contains(q) ||
        p.brand?.toLowerCase().contains(q) == true ||
        p.style?.toLowerCase().contains(q) == true ||
        p.material?.toLowerCase().contains(q) == true
      );
    }
    if (minPrice != null) {
      results = results.where((p) => p.price >= minPrice);
    }
    if (maxPrice != null) {
      results = results.where((p) => p.price <= maxPrice);
    }
    if (sizes != null && sizes.isNotEmpty) {
      results = results.where((p) => p.options['size']!.any((s) => sizes.contains(s)));
    }
    if (colors != null && colors.isNotEmpty) {
      results = results.where((p) => p.options['color']!.any((c) => colors.contains(c)));
    }
    if (styles != null && styles.isNotEmpty) {
      results = results.where((p) => styles.contains(p.style));
    }
    if (occasions != null && occasions.isNotEmpty) {
      results = results.where((p) => p.occasions?.any(occasions.contains) == true);
    }

    // Sorting
    switch (sortBy) {
      case 'price_asc':
        results = results.toList()..sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        results = results.toList()..sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'popularity':
        results = results.toList()..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case 'latest':
      default:
        results = results.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    // Pagination
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    final list = results.toList();
    if (start >= list.length) return [];
    return list.sublist(start, end.clamp(0, list.length));
  }

  Future<Product> getProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final p = _catalog.firstWhere((p) => p.id == id);
    return p;
  }

  // === Helpers ===
  String _titleFor(String cat, String sub, String brand, String style) {
    final niceCat = {'men': 'Men', 'women': 'Women', 'kids': 'Kids'}[cat] ?? 'All';
    final niceSub = sub[0].toUpperCase() + sub.substring(1);
    return '$brand $niceCat $niceSub — $style';
  }

  String _descriptionFor(String cat, String sub, String material, String fit, String style) {
    return 'A $style $sub for ${cat == 'men' ? 'men' : cat == 'women' ? 'women' : 'kids'} '
           'crafted from $material with a $fit fit. Soft hand-feel and everyday comfort.';
  }

  List<String> _pickN(List<String> list, int n) {
    final pool = List<String>.from(list);
    pool.shuffle(_rng);
    return pool.take(n).toList();
  }

  String _imageFor(String sub, String color) {
    final colorSlug = color.toLowerCase().replaceAll(' ', '-');
    final subSlug = sub.toLowerCase();
    // using generic placeholder images by subcategory/color naming scheme
    return 'assets/images/$subSlug/$colorSlug.png';
  }
}
