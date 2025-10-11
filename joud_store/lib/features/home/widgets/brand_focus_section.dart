import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class BrandFocusSection extends StatelessWidget {
  const BrandFocusSection({super.key});

  static const _brands = [
    _BrandItem(
      name: 'Bath & Body Works',
      imageUrl:
          'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80',
    ),
    _BrandItem(
      name: 'SmallSaint',
      imageUrl:
          'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80',
    ),
    _BrandItem(
      name: 'Cath Kidston',
      imageUrl:
          'https://images.unsplash.com/photo-1456926631375-92c8ce872def?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80',
    ),
    _BrandItem(
      name: 'Laura Ashley',
      imageUrl:
          'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80',
    ),
    _BrandItem(
      name: 'By Ted Baker',
      imageUrl:
          'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80',
    ),
    _BrandItem(
      name: 'MADE',
      imageUrl:
          'https://images.unsplash.com/photo-1549187774-b4e9b0445b43?ixlib=rb-4.0.3&auto=format&fit=crop&w=1400&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brand Focus',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final brand = _brands[index];
              return _BrandCard(item: brand);
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: _brands.length,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Welcome to Joud Fashion, where style meets comfort! Explore our curated collection of ready, high-quality clothing for every occasion. Whether you\'re dressing up for a special event or looking for everyday essentials, our diverse range of styles ensures you\'ll find something to suit your unique taste. Shop now and experience fashion like never before!',
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _BrandCard extends StatelessWidget {
  const _BrandCard({required this.item});

  final _BrandItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceVariant,
                alignment: Alignment.center,
                child: Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.65),
                    Colors.black.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Center(
              child: Text(
                item.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandItem {
  const _BrandItem({required this.name, required this.imageUrl});

  final String name;
  final String imageUrl;
}
