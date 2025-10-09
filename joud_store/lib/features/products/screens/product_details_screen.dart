import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cart/providers/cart_provider.dart';
import '../../../core/widgets/ui_states.dart';
import '../../../core/config/app_config.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/product_card.dart';
import '../../products/models/product.dart';
import '../../products/services/product_service.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  String? _selectedSize;
  String? _selectedColor;
  late Future<List<Product>> _recommendedFuture;

  @override
  void initState() {
    super.initState();
    _recommendedFuture = _loadRecommended();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final hasDiscount =
        product.originalPrice != null && product.originalPrice! > product.price;
    final images = product.images;
    final heroImage = images.isNotEmpty ? images.first : null;

    final sizes = product.options['size'];
    final colors = product.options['color'];
    _selectedSize ??= sizes?.isNotEmpty == true ? sizes!.first : null;
    _selectedColor ??= colors?.isNotEmpty == true ? colors!.first : null;

    return ScreenScaffold(
      title: product.name,
      showBackButton: true,
      currentIndex: 0,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: heroImage == null
                      ? Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported, size: 48),
                        )
                      : Image.network(
                          heroImage,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported, size: 48),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.name,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${product.price.toStringAsFixed(0)} ${AppConfig.defaultCurrency}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (hasDiscount) ...[
                    const SizedBox(width: 12),
                    Text(
                      '${product.originalPrice!.toStringAsFixed(0)} ${AppConfig.defaultCurrency}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              if (sizes?.isNotEmpty ?? false) ...[
                _buildSectionTitle(
                  context,
                  'اختر المقاس',
                  trailing: TextButton.icon(
                    onPressed: () => _showSizeGuide(context),
                    icon: const Icon(Icons.straighten, size: 18),
                    label: const Text('دليل المقاسات'),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: sizes!
                      .map(
                        (size) => ChoiceChip(
                          label: Text(size),
                          selected: _selectedSize == size,
                          onSelected: (_) => setState(() => _selectedSize = size),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
              if (colors?.isNotEmpty ?? false) ...[
                _buildSectionTitle(context, 'اختر اللون'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: colors!
                      .map(
                        (color) => ChoiceChip(
                          label: Text(color),
                          selected: _selectedColor == color,
                          onSelected: (_) => setState(() => _selectedColor = color),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
              if (product.description.isNotEmpty) ...[
                _buildSectionTitle(context, 'الوصف'),
                Text(product.description, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 16),
              ],
              _buildSectionTitle(context, 'تفاصيل المنتج'),
              _buildDetailRow(context, 'الماركة', product.brand ?? 'غير متوفر'),
              _buildDetailRow(context, 'الخامة', product.material ?? 'غير متوفر'),
              _buildDetailRow(context, 'القَصّة', product.fit ?? 'غير متوفر'),
              _buildDetailRow(context, 'الموسم', product.season ?? 'غير متوفر'),
              if (product.measurements?.isNotEmpty ?? false) ...[
                const SizedBox(height: 16),
                _buildSectionTitle(context, 'المقاسات'),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: product.measurements!.entries
                      .map(
                        (entry) => Chip(
                          label: Text('${entry.key}: ${entry.value}'),
                        ),
                      )
                      .toList(),
                ),
              ],
              if (product.careInstructions?.isNotEmpty ?? false) ...[
                const SizedBox(height: 16),
                _buildSectionTitle(context, 'تعليمات العناية'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: product.careInstructions!
                      .map((instruction) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(_careIconFor(instruction), size: 20),
                                const SizedBox(width: 8),
                                Expanded(child: Text(instruction)),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ],
              const SizedBox(height: 24),
              FutureBuilder<List<Product>>(
                future: _recommendedFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox.shrink();
                  }
                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(context, 'قد يعجبك أيضاً'),
                      SizedBox(
                        height: 270,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = products[index];
                            return SizedBox(
                              width: 180,
                              child: ProductCard(
                                product: item,
                                onTap: () => context.go('${AppRouter.productDetail}/${item.id}'),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).addCustomItem(
                        productId: product.id,
                        name: product.name,
                        price: product.price,
                        originalPrice: product.originalPrice,
                        imageUrl: heroImage,
                        size: _selectedSize,
                        color: _selectedColor,
                        quantity: 1,
                      );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تمت إضافة المنتج إلى السلة')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text('إضافة إلى السلة'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Future<List<Product>> _loadRecommended() async {
    final product = widget.product;
    final service = ProductService();
    final results = await service.getProducts(
      categoryId: product.categoryId,
      styles: product.style != null ? [product.style!] : null,
      pageSize: 10,
    );
    return results.where((p) => p.id != product.id).take(8).toList();
  }

  IconData _careIconFor(String instruction) {
    final lower = instruction.toLowerCase();
    if (lower.contains('wash') || lower.contains('غسل')) {
      return Icons.local_laundry_service;
    }
    if (lower.contains('dry') || lower.contains('تجفيف')) {
      return Icons.waves;
    }
    if (lower.contains('iron') || lower.contains('كي')) {
      return Icons.iron;
    }
    if (lower.contains('bleach') || lower.contains('مبيض')) {
      return Icons.block;
    }
    return Icons.info_outline;
  }

  void _showSizeGuide(BuildContext context) {
    final data = _sizeGuideFor(widget.product.categoryId ?? '', widget.product.subcategory ?? '');
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('دليل المقاسات', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ...data.map(
                (row) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('${row[0]} — ${row[1]}'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'المقاسات تقريبية وقد تختلف حسب نوع القماش والموديل.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        );
      },
    );
  }

  List<List<String>> _sizeGuideFor(String categoryId, String subcategory) {
    if (categoryId == 'women') {
      return const [
        ['XS', 'الصدر 80 سم - الخصر 62 سم'],
        ['S', 'الصدر 84 سم - الخصر 66 سم'],
        ['M', 'الصدر 88 سم - الخصر 70 سم'],
        ['L', 'الصدر 92 سم - الخصر 74 سم'],
        ['XL', 'الصدر 96 سم - الخصر 78 سم'],
      ];
    }
    if (categoryId == 'kids') {
      return const [
        ['2', 'الطول 92 سم'],
        ['4', 'الطول 104 سم'],
        ['6', 'الطول 116 سم'],
        ['8', 'الطول 128 سم'],
        ['10', 'الطول 140 سم'],
      ];
    }
    return const [
      ['S', 'الصدر 92 سم - الخصر 78 سم'],
      ['M', 'الصدر 96 سم - الخصر 82 سم'],
      ['L', 'الصدر 100 سم - الخصر 86 سم'],
      ['XL', 'الصدر 106 سم - الخصر 92 سم'],
      ['2XL', 'الصدر 112 سم - الخصر 98 سم'],
    ];
  }
}
