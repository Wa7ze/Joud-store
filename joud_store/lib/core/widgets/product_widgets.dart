import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final int count;
  final Color? color;

  const RatingStars({
    Key? key,
    required this.rating,
    this.size = 20,
    this.count = 5,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final starValue = index + 1;
        final isHalf = rating > index && rating < starValue;
        final isFull = rating >= starValue;

        return Icon(
          isFull
              ? Icons.star
              : isHalf
                  ? Icons.star_half
                  : Icons.star_border,
          size: size,
          color: color ?? Colors.amber,
        );
      }),
    );
  }
}

class PriceWidget extends StatelessWidget {
  final double price;
  final double? compareAtPrice;
  final bool showCurrency;
  final TextStyle? priceStyle;
  final TextStyle? compareAtPriceStyle;

  const PriceWidget({
    Key? key,
    required this.price,
    this.compareAtPrice,
    this.showCurrency = true,
    this.priceStyle,
    this.compareAtPriceStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDiscount = compareAtPrice != null && compareAtPrice! > price;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          showCurrency ? '$price SYP' : price.toString(),
          style: (priceStyle ?? theme.textTheme.titleLarge)?.copyWith(
            color: hasDiscount ? DesignTokens.errorColor : null,
            fontWeight: DesignTokens.fontWeightBold,
          ),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: DesignTokens.spacing2),
          Text(
            showCurrency ? '$compareAtPrice SYP' : compareAtPrice.toString(),
            style: (compareAtPriceStyle ?? theme.textTheme.bodyMedium)?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: theme.disabledColor,
            ),
          ),
        ],
      ],
    );
  }
}
