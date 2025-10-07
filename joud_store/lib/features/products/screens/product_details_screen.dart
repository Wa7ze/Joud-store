import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${product.id}',
                child: PageView.builder(
                  itemCount: product.images.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      product.images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          // Product Details
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Title and Brand
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: theme.textTheme.headlineSmall,
                          ),
                          if (product.brand != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              product.brand!,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Rating
                    if (product.rating > 0)
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.rating.toString(),
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          if (product.reviewCount > 0)
                            Text(
                              '${product.reviewCount} مراجعة',
                              style: theme.textTheme.bodySmall,
                            ),
                        ],
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${product.price} ريال',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (product.originalPrice != null &&
                        product.originalPrice! > product.price) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${product.originalPrice} ريال',
                        style: theme.textTheme.titleMedium?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${((1 - product.price / product.originalPrice!) * 100).round()}% خصم',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  product.description,
                  style: theme.textTheme.bodyLarge,
                ),

                const SizedBox(height: 24),

                // Details Section
                Text(
                  'تفاصيل المنتج',
                  style: theme.textTheme.titleLarge,
                ),

                const SizedBox(height: 16),

                // Product Details Grid
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    if (product.material != null)
                      _DetailItem(
                        icon: Icons.texture,
                        label: 'الخامة',
                        value: product.material!,
                      ),
                    if (product.fit != null)
                      _DetailItem(
                        icon: Icons.straighten,
                        label: 'القصة',
                        value: product.fit!,
                      ),
                    if (product.style != null)
                      _DetailItem(
                        icon: Icons.style,
                        label: 'الستايل',
                        value: product.style!,
                      ),
                    if (product.season != null)
                      _DetailItem(
                        icon: Icons.wb_sunny,
                        label: 'الموسم',
                        value: product.season!,
                      ),
                  ],
                ),

                if (product.measurements.isNotEmpty) ...[
                  const SizedBox(height: 24),

                  // Measurements Section
                  Text(
                    'القياسات',
                    style: theme.textTheme.titleLarge,
                  ),

                  const SizedBox(height: 16),

                  // Measurements Grid
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (var entry in product.measurements.entries)
                        _DetailItem(
                          icon: Icons.straighten,
                          label: entry.key,
                          value: entry.value,
                        ),
                    ],
                  ),
                ],

                if (product.modelSize != null || product.modelHeight != null) ...[
                  const SizedBox(height: 24),

                  // Model Information Section
                  Text(
                    'معلومات الموديل',
                    style: theme.textTheme.titleLarge,
                  ),

                  const SizedBox(height: 16),

                  // Model Details
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      if (product.modelSize != null)
                        _DetailItem(
                          icon: Icons.straighten,
                          label: 'مقاس الموديل',
                          value: product.modelSize!,
                        ),
                      if (product.modelHeight != null)
                        _DetailItem(
                          icon: Icons.height,
                          label: 'طول الموديل',
                          value: product.modelHeight!,
                        ),
                    ],
                  ),
                ],

                if (product.careInstructions.isNotEmpty) ...[
                  const SizedBox(height: 24),

                  // Care Instructions Section
                  Text(
                    'تعليمات العناية',
                    style: theme.textTheme.titleLarge,
                  ),

                  const SizedBox(height: 16),

                  // Care Instructions List
                  Column(
                    children: [
                      for (var instruction in product.careInstructions)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  instruction,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: product.isInStock
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement add to cart
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'إضافة إلى السلة',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'غير متوفر حالياً',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}