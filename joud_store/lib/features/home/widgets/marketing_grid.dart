import "package:flutter/material.dart";

import '../../../core/widgets/product_card.dart';
import '../../products/models/product.dart';
import '../../products/services/product_service.dart';

class MarketingGrid extends StatefulWidget {
  const MarketingGrid({super.key});

  @override
  State<MarketingGrid> createState() => _MarketingGridState();
}

class _MarketingGridState extends State<MarketingGrid> {
  final ProductService _service = ProductService();
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadProducts();
  }

  Future<List<Product>> _loadProducts() async {
    final latestWomen = _service.getProducts(categoryId: 'women', sortBy: 'latest', pageSize: 4);
    final latestMen = _service.getProducts(categoryId: 'men', sortBy: 'latest', pageSize: 4);
    final lists = await Future.wait([latestWomen, latestMen]);
    final merged = <String, Product>{};
    for (final list in lists) {
      for (final product in list) {
        merged[product.id] = product;
      }
    }
    final items = merged.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 32), child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }
        final products = snapshot.data!;
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final bool isSmall = width < 760;
            final bool isMedium = width < 1080;
            final int crossAxisCount = isSmall ? 1 : (isMedium ? 2 : 3);
            final double spacing = isSmall ? 16 : 20;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              padding: EdgeInsets.symmetric(horizontal: isSmall ? 0 : 4, vertical: 4),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                );
              },
            );
          },
        );
      },
    );
  }
}
