import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/app_config.dart';
import '../../core/localization/localization_service.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/screen_scaffold.dart' as scaffold;
import '../../core/widgets/ui_states.dart';
import 'models/product.dart';
import 'models/product_filters.dart';
import 'providers/product_provider.dart';

class AppColors {
  static const Color primary = Color(0xFFFF4081);
  static const Color primaryGradientStart = Color(0xFFFF4081);
  static const Color primaryGradientEnd = Color(0xFFFF80AB);
  static const Color sale = Color(0xFFE91E63);
  static const Color primaryLight = Color(0xFFFCE4EC);
  static const Color text = Color(0xFF2C2C2C);
  static const Color textLight = Color(0xFF757575);
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFF8F8F8);
  static const Color border = Color(0xFFE0E0E0);
  static const Color rating = Color(0xFFFFB300);
  static const Color sizes = Color(0xFFF5F5F5);
  static const Color outOfStock = Color(0xFFE0E0E0);
}

class ProductListScreen extends ConsumerStatefulWidget {
  final String? categoryId;
  final String? subcategory;
  
  const ProductListScreen({
    super.key,
    this.categoryId,
    this.subcategory,
  });

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true;
  String _sortBy = 'latest';
  double _minPrice = 0;
  double _maxPrice = 100000;
  final List<String> _selectedFilters = [];
  
  final Set<String> _selectedSizes = {};
  final Set<String> _selectedColors = {};
  
  static const List<String> _availableSizes = ['XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL'];
  static const Map<String, Color> _availableColors = {
    'Black': Colors.black,
    'White': Colors.white,
    'Grey': Color(0xFF757575),
    'Navy': Color(0xFF000080),
    'Beige': Color(0xFFF5F5DC),
    'Brown': Color(0xFF8B4513),
    'Pink': Color(0xFFFF4081),
    'Red': Color(0xFFE53935),
  };
  

  
  late final StateProvider<ProductFilters> _filtersProvider;

