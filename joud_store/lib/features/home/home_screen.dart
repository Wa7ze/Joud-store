import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/router/app_router.dart';
import '../../core/config/app_config.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    if (_searchController.text.isNotEmpty) {
      context.go('${AppRouter.search}?q=${_searchController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizationService.getString('appName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.go(AppRouter.cart),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.go(AppRouter.notifications),
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingState()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: localizationService.getString('search'),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _onSearch,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _onSearch(),
                    ),
                  ),
                  
                  // Banners Section
                  _buildBannersSection(context),
                  
                  const SizedBox(height: 24),
                  
                  // Categories Section
                  _buildCategoriesSection(context),
                  
                  const SizedBox(height: 24),
                  
                  // Best Sellers Section
                  _buildBestSellersSection(context),
                  
                  const SizedBox(height: 24),
                  
                  // New Arrivals Section
                  _buildNewArrivalsSection(context),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBannersSection(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: PageView(
        children: [
          _buildBannerCard(
            context,
            'عروض خاصة',
            'خصم يصل إلى 50%',
            Colors.orange,
          ),
          _buildBannerCard(
            context,
            'توصيل مجاني',
            'لجميع الطلبات',
            Colors.green,
          ),
          _buildBannerCard(
            context,
            'منتجات جديدة',
            'اكتشف أحدث المنتجات',
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizationService.getString('categories'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () => context.go(AppRouter.categories),
                child: Text(localizationService.getString('viewAll')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 6,
            itemBuilder: (context, index) {
              final categories = [
                'إلكترونيات',
                'ملابس',
                'منزل',
                'رياضة',
                'كتب',
                'ألعاب',
              ];
              return _buildCategoryCard(context, categories[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, String categoryName) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.category,
              size: 40,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            categoryName,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellersSection(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الأكثر مبيعاً',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () => context.go(AppRouter.productList),
                child: Text(localizationService.getString('viewAll')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildProductCard(context, 'منتج ${index + 1}');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewArrivalsSection(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'وصل حديثاً',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () => context.go(AppRouter.productList),
                child: Text(localizationService.getString('viewAll')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildProductCard(context, 'منتج جديد ${index + 1}');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, String productName) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppConfig.defaultCurrency} 50,000',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
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

  Widget _buildBottomNavigationBar(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: localizationService.getString('home'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.category),
          label: localizationService.getString('categories'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_cart),
          label: localizationService.getString('cart'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: localizationService.getString('profile'),
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            context.go(AppRouter.home);
            break;
          case 1:
            context.go(AppRouter.categories);
            break;
          case 2:
            context.go(AppRouter.cart);
            break;
          case 3:
            context.go(AppRouter.profile);
            break;
        }
      },
    );
  }
}
