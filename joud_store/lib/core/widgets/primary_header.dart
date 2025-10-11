import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PrimaryHeader extends StatefulWidget {
  const PrimaryHeader({
    super.key,
    this.searchController,
    this.onSearchSubmitted,
    this.onSearchIconPressed,
    this.onBrandTap,
    this.onGlobeTap,
    this.onCurrencyTap,
    this.onCartTap,
    this.onFavoritesTap,
    this.onProfileTap,
    this.onSettingsTap,
    this.searchHint = 'Search Here',
    this.showSearchBar = true,
    this.showActionIcons = true,
  });

  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchIconPressed;
  final VoidCallback? onBrandTap;
  final VoidCallback? onGlobeTap;
  final VoidCallback? onCurrencyTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onFavoritesTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final String searchHint;
  final bool showSearchBar;
  final bool showActionIcons;

  @override
  State<PrimaryHeader> createState() => _PrimaryHeaderState();
}

class _PrimaryHeaderState extends State<PrimaryHeader> {
  static const List<String> _messages = [
    'Shop exclusive collections for every occasion.',
    'Get the best deals on your favorite brands.',
    'Refresh your style with our handpicked selection.',
    'Discover the latest fashion trends.',
    'Enjoy fast shipping and unbeatable prices.',
    'Find statement pieces for every season.',
    'Elevate your everyday essentials in style.',
  ];

  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _ownsController = false;
  bool _hasFocus = false;
  int _messageIndex = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _controller = widget.searchController ?? TextEditingController();
    _ownsController = widget.searchController == null;
    _focusNode = FocusNode()..addListener(_handleFocusChange);
    _startBannerRotation();
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    if (_ownsController) {
      _controller.dispose();
    }
    _bannerTimer?.cancel();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  void _startBannerRotation() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      setState(() {
        _messageIndex = (_messageIndex + 1) % _messages.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: kPrimaryGradient),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 16, right: 16),
              child: SizedBox(
                height: 22,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  transitionBuilder: (child, animation) {
                    final offsetTween = Tween<Offset>(
                      begin: const Offset(0.0, 0.35),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
                    return ClipRect(
                      child: SlideTransition(
                        position: offsetTween,
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                    );
                  },
                  child: Text(
                    _messages[_messageIndex],
                    key: ValueKey(_messageIndex),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.headerBackground,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final bool isCompact = width < 760;
                    final bool isUltraCompact = width < 540;

                    if (isCompact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _BrandMark(onTap: widget.onBrandTap),
                              if (widget.showActionIcons) ...[
                                const Spacer(),
                                _IconRow(
                                  onGlobeTap: widget.onGlobeTap,
                                  onCurrencyTap: widget.onCurrencyTap,
                                  onCartTap: widget.onCartTap,
                                  onFavoritesTap: widget.onFavoritesTap,
                                  onProfileTap: widget.onProfileTap,
                                  onSettingsTap: widget.onSettingsTap,
                                ),
                              ],
                            ],
                          ),
                          if (widget.showSearchBar) ...[
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.center,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: isUltraCompact ? width : width * 0.92,
                                ),
                                child: _SearchField(
                                  controller: _controller,
                                  focusNode: _focusNode,
                                  hasFocus: _hasFocus,
                                  hintText: widget.searchHint,
                                  onSubmitted: widget.onSearchSubmitted,
                                  onSearchIconPressed: widget.onSearchIconPressed,
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    }

                    final double searchMaxWidth = width * 0.6;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _BrandMark(onTap: widget.onBrandTap),
                        if (widget.showSearchBar) const SizedBox(width: 24),
                        if (widget.showSearchBar)
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: searchMaxWidth.clamp(360.0, 620.0),
                                ),
                                child: _SearchField(
                                  controller: _controller,
                                  focusNode: _focusNode,
                                  hasFocus: _hasFocus,
                                  hintText: widget.searchHint,
                                  onSubmitted: widget.onSearchSubmitted,
                                  onSearchIconPressed: widget.onSearchIconPressed,
                                  ),
                                ),
                              ),
                            )
                        else
                          const Spacer(),
                        if (widget.showActionIcons) ...[
                          const SizedBox(width: 24),
                          _IconRow(
                            onGlobeTap: widget.onGlobeTap,
                            onCurrencyTap: widget.onCurrencyTap,
                            onCartTap: widget.onCartTap,
                            onFavoritesTap: widget.onFavoritesTap,
                            onProfileTap: widget.onProfileTap,
                            onSettingsTap: widget.onSettingsTap,
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final logoText = Text(
      'Joud',
      style: textTheme.headlineSmall?.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w900,
            fontSize: (textTheme.headlineSmall?.fontSize ?? 18) + 6,
            letterSpacing: 0.8,
          ),
    );

    if (onTap == null) {
      return logoText;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: AppColors.accent.withValues(alpha: 0.15),
        highlightColor: AppColors.accent.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: logoText,
        ),
      ),
    );
  }
}

class _IconRow extends StatelessWidget {
  const _IconRow({
    this.onGlobeTap,
    this.onCurrencyTap,
    this.onCartTap,
    this.onFavoritesTap,
    this.onProfileTap,
    this.onSettingsTap,
  });

  final VoidCallback? onGlobeTap;
  final VoidCallback? onCurrencyTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onFavoritesTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        _HeaderIconButton(icon: Icons.public, onTap: onGlobeTap),
        _HeaderIconButton(icon: Icons.attach_money, onTap: onCurrencyTap),
        _HeaderIconButton(icon: Icons.shopping_cart_outlined, onTap: onCartTap),
        _HeaderIconButton(icon: Icons.favorite_border, onTap: onFavoritesTap),
        _HeaderIconButton(icon: Icons.settings_outlined, onTap: onSettingsTap),
        _HeaderIconButton(icon: Icons.person_outline, onTap: onProfileTap),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.hasFocus,
    required this.hintText,
    this.onSubmitted,
    this.onSearchIconPressed,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasFocus;
  final String hintText;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSearchIconPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: hasFocus ? AppColors.accent : AppColors.outline,
          width: hasFocus ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: hasFocus ? 0.14 : 0.04),
            blurRadius: hasFocus ? 14 : 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            color: AppColors.icon,
            onPressed: () {
              if (onSearchIconPressed != null) {
                onSearchIconPressed!();
              } else if (onSubmitted != null) {
                onSubmitted!(controller.text);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatefulWidget {
  const _HeaderIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<_HeaderIconButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.92 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: widget.onTap,
          onTapDown: (_) => _setPressed(true),
          onTapCancel: () => _setPressed(false),
          onTapUp: (_) => _setPressed(false),
          splashColor: AppColors.accent.withValues(alpha: 0.12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(widget.icon, color: AppColors.icon, size: 22),
          ),
        ),
      ),
    );
  }
}