  @override
  void initState() {
    super.initState();
    _filtersProvider = StateProvider<ProductFilters>((ref) {
      return ProductFilters(
        categoryId: widget.categoryId,
        subcategory: widget.subcategory,
        sortBy: _sortBy,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        selectedSizes: _selectedSizes.toList(),
        selectedColors: _selectedColors.toList(),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _screenTitle {
    final localizationService = LocalizationService.instance;
    return widget.subcategory ?? 
           widget.categoryId ?? 
           localizationService.getString('products');
  }
  
  @override
  Widget build(BuildContext context) {
    return scaffold.ScreenScaffold(
      title: _screenTitle,
      actions: [
        IconButton(
          icon: Icon(_isGridView ? Icons.list : Icons.grid_view, color: AppColors.primary),
          onPressed: () => setState(() => _isGridView = !_isGridView),
        ),
      ],
      body: Column(
        children: [
          // Search and Sort Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: localizationService.getString('search'),
                      hintStyle: TextStyle(color: AppColors.textLight),
                      prefixIcon: Icon(Icons.search, color: AppColors.textLight),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Sort and Filter Row
                Row(
                  children: [
                    // Sort Dropdown
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButton<String>(
                          value: _sortBy,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: AppColors.textLight),
                          underline: const SizedBox(),
                          items: [
                            DropdownMenuItem(
                              value: 'latest',
                              child: Text('الأحدث', style: TextStyle(color: AppColors.text)),
                            ),
                            DropdownMenuItem(
                              value: 'price_asc',
                              child: Text('السعر: من الأقل للأعلى', style: TextStyle(color: AppColors.text)),
                            ),
                            DropdownMenuItem(
                              value: 'price_desc',
                              child: Text('السعر: من الأعلى للأقل', style: TextStyle(color: AppColors.text)),
                            ),
                            DropdownMenuItem(
                              value: 'popularity',
                              child: Text('الأكثر شعبية', style: TextStyle(color: AppColors.text)),
                            ),
                          ],
                          onChanged: (value) => setState(() => _sortBy = value!),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Filter Button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.white),
                        onPressed: _showFilterBottomSheet,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Active Filters
          if (_selectedFilters.isNotEmpty) 
            _buildActiveFilters(_selectedFilters),
          
          // Products Grid/List
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final filters = ref.watch(_filtersProvider);
                final productsAsync = ref.watch(productsProvider(filters));
                
                return productsAsync.when(
                  data: (products) => _buildProductsList(products),
                  loading: () => const LoadingState(),
                  error: (error, stack) => ErrorState(message: error.toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  late final LocalizationService localizationService = LocalizationService.instance;

  Widget _buildActiveFilters(List<String> activeFilters) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedFilters.length,
        itemBuilder: (context, index) {
          final filter = _selectedFilters[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text(filter),
              onDeleted: () {
                setState(() {
                  _selectedFilters.remove(filter);
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsList(List<Product> products) {

    if (_isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(context, products[index]);
        },
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductListItem(context, products[index]);
        },
      );
    }
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => context.go('${AppRouter.productDetail}/${product.id}'),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 4, // Increased ratio for image
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      image: product.images.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(product.images[0]),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: product.images.isEmpty
                        ? const Center(child: Icon(Icons.image, size: 40, color: Colors.grey))
                        : null,
                  ),
                  if (product.originalPrice != null && product.originalPrice! > product.price)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.sale,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'SALE',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.options['size']?.isNotEmpty ?? false) ...[  
                    // Available Sizes
                    SizedBox(
                      height: 24,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: product.options['size']!.length,
                        itemBuilder: (context, index) {
                          final size = product.options['size']![index];
                          return Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: AppColors.sizes,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                size,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (product.options['color']?.isNotEmpty ?? false) ...[  
                    // Available Colors
                    SizedBox(
                      height: 20,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: product.options['color']!.length,
                        itemBuilder: (context, index) {
                          final colorName = product.options['color']![index];
                          final color = _availableColors[colorName] ?? Colors.grey;
                          return Container(
                            margin: const EdgeInsets.only(right: 4),
                            width: 20,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Brand or Category
                    Text(
                      product.subcategory ?? widget.categoryId ?? 'Fashion',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Price Row
                    Row(
                      children: [
                        // Current Price
                        Text(
                          '${AppConfig.defaultCurrency} ${product.price.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: product.originalPrice != null ? Colors.red : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (product.originalPrice != null && 
                            product.originalPrice! > product.price) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${AppConfig.defaultCurrency} ${product.originalPrice!.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Rating and Review Count
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Colors.amber.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toString(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ' (${product.reviewCount})',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListItem(BuildContext context, Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => context.go('${AppRouter.productDetail}/${product.id}'),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product Image with SALE badge
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      image: product.images.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(product.images[0]),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: product.images.isEmpty
                        ? const Center(child: Icon(Icons.image, size: 30, color: Colors.grey))
                        : null,
                  ),
                  if (product.originalPrice != null && product.originalPrice! > product.price)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'SALE',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(width: 12),
              
              const SizedBox(width: 16),
              
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Brand or Category
                    Text(
                      product.subcategory ?? widget.categoryId ?? 'Fashion',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Price Row
                    Row(
                      children: [
                        // Current Price
                        Text(
                          '${AppConfig.defaultCurrency} ${product.price.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: product.originalPrice != null ? Colors.red : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        if (product.originalPrice != null && 
                            product.originalPrice! > product.price) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${AppConfig.defaultCurrency} ${product.originalPrice!.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Rating and Review Count
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Colors.amber.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toString(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ' (${product.reviewCount})',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Add to Cart Button
              IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocalizationService.instance.getString('productAddedToCart')),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch() {
    if (_searchController.text.isNotEmpty) {
      context.go('${AppRouter.search}?q=${_searchController.text}');
    }
  }

  void _showFilterBottomSheet() {
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Consumer(
          builder: (context, ref, child) {
            final filters = ref.watch(_filtersProvider);
            
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    LocalizationService.instance.getString('filter'),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  
                  // Price Range
                  Text(
                    'نطاق السعر',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 100000,
                    divisions: 20,
                    labels: RangeLabels(
                      '${AppConfig.defaultCurrency} ${_minPrice.toStringAsFixed(0)}',
                      '${AppConfig.defaultCurrency} ${_maxPrice.toStringAsFixed(0)}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sizes
                  Text(
                    'المقاسات',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableSizes.map((size) => FilterChip(
                      label: Text(size),
                      selected: _selectedSizes.contains(size),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedSizes.add(size);
                          } else {
                            _selectedSizes.remove(size);
                          }
                        });
                      },
                      backgroundColor: AppColors.sizes,
                      selectedColor: AppColors.primary.withOpacity(0.1),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: _selectedSizes.contains(size) 
                          ? AppColors.primary 
                          : AppColors.text,
                      ),
                    )).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Colors
                  Text(
                    'الألوان',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _availableColors.entries.map((entry) {
                      final colorName = entry.key;
                      final color = entry.value;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedColors.contains(colorName)) {
                              _selectedColors.remove(colorName);
                            } else {
                              _selectedColors.add(colorName);
                            }
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedColors.contains(colorName)
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                  width: _selectedColors.contains(colorName) ? 2 : 1,
                                ),
                              ),
                              child: _selectedColors.contains(colorName)
                                ? Icon(
                                    Icons.check,
                                    size: 20,
                                    color: color.computeLuminance() > 0.5 
                                      ? Colors.black 
                                      : Colors.white,
                                  )
                                : null,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              colorName,
                              style: TextStyle(
                                fontSize: 12,
                                color: _selectedColors.contains(colorName)
                                  ? AppColors.primary
                                  : AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(_filtersProvider.notifier).state = filters.copyWith(
                          minPrice: _minPrice,
                          maxPrice: _maxPrice,
                          selectedSizes: _selectedSizes.toList(),
                          selectedColors: _selectedColors.toList(),
                        );
                        Navigator.pop(context);
                        
                        final List<String> newFilters = [];
                        
                        if (_minPrice > 0 || _maxPrice < 100000) {
                          newFilters.add('السعر: ${AppConfig.defaultCurrency} ${_minPrice.toStringAsFixed(0)} - ${AppConfig.defaultCurrency} ${_maxPrice.toStringAsFixed(0)}');
                        }
                        
                        if (_selectedSizes.isNotEmpty) {
                          newFilters.add('المقاسات: ${_selectedSizes.join(', ')}');
                        }
                        
                        if (_selectedColors.isNotEmpty) {
                          newFilters.add('الألوان: ${_selectedColors.join(', ')}');
                        }
                        
                        setState(() {
                          _selectedFilters.clear();
                          _selectedFilters.addAll(newFilters);
                        });
                      },
                      child: Text(LocalizationService.instance.getString('apply')),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
