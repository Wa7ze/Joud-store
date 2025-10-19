import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cart/providers/cart_provider.dart';
import '../../../core/widgets/ui_states.dart';
import '../../../core/widgets/page_container.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../products/models/product.dart';
import '../../products/services/product_service.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/localization/localization_service.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
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
      body: SingleChildScrollView(
        child: PageContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: heroImage == null
                      ? Container(
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 48,
                          ),
                        )
                      : Image.network(
                          heroImage,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 48,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                product.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    CurrencyUtils.format(product.price),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (hasDiscount) ...[
                    const SizedBox(width: 12),
                    Text(
                      CurrencyUtils.format(product.originalPrice!),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 24),
              if (sizes?.isNotEmpty ?? false) ...[
                _buildSectionTitle(
                  context,
                  '???? ??????',
                  trailing: TextButton.icon(
                    onPressed: () => _showSizeGuide(context),
                    icon: const Icon(Icons.straighten, size: 18),
                    label: const Text('???? ????????'),
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
                          onSelected: (_) =>
                              setState(() => _selectedSize = size),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
              ],
              if (colors?.isNotEmpty ?? false) ...[
                _buildSectionTitle(context, '???? ?????'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: colors!
                      .map(
                        (color) => ChoiceChip(
                          label: Text(color),
                          selected: _selectedColor == color,
                          onSelected: (_) =>
                              setState(() => _selectedColor = color),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
              ],
              if (product.description.isNotEmpty) ...[
                _buildSectionTitle(context, '?????'),
                Text(product.description, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 24),
              ],
              _buildSectionTitle(context, '?????? ??????'),
              _buildDetailRow(context, '???????', product.brand ?? '??? ?????'),
              _buildDetailRow(
                context,
                '??????',
                product.material ?? '??? ?????',
              ),
              _buildDetailRow(context, '???????', product.fit ?? '??? ?????'),
              _buildDetailRow(context, '??????', product.season ?? '??? ?????'),
              if (product.measurements?.isNotEmpty ?? false) ...[
                const SizedBox(height: 16),
                _buildSectionTitle(context, '????????'),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: product.measurements!.entries
                      .map(
                        (entry) =>
                            Chip(label: Text('${entry.key}: ${entry.value}')),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
              ],
              if (product.careInstructions?.isNotEmpty ?? false) ...[
                _buildSectionTitle(context, '??????? ???????'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: product.careInstructions!
                      .map(
                        (instruction) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(_careIconFor(instruction), size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text(instruction)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
              ],
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSectionTitle(context, '?? ????? ?????'),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.68,
                            ),
                        itemCount: products.length,
                        itemBuilder: (context, index) =>
                            ProductCard(product: products[index]),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(cartProvider.notifier)
                      .addCustomItem(
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
                    const SnackBar(content: Text('??? ????? ?????? ??? ?????')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('????? ??? ?????'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final localization = LocalizationService.instance;
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: () {},
            child: Text(localization.getString('productAddToCartButton')),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            child: Text(localization.getString('productAddToFavouritesButton')),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title, {
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
    if (lower.contains('wash') || lower.contains('???')) {
      return Icons.local_laundry_service;
    }
    if (lower.contains('dry') || lower.contains('?????')) {
      return Icons.waves;
    }
    if (lower.contains('iron') || lower.contains('??')) {
      return Icons.iron;
    }
    if (lower.contains('bleach') || lower.contains('????')) {
      return Icons.block;
    }
    return Icons.info_outline;
  }

  void _showSizeGuide(BuildContext context) {
    final data = _sizeGuideFor(
      widget.product.categoryId ?? '',
      widget.product.subcategory ?? '',
    );
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
              Text(
                '???? ????????',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...data.map(
                (row) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('${row[0]} - ${row[1]}'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '???????? ??????? ??? ????? ??? ??? ?????? ????????.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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
        ['XS', '????? 80 ?? - ????? 62 ??'],
        ['S', '????? 84 ?? - ????? 66 ??'],
        ['M', '????? 88 ?? - ????? 70 ??'],
        ['L', '????? 92 ?? - ????? 74 ??'],
        ['XL', '????? 96 ?? - ????? 78 ??'],
      ];
    }
    if (categoryId == 'kids') {
      return const [
        ['2', '????? 92 ??'],
        ['4', '????? 104 ??'],
        ['6', '????? 116 ??'],
        ['8', '????? 128 ??'],
        ['10', '????? 140 ??'],
      ];
    }
    return const [
      ['S', '????? 92 ?? - ????? 78 ??'],
      ['M', '????? 96 ?? - ????? 82 ??'],
      ['L', '????? 100 ?? - ????? 86 ??'],
      ['XL', '????? 106 ?? - ????? 92 ??'],
      ['2XL', '????? 112 ?? - ????? 98 ??'],
    ];
  }
}
