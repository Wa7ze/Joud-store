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
                const SizedBox(height: 24),
                
                // Complete the Look
                _buildCompleteLookSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = [
      {'type': 'model', 'url': 'https://example.com/model.jpg'},
      {'type': 'detail', 'url': 'https://example.com/detail1.jpg'},
      {'type': 'texture', 'url': 'https://example.com/texture.jpg'},
    ];
    
    return Stack(
      children: [
        // Main image viewer
        Container(
          height: 400,
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() {
                _selectedImageIndex = index;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showImageViewer(index),
                child: Hero(
                  tag: 'product_image_$index',
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Image placeholder
                        const Icon(Icons.image, size: 100),
                        
                        // Image type indicator
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getImageTypeIcon(images[index]['type'] as String),
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getImageTypeLabel(images[index]['type'] as String),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Zoom hint
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.zoom_in,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        // Image indicators
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedImageIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
        
        // Navigation buttons
        if (_selectedImageIndex > 0)
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () {
                  final pageController = PageController();
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        if (_selectedImageIndex < images.length - 1)
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () {
                  final pageController = PageController();
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  IconData _getImageTypeIcon(String type) {
    switch (type) {
      case 'model':
        return Icons.person_outline;
      case 'detail':
        return Icons.zoom_in;
      case 'texture':
        return Icons.texture;
      default:
        return Icons.image;
    }
  }

  String _getImageTypeLabel(String type) {
    switch (type) {
      case 'model':
        return 'صورة الموديل';
      case 'detail':
        return 'تفاصيل';
      case 'texture':
        return 'القماش';
      default:
        return 'صورة';
    }
  }

  void _showImageViewer(int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Stack(
          children: [
            // Image viewer
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: Center(
                child: Hero(
                  tag: 'product_image_$initialIndex',
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const Icon(Icons.image, size: 200),
                  ),
                ),
              ),
            ),
            
            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
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

  String? _selectedFit;
  String? _selectedStyle;

  Widget _buildVariantsSection() {
    final attributes = {
      'size': {
        'title': 'الحجم',
        'values': ['S', 'M', 'L', 'XL'],
        'showSizeGuide': true,
      },
      'color': {
        'title': 'اللون',
        'values': [
          {'name': 'أحمر', 'color': Colors.red},
          {'name': 'أزرق', 'color': Colors.blue},
          {'name': 'أخضر', 'color': Colors.green},
          {'name': 'أسود', 'color': Colors.black},
          {'name': 'أبيض', 'color': Colors.white},
        ],
        'isColor': true,
      },
      'fit': {
        'title': 'القصة',
        'values': ['عادية', 'ضيقة', 'واسعة', 'مريحة'],
      },
      'style': {
        'title': 'التصميم',
        'values': ['كاجوال', 'رسمي', 'رياضي', 'عصري'],
      },
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Size with guide button
        Row(
          children: [
            Text(
              attributes['size']!['title'] as String,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: _showSizeGuide,
              icon: const Icon(Icons.straighten, size: 18),
              label: Text('دليل المقاسات'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildAttributeChips(
          values: attributes['size']!['values'] as List,
          selected: _selectedSize,
          onSelected: (value) {
            setState(() {
              _selectedSize = value;
            });
          },
        ),
        const SizedBox(height: 16),
        
        // Colors with swatches
        Text(
          attributes['color']!['title'] as String,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _buildColorChips(
          colors: attributes['color']!['values'] as List,
          selected: _selectedColor,
          onSelected: (value) {
            setState(() {
              _selectedColor = value;
            });
          },
        ),
        const SizedBox(height: 16),
        
        // Fit
        Text(
          attributes['fit']!['title'] as String,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _buildAttributeChips(
          values: attributes['fit']!['values'] as List,
          selected: _selectedFit,
          onSelected: (value) {
            setState(() {
              _selectedFit = value;
            });
          },
        ),
        const SizedBox(height: 16),
        
        // Style
        Text(
          attributes['style']!['title'] as String,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _buildAttributeChips(
          values: attributes['style']!['values'] as List,
          selected: _selectedStyle,
          onSelected: (value) {
            setState(() {
              _selectedStyle = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAttributeChips({
    required List values,
    required String? selected,
    required void Function(String?) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((value) {
        final isSelected = selected == value;
        return FilterChip(
          label: Text(value.toString()),
          selected: isSelected,
          onSelected: (bool selected) {
            onSelected(selected ? value.toString() : null);
          },
          labelStyle: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onSecondaryContainer
                : Theme.of(context).colorScheme.onSurface,
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedColor: Theme.of(context).colorScheme.secondaryContainer,
          checkmarkColor: Theme.of(context).colorScheme.onSecondaryContainer,
        );
      }).toList(),
    );
  }

  Widget _buildColorChips({
    required List colors,
    required String? selected,
    required void Function(String?) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((colorData) {
        final isSelected = selected == colorData['name'];
        return FilterChip(
          label: Text(colorData['name']),
          selected: isSelected,
          avatar: CircleAvatar(
            backgroundColor: colorData['color'],
            radius: 8,
          ),
          onSelected: (bool selected) {
            onSelected(selected ? colorData['name'] : null);
          },
          labelStyle: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onSecondaryContainer
                : Theme.of(context).colorScheme.onSurface,
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedColor: Theme.of(context).colorScheme.secondaryContainer,
          checkmarkColor: Theme.of(context).colorScheme.onSecondaryContainer,
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
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
    final materialDetails = {
      'تكوين النسيج': '95% قطن، 5% ليكرا',
      'الموديل': 'طول الموديل 185 سم ويرتدي مقاس M',
      'بطانة': 'غير مبطن',
      'الشفافية': 'غير شفاف',
    };

    final careInstructions = [
      {'icon': Icons.local_laundry_service, 'text': 'غسيل بدرجة حرارة 30°'},
      {'icon': Icons.rotate_left, 'text': 'دوران منخفض'},
      {'icon': Icons.iron, 'text': 'كوي على درجة متوسطة'},
      {'icon': Icons.block, 'text': 'لا تستخدم المبيض'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text(
          'الوصف',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'هذا منتج عالي الجودة مصنوع من أفضل المواد. مناسب للاستخدام اليومي ويتميز بالمتانة والجودة العالية. يأتي مع ضمان لمدة سنة واحدة.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),

        // Material Details
        Text(
          'تفاصيل المنتج',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: materialDetails.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(':'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Care Instructions
        Text(
          'تعليمات العناية',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: careInstructions.map((instruction) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        instruction['icon'] as IconData,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          instruction['text'] as String,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
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

  Widget _buildCompleteLookSection() {
    // Mock data for suggested items
    final suggestedItems = [
      {
        'id': '1',
        'title': 'حذاء رياضي',
        'price': 45000.0,
        'image': 'shoes.jpg',
        'type': 'أحذية',
      },
      {
        'id': '2',
        'title': 'حقيبة جلد',
        'price': 35000.0,
        'image': 'bag.jpg',
        'type': 'إكسسوارات',
      },
      {
        'id': '3',
        'title': 'ساعة كلاسيكية',
        'price': 55000.0,
        'image': 'watch.jpg',
        'type': 'إكسسوارات',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'أكمل طلتك',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to suggested items collection
              },
              child: Text('عرض الكل'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: suggestedItems.length,
            itemBuilder: (context, index) {
              final item = suggestedItems[index];
              return Container(
                width: 180,
                margin: EdgeInsets.only(
                  right: index < suggestedItems.length - 1 ? 16 : 0,
                ),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      // Navigate to product detail
                      context.go('/products/${item['id']}');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        Container(
                          height: 180,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(Icons.image, size: 48),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item['type'] as String,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Product Info
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] as String,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${AppConfig.defaultCurrency} ${(item['price'] as double).toStringAsFixed(0)}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () {
                                    // Add to cart
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('تم إضافة ${item['title']} إلى السلة'),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add_shopping_cart, size: 16),
                                  label: const Text('أضف للسلة'),
                                  style: FilledButton.styleFrom(
                                    textStyle: Theme.of(context).textTheme.labelSmall,
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showSizeGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizeGuideSheet();
      },
    );
  }
}

class SizeGuideSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'دليل المقاسات',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const Divider(),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Instructions
                    Text(
                      'كيفية أخذ القياسات',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildMeasurementInstruction(
                      context,
                      'محيط الصدر',
                      'قم بقياس أوسع جزء من الصدر تحت الإبطين.',
                      Icons.accessibility_new,
                    ),
                    _buildMeasurementInstruction(
                      context,
                      'محيط الخصر',
                      'قم بقياس أضيق جزء من الخصر.',
                      Icons.straighten,
                    ),
                    _buildMeasurementInstruction(
                      context,
                      'محيط الورك',
                      'قم بقياس أوسع جزء من الورك.',
                      Icons.height,
                    ),
                    const SizedBox(height: 24),
                    
                    // Size Table
                    Text(
                      'جدول المقاسات',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('المقاس')),
                          DataColumn(label: Text('الصدر')),
                          DataColumn(label: Text('الخصر')),
                          DataColumn(label: Text('الورك')),
                        ],
                        rows: [
                          _buildSizeTableRow('S', '86-90', '68-72', '94-98'),
                          _buildSizeTableRow('M', '90-94', '72-76', '98-102'),
                          _buildSizeTableRow('L', '94-98', '76-80', '102-106'),
                          _buildSizeTableRow('XL', '98-102', '80-84', '106-110'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Notes
                    Text(
                      'ملاحظات',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '- جميع القياسات بالسنتيمتر\n'
                      '- القياسات تقريبية وقد تختلف حسب التصميم\n'
                      '- في حال كنت بين مقاسين، ننصح باختيار المقاس الأكبر'
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMeasurementInstruction(
    BuildContext context,
    String title,
    String instruction,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  instruction,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildSizeTableRow(String size, String chest, String waist, String hip) {
    return DataRow(cells: [
      DataCell(Text(size, style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(chest)),
      DataCell(Text(waist)),
      DataCell(Text(hip)),
    ]);
  }
}
