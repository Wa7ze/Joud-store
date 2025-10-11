import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/router/app_router.dart';
import 'providers/category_provider.dart';
import 'models/category.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    final categoriesAsync = ref.watch(categoriesProvider);
    
    return ScreenScaffold(
      title: localizationService.getString('categories'),
      showBackButton: false,
      currentIndex: 1,
      showBottomNav: true,
      centerContent: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
      body: categoriesAsync.when(
        data: (categories) => _buildCategoriesGrid(categories),
        loading: () => const LoadingState(),
        error: (error, stack) => ErrorState(message: error.toString()),
      ),
    );
  }

  Widget _buildCategoriesGrid(List<Category> categories) {
    final Map<String, IconData> iconMap = {
      'man': Icons.man,
      'woman': Icons.woman,
      'child_care': Icons.child_care,
      'business': Icons.business_center,
      'sports': Icons.sports_soccer,
      'diamond': Icons.diamond,
      'event': Icons.event,
    };

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Featured Categories
        SliverToBoxAdapter(
          child: Container(
            height: 180,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                _buildFeaturedCard(
                  context,
                  categories.firstWhere((c) => c.id == 'womens'),
                  flex: 2,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      _buildFeaturedCard(
                        context,
                        categories.firstWhere((c) => c.id == 'mens'),
                        height: 86,
                      ),
                      const SizedBox(height: 8),
                      _buildFeaturedCard(
                        context,
                        categories.firstWhere((c) => c.id == 'kids'),
                        height: 86,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Section Title
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'جميع الفئات',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),

        // All Categories Grid
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = categories[index];
                return _buildCategoryCard(context, category, iconMap);
              },
              childCount: categories.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildFeaturedCard(
    BuildContext context,
    Category category, {
    double? height,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () => _showSubcategories(context, category),
        child: Container(
          height: height,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(category.image ?? 
                'https://picsum.photos/200/300?random=${category.id}'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                category.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (category.productCount > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '${category.productCount} منتج',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Category category,
    Map<String, IconData> iconMap,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showSubcategories(context, category),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    iconMap[category.icon] ?? Icons.category,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  category.productCount > 0
                      ? '${category.productCount} منتج'
                      : '${category.subcategories.length} فئات فرعية',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSubcategories(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Column(
          children: [
            // Handle bar and header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Title and stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            if (category.description != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                category.description!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${category.productCount} منتج',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Subcategories grid
            Expanded(
              child: GridView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: category.subcategories.length + 1, // +1 for "View All"
                itemBuilder: (context, index) {
                  if (index == category.subcategories.length) {
                    return _buildSubcategoryCard(
                      context,
                      title: 'عرض الكل',
                      icon: Icons.grid_view_rounded,
                      onTap: () {
                        Navigator.pop(context);
                        context.go('${AppRouter.productList}?categoryId=${category.id}');
                      },
                      isViewAll: true,
                    );
                  }
                  
                  final subcategory = category.subcategories[index];
                  return _buildSubcategoryCard(
                    context,
                    title: subcategory,
                    icon: Icons.category_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      context.go('${AppRouter.productList}?categoryId=${category.id}&subcategory=$subcategory');
                    },
                  );
                },
              ),
            ),
            ],
          ),
        ),
      );
  }

  Widget _buildSubcategoryCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isViewAll = false,
  }) {
    return Card(
      elevation: 0,
      color: isViewAll
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isViewAll
            ? BorderSide.none
            : BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isViewAll
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isViewAll
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isViewAll ? FontWeight.bold : null,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleScroll() {
    if (!_scrollController.hasClients || !_scrollController.position.hasContentDimensions) return;
    final maxExtent = _scrollController.position.maxScrollExtent;
    final shouldShow = maxExtent > 0 && _scrollController.offset >= maxExtent * 0.5;
    if (shouldShow != _showScrollToTop) {
      setState(() => _showScrollToTop = shouldShow);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
    setState(() => _showScrollToTop = false);
  }
}
