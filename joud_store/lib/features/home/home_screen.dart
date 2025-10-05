import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/router/app_router.dart';
import '../../core/config/app_config.dart';
import '../products/product_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = false;

  final List<IconData> _categoryIcons = [
    Icons.man,
    Icons.woman,
    Icons.child_care,
    Icons.hiking,
    Icons.watch,
    Icons.fitness_center,
  ];

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
            'تشكيلة الخريف',
            'أحدث صيحات الموضة',
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ),
          _buildBannerCard(
            context,
            'عروض نهاية الموسم',
            'خصم يصل إلى 50%',
            AppColors.sale,
            AppColors.sale.withOpacity(0.8),
          ),
          _buildBannerCard(
            context,
            'أزياء رمضان',
            'مجموعة حصرية',
            AppColors.primary,
            AppColors.primaryLight,
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard(
    BuildContext context,
    String title,
    String subtitle,
    Color startColor,
    Color endColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [startColor, endColor],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: startColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 140,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          Padding(
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
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'تسوق الآن',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
                'رجالي',
                'نسائي',
                'أطفال',
                'أحذية',
                'إكسسوارات',
                'رياضة',
              ];

              return _buildCategoryCard(context, categories[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, String categoryName, int index) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _categoryIcons[index],
              size: 40,
              color: AppColors.primary,
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
                'الأكثر رواجاً',
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
                'أحدث التشكيلات',
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
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    image: const DecorationImage(
                      image: NetworkImage('https://placehold.co/200x250'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sale,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '-30%',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Row(
                    children: [
                      for (final size in ['S', 'M', 'L']) 
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            size,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      for (final color in [Colors.black, Colors.blue, Colors.red])
                        Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    productName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${AppConfig.defaultCurrency} 35,000',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.sale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${AppConfig.defaultCurrency} 50,000',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textLight,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
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
