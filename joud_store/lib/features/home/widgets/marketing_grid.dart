import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MarketingGrid extends StatelessWidget {
  const MarketingGrid({super.key});

  static const List<_MarketingItem> _items = [
    _MarketingItem(
      title: 'New season favorites',
      imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=1400&q=80',
    ),
    _MarketingItem(
      title: 'Fun bold brights',
      imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1400&q=80',
    ),
    _MarketingItem(
      title: 'Trending animal print',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1400&q=80',
    ),
    _MarketingItem(
      title: 'Studio essentials',
      imageUrl: 'https://images.unsplash.com/photo-1505156868547-9b49f4df4e4e?auto=format&fit=crop&w=1400&q=80',
    ),
    _MarketingItem(
      title: 'Effortless layers',
      imageUrl: 'https://images.unsplash.com/photo-1521572188048-9bce0fe1467a?auto=format&fit=crop&w=1400&q=80',
    ),
    _MarketingItem(
      title: 'Beauty spotlight',
      imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=1400&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final bool isSmall = width < 720;
        final bool isMedium = width < 1080;
        final int crossAxisCount = isSmall ? 1 : (isMedium ? 2 : 3);
        final double spacing = isSmall ? 16 : 20;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: isSmall ? 1.1 : 0.95,
          ),
          itemBuilder: (context, index) {
            final item = _items[index];
            final position = _resolvePosition(index, crossAxisCount);
            return _MarketingCard(
              item: item,
              position: position,
            );
          },
        );
      },
    );
  }

  _CardPosition _resolvePosition(int index, int crossAxisCount) {
    if (crossAxisCount == 1) {
      return _CardPosition.center;
    }
    final column = index % crossAxisCount;
    if (crossAxisCount == 2) {
      return column == 0 ? _CardPosition.left : _CardPosition.right;
    }
    if (column == 0) return _CardPosition.left;
    if (column == crossAxisCount - 1) return _CardPosition.right;
    return _CardPosition.center;
  }
}

class _MarketingCard extends StatefulWidget {
  const _MarketingCard({
    required this.item,
    required this.position,
  });

  final _MarketingItem item;
  final _CardPosition position;

  @override
  State<_MarketingCard> createState() => _MarketingCardState();
}

class _MarketingCardState extends State<_MarketingCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;
  Timer? _delayedStart;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: _initialOffset(widget.position),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _delayedStart?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(widget.item.title),
      onVisibilityChanged: (info) {
        if (!_hasAnimated && info.visibleFraction > 0.45) {
          _hasAnimated = true;
          _delayedStart ??= Timer(Duration(milliseconds: widget.position == _CardPosition.center ? 100 : 0), () {
            if (mounted) {
              _controller.forward();
            }
          });
        }
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.item.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.55),
                          Colors.black.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Text(
                        widget.item.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Offset _initialOffset(_CardPosition position) {
    switch (position) {
      case _CardPosition.left:
        return const Offset(-0.18, 0.0);
      case _CardPosition.right:
        return const Offset(0.18, 0.0);
      case _CardPosition.center:
        return const Offset(0.0, 0.16);
    }
  }
}

class _MarketingItem {
  const _MarketingItem({
    required this.title,
    required this.imageUrl,
  });

  final String title;
  final String imageUrl;
}

enum _CardPosition { left, center, right }
