import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/theme/app_colors.dart';
import '../../products/models/product.dart';

class CategoryShowcase extends StatelessWidget {
  const CategoryShowcase({
    super.key,
    required this.title,
    required this.productsFuture,
    required this.textDirection,
  });

  final String title;
  final Future<List<Product>> productsFuture;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: Padding(padding: EdgeInsets.only(top: 64), child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 64),
              child: Text(
                'Nothing to show yet.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ),
          );
        }

        final products = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            _ShowcaseGrid(
              products: products,
              direction: textDirection,
            ),
          ],
        );
      },
    );
  }
}

class _ShowcaseGrid extends StatelessWidget {
  const _ShowcaseGrid({
    required this.products,
    required this.direction,
  });

  final List<Product> products;
  final TextDirection direction;

  static const List<_TileLayout> _pattern = [
    _TileLayout(widthSpan: 2, height: 320, slot: _EntrySlot.start),
    _TileLayout(widthSpan: 1, height: 200, slot: _EntrySlot.center),
    _TileLayout(widthSpan: 1, height: 200, slot: _EntrySlot.end),
    _TileLayout(widthSpan: 1, height: 240, slot: _EntrySlot.start),
    _TileLayout(widthSpan: 2, height: 260, slot: _EntrySlot.center),
    _TileLayout(widthSpan: 1, height: 220, slot: _EntrySlot.end),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isCompact = maxWidth < 720;
        final int columns = isCompact ? 2 : 3;
        final double spacing = isCompact ? 14 : 20;
        final double columnWidth = (maxWidth - spacing * (columns - 1)) / columns;

        final children = <Widget>[];

        for (var i = 0; i < products.length; i++) {
          final product = products[i];
          final layout = _pattern[i % _pattern.length].adaptForColumns(columns);
          final width = columnWidth * layout.widthSpan + spacing * (layout.widthSpan - 1);

          children.add(
            SizedBox(
              width: width,
              child: _ShowcaseTile(
                product: product,
                height: layout.height,
                slot: layout.slot,
                textDirection: direction,
              ),
            ),
          );
        }

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.center,
          children: children,
        );
      },
    );
  }
}

class _ShowcaseTile extends StatefulWidget {
  const _ShowcaseTile({
    required this.product,
    required this.height,
    required this.slot,
    required this.textDirection,
  });

  final Product product;
  final double height;
  final _EntrySlot slot;
  final TextDirection textDirection;

  @override
  State<_ShowcaseTile> createState() => _ShowcaseTileState();
}

class _ShowcaseTileState extends State<_ShowcaseTile> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _hasPlayed = false;
  Timer? _startDelay;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: _offsetFor(widget.slot, widget.textDirection),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _startDelay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(widget.product.id),
      onVisibilityChanged: (info) {
        if (!_hasPlayed && info.visibleFraction > 0.45) {
          _hasPlayed = true;
          _startDelay ??= Timer(const Duration(milliseconds: 80), () {
            if (mounted) _controller.forward();
          });
        }
      },
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildHeroImage(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${product.price.toStringAsFixed(0)} SYP',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (product.originalPrice != null)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Save ${(100 - (product.price / product.originalPrice! * 100)).round()}%',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    final String? imagePath = widget.product.images.isNotEmpty ? widget.product.images.first : null;
    if (imagePath == null) {
      return Container(color: AppColors.surfaceVariant);
    }
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
      );
    }
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.surfaceVariant,
        alignment: Alignment.center,
        child: const Icon(Icons.photo, color: Colors.white54, size: 36),
      ),
    );
  }

  Offset _offsetFor(_EntrySlot slot, TextDirection direction) {
    switch (slot) {
      case _EntrySlot.start:
        return direction == TextDirection.rtl ? const Offset(0.2, 0) : const Offset(-0.2, 0);
      case _EntrySlot.end:
        return direction == TextDirection.rtl ? const Offset(-0.2, 0) : const Offset(0.2, 0);
      case _EntrySlot.center:
        return const Offset(0, 0.16);
    }
  }
}

class _TileLayout {
  const _TileLayout({
    required this.widthSpan,
    required this.height,
    required this.slot,
  });

  final int widthSpan;
  final double height;
  final _EntrySlot slot;

  _TileLayout adaptForColumns(int columns) {
    if (widthSpan <= columns) return this;
    return _TileLayout(widthSpan: columns, height: height, slot: slot);
  }
}

enum _EntrySlot { start, center, end }
