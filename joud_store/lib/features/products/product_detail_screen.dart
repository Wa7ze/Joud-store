import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/router/app_router.dart';
import '../../core/config/app_config.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;
  
  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  bool _isLoading = false;
  int _selectedImageIndex = 0;
  int _quantity = 1;
  String? _selectedSize;
  String? _selectedColor;
  bool _isInCart = false;

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizationService.getString('productDetails')),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareProduct,
          ),
          IconButton(
            icon: Icon(_isInCart ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingState()
          : _buildProductDetails(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProductDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Gallery
          _buildImageGallery(),
          
          // Product Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  'منتج ${widget.productId}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text('4.5'),
                    const SizedBox(width: 8),
                    Text('(123 تقييم)'),
                    const Spacer(),
                    Text('متوفر في المخزون'),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Price
                _buildPriceSection(),
                const SizedBox(height: 24),
                
                // Variants
                _buildVariantsSection(),
                const SizedBox(height: 24),
                
                // Quantity
                _buildQuantitySection(),
                const SizedBox(height: 24),
                
                // Description
                _buildDescriptionSection(),
                const SizedBox(height: 24),
                
                // Reviews
                _buildReviewsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    return Container(
      height: 300,
      child: PageView.builder(
        onPageChanged: (index) {
          setState(() {
            _selectedImageIndex = index;
          });
        },
        itemCount: 3, // Mock images
        itemBuilder: (context, index) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: const Center(
              child: Icon(Icons.image, size: 100),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        Text(
          '${AppConfig.defaultCurrency} 75,000',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${AppConfig.defaultCurrency} 100,000',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            decoration: TextDecoration.lineThrough,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '25% خصم',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVariantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الحجم',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['S', 'M', 'L', 'XL'].map((size) {
            final isSelected = _selectedSize == size;
            return FilterChip(
              label: Text(size),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedSize = selected ? size : null;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        
        Text(
          'اللون',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            {'name': 'أحمر', 'color': Colors.red},
            {'name': 'أزرق', 'color': Colors.blue},
            {'name': 'أخضر', 'color': Colors.green},
            {'name': 'أسود', 'color': Colors.black},
          ].map((colorData) {
            final isSelected = _selectedColor == colorData['name'];
            return FilterChip(
              label: Text(colorData['name'] as String),
              selected: isSelected,
              avatar: CircleAvatar(
                backgroundColor: colorData['color'] as Color,
                radius: 8,
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedColor = selected ? colorData['name'] as String : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySection() {
    return Row(
      children: [
        Text(
          LocalizationService.instance.getString('quantity'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: _quantity > 1 ? () {
                setState(() {
                  _quantity--;
                });
              } : null,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _quantity.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _quantity++;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الوصف',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'هذا منتج عالي الجودة مصنوع من أفضل المواد. مناسب للاستخدام اليومي ويتميز بالمتانة والجودة العالية. يأتي مع ضمان لمدة سنة واحدة.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقييمات',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () {
                // Navigate to reviews screen
              },
              child: Text('عرض الكل'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Review Summary
        Row(
          children: [
            Text('4.5', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (index) => Icon(
                    Icons.star,
                    size: 16,
                    color: index < 4 ? Colors.amber : Colors.grey,
                  )),
                ),
                Text('123 تقييم'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Sample Reviews
        _buildReviewItem('أحمد محمد', 'منتج ممتاز، أنصح به', 5),
        _buildReviewItem('فاطمة علي', 'جودة عالية وسعر مناسب', 4),
      ],
    );
  }

  Widget _buildReviewItem(String name, String comment, int rating) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(name[0]),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: Theme.of(context).textTheme.titleSmall),
                      Row(
                        children: List.generate(5, (index) => Icon(
                          Icons.star,
                          size: 14,
                          color: index < rating ? Colors.amber : Colors.grey,
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final localizationService = LocalizationService.instance;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _addToCart,
              icon: const Icon(Icons.shopping_cart),
              label: Text(localizationService.getString('add')),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _buyNow,
              icon: const Icon(Icons.flash_on),
              label: Text('اشتري الآن'),
            ),
          ),
        ],
      ),
    );
  }

  void _shareProduct() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم مشاركة المنتج'),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isInCart = !_isInCart;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isInCart ? 'تم إضافة المنتج للمفضلة' : 'تم إزالة المنتج من المفضلة'),
      ),
    );
  }

  void _addToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocalizationService.instance.getString('productAddedToCart')),
      ),
    );
  }

  void _buyNow() {
    context.go(AppRouter.checkout);
  }
}
