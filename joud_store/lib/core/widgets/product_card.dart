import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double price;
  final double? compareAtPrice;
  final VoidCallback? onTap;
  final bool isInStock;

  const ProductCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.compareAtPrice,
    this.onTap,
    this.isInStock = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDiscount = compareAtPrice != null && compareAtPrice! > price;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          boxShadow: DesignTokens.shadowSmall,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Discount Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(DesignTokens.radiusMedium),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.disabledColor.withOpacity(0.1),
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: DesignTokens.spacing2,
                    right: DesignTokens.spacing2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacing2,
                        vertical: DesignTokens.spacing1,
                      ),
                      decoration: BoxDecoration(
                        color: DesignTokens.errorColor,
                        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                      ),
                      child: Text(
                        '-${((compareAtPrice! - price) / compareAtPrice! * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: DesignTokens.fontWeightBold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Product Info
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacing3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: DesignTokens.spacing2),
                  Row(
                    children: [
                      Text(
                        '$price SYP',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: DesignTokens.primaryColor,
                          fontWeight: DesignTokens.fontWeightBold,
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: DesignTokens.spacing2),
                        Text(
                          '$compareAtPrice SYP',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: theme.disabledColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!isInStock)
                    Padding(
                      padding: const EdgeInsets.only(top: DesignTokens.spacing2),
                      child: Text(
                        'Out of Stock',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: DesignTokens.errorColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
