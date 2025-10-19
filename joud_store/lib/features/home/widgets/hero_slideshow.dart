import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class HeroSlideshow extends StatefulWidget {
  const HeroSlideshow({super.key});

  @override
  State<HeroSlideshow> createState() => _HeroSlideshowState();
}

class _HeroSlideshowState extends State<HeroSlideshow> {
  static const _autoPlayInterval = Duration(seconds: 3);
  final PageController _pageController = PageController();

  Timer? _autoPlayTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(_autoPlayInterval, (_) {
      final nextPage = (_currentIndex + 1) % _slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        final isTablet = width < 1024;
        final height = isMobile
            ? 260.0
            : isTablet
                ? 320.0
                : 420.0;

        return SizedBox(
          height: height,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                  _startAutoPlay();
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 18,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              slide.imageUrl,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.85),
                                    Colors.white.withValues(alpha: 0.35),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 16 : 32,
                                  vertical: isMobile ? 24 : 32,
                                ),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: isMobile
                                        ? width * 0.7
                                        : isTablet
                                            ? width * 0.45
                                            : width * 0.35,
                                  ),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 400),
                                    transitionBuilder: (child, animation) {
                                      final fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                                      final slideAnimation = Tween<Offset>(
                                        begin: const Offset(-0.05, 0.08),
                                        end: Offset.zero,
                                      ).animate(fade);
                                      return FadeTransition(
                                        opacity: fade,
                                        child: SlideTransition(
                                          position: slideAnimation,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: _SlideText(
                                      key: ValueKey(slide.title),
                                      slide: slide,
                                      isMobile: isMobile,
                                    ),
                                  ),
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
              Positioned(
                bottom: 24,
                child: Row(
                  children: List.generate(_slides.length, (index) {
                    final isActive = index == _currentIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: isActive ? 20 : 8,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SlideText extends StatelessWidget {
  const _SlideText({
    super.key,
    required this.slide,
    required this.isMobile,
  });

  final _HeroSlide slide;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          slide.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            overlayColor: AppColors.accent.withValues(alpha: 0.1),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            slide.callToAction,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  decoration: TextDecoration.underline,
                  decorationThickness: 1.2,
                  letterSpacing: 0.6,
                ),
          ),
        ),
      ],
    );
  }
}

class _HeroSlide {
  const _HeroSlide({
    required this.title,
    required this.callToAction,
    required this.imageUrl,
  });

  final String title;
  final String callToAction;
  final String imageUrl;
}

const List<_HeroSlide> _slides = [
  _HeroSlide(
    title: 'THE DENIM EDIT',
    callToAction: "SHOP WOMEN'S",
    imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1600&q=80',
  ),
  _HeroSlide(
    title: 'AUTUMN LAYERS',
    callToAction: 'SHOP MEN',
    imageUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=1600&q=80',
  ),
  _HeroSlide(
    title: 'MINI STYLE ICONS',
    callToAction: 'SHOP KIDS',
    imageUrl: 'https://images.unsplash.com/photo-1487412912498-0447578fcca8?auto=format&fit=crop&w=1600&q=80',
  ),
];
