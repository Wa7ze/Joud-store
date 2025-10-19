import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CategoryNavBar extends StatefulWidget {
  const CategoryNavBar({
    super.key,
    required this.categories,
    this.initialIndex = 0,
    this.onCategorySelected,
    this.selectedIndex,
  });

  final List<String> categories;
  final int initialIndex;
  final ValueChanged<int>? onCategorySelected;
  final int? selectedIndex;

  @override
  State<CategoryNavBar> createState() => _CategoryNavBarState();
}

class _CategoryNavBarState extends State<CategoryNavBar> {
  int? _selectedIndex;

  bool get _isControlled => widget.selectedIndex != null;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _normalize(widget.selectedIndex ?? widget.initialIndex);
  }

  @override
  void didUpdateWidget(covariant CategoryNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      setState(() {
        _selectedIndex = _normalize(widget.selectedIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: kPrimaryGradient),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 840 ? 32 : 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth - 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.categories.length, (index) {
                  final isSelected = _selectedIndex != null && index == _selectedIndex;
                  final label = widget.categories[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _CategoryTab(
                      label: label,
                      isSelected: isSelected,
                      onTap: () => _handleTap(index),
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleTap(int index) {
    if (_selectedIndex == index && _isControlled) {
      widget.onCategorySelected?.call(index);
      return;
    }

    if (!_isControlled) {
      setState(() => _selectedIndex = index);
    }

    widget.onCategorySelected?.call(index);
  }

  int? _normalize(int? index) {
    if (index == null || index < 0) return null;
    final maxIndex = widget.categories.length - 1;
    return index.clamp(0, maxIndex);
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.white24,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: 3,
              width: 28,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
