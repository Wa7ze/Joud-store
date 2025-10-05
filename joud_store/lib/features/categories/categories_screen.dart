import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
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
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    final categoriesAsync = ref.watch(categoriesProvider);
    
    return ScreenScaffold(
      title: localizationService.getString('categories'),
      body: categoriesAsync.when(
        data: (categories) => _buildCategoriesGrid(categories),
        loading: () => const LoadingState(),
        error: (error, stack) => ErrorState(message: error.toString()),
      ),
    );
  }

  Widget _buildCategoriesGrid(List<Category> categories) {
    final Map<String, IconData> iconMap = {
      'devices': Icons.devices,
      'checkroom': Icons.checkroom,
      'home': Icons.home,
      'sports': Icons.sports,
      'menu_book': Icons.menu_book,
      'toys': Icons.toys,
      'face': Icons.face,
      'directions_car': Icons.directions_car,
    };

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(context, category);
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    final Map<String, IconData> iconMap = {
      'devices': Icons.devices,
      'checkroom': Icons.checkroom,
      'home': Icons.home,
      'sports': Icons.sports,
      'menu_book': Icons.menu_book,
      'toys': Icons.toys,
      'face': Icons.face,
      'directions_car': Icons.directions_car,
    };

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _showSubcategories(context, category),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconMap[category.icon] ?? Icons.category,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                category.name,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${category.subcategories.length} فئات فرعية',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubcategories(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Title
              Text(
                category.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (category.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  category.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 16),
              
              // Subcategories
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: category.subcategories.length,
                  itemBuilder: (context, index) {
                    final subcategory = category.subcategories[index];
                    return ListTile(
                      leading: Icon(
                        Icons.category,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(subcategory),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pop(context);
                        context.go('${AppRouter.productList}?categoryId=${category.id}&subcategory=$subcategory');
                      },
                    );
                  },
                ),
              ),
              
              // View All Products Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('${AppRouter.productList}?categoryId=${category.id}');
                  },
                  child: Text(LocalizationService.instance.getString('viewAll')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
