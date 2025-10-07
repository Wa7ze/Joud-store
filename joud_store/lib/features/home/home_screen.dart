import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/router/app_router.dart';
import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../products/product_list_screen.dart' hide AppColors;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = false;

  final List<IconData> _categoryIcons = [
    Icons.man_outlined,           // Men's clothing
    Icons.woman_outlined,         // Women's clothing
    Icons.child_care_outlined,    // Kids' clothing
    Icons.business_center,        // Formal wear
    Icons.sports_soccer_outlined, // Sports wear
    Icons.watch,                  // Accessories
    Icons.event_available,        // Seasonal collections
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
            'مجموعة خريف وشتاء 2025',
            'أناقة وراحة بألوان الموسم',
            AppColors.primaryLight,
            AppColors.primary,
            icon: Icons.style_outlined,
          ),
          _buildBannerCard(
            context,
            'تخفيضات نهاية الموسم',
            'خصومات حتى 70% على الأزياء',
            AppColors.accent,
            AppColors.accentDark,
            icon: Icons.local_offer_outlined,
          ),
          _buildBannerCard(
            context,
            'مجموعة الأعراس',
            'تألقي في ليلة العمر',
            AppColors.primary,
            AppColors.primaryDark,
            icon: Icons.celebration_outlined,
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
    {IconData icon = Icons.shopping_bag_outlined}
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
              icon,
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
            itemCount: 7,
            itemBuilder: (context, index) {
              final categories = [
                'رجال',
                'نساء',
                'أطفال',
                'ملابس رسمية',
                'ملابس رياضية',
                'اكسسوارات',
                'مجموعات موسمية',
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
                'الأكثر مبيعاً هذا الموسم',
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
                'وصل حديثاً | خريف 2025',
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
        shadowColor: AppColors.primary.withOpacity(0.1),
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
                    color: AppColors.surfaceVariant,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    image: const DecorationImage(
                      image: NetworkImage('https://placehold.co/200x250'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Sale Tag
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 14,
                          color: AppColors.onSale,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '-30%',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.onSale,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Quick Actions
                Positioned(
                  top: 8,
                  left: 8,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Size Options
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Sizes
                      Row(
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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                size,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ),
                        ],
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
                  // Product Type Label
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'قميص',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Color Options
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
                  // Product Name
                  Text(
                    productName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Rating
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '4.5',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(120)',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Price
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
