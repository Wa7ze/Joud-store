import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';
import '../../core/router/app_router.dart';
import '../../core/config/app_config.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isLoading = false;
  List<CartItem> _cartItems = [];
  String? _appliedCoupon;
  double _deliveryFee = 0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    // Mock cart items
    _cartItems = [
      CartItem(
        id: '1',
        productId: 'product_1',
        productName: 'منتج 1',
        price: 50000,
        originalPrice: 75000,
        quantity: 2,
        imageUrl: '',
        selectedSize: 'M',
        selectedColor: 'أحمر',
      ),
      CartItem(
        id: '2',
        productId: 'product_2',
        productName: 'منتج 2',
        price: 30000,
        originalPrice: 30000,
        quantity: 1,
        imageUrl: '',
        selectedSize: 'L',
        selectedColor: 'أزرق',
      ),
    ];
    _calculateDeliveryFee();
  }

  void _calculateDeliveryFee() {
    // Mock delivery fee calculation
    _deliveryFee = AppConfig.deliveryFees['damascus'] ?? 5000;
  }

  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return ScreenScaffold(
      title: localizationService.getString('cart'),
      body: _isLoading
          ? const LoadingState()
          : _cartItems.isEmpty
              ? EmptyState(
                  title: localizationService.getString('emptyCart'),
                  message: 'أضف منتجات إلى سلة التسوق لبدء التسوق',
                  icon: Icons.shopping_cart_outlined,
                )
              : Column(
                  children: [
                    // Cart Items
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          return _buildCartItem(_cartItems[index]);
                        },
                      ),
                    ),
                    
                    // Cart Summary
                    _buildCartSummary(),
                  ],
                ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 30),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Variants
                  if (item.selectedSize != null || item.selectedColor != null) ...[
                    Text(
                      '${item.selectedSize ?? ''} ${item.selectedColor ?? ''}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  
                  // Price
                  Row(
                    children: [
                      Text(
                        '${AppConfig.defaultCurrency} ${item.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (item.originalPrice > item.price) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${AppConfig.defaultCurrency} ${item.originalPrice.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Quantity Controls
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: item.quantity > 1 ? () => _updateQuantity(item.id, item.quantity - 1) : null,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(item.quantity.toString()),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _updateQuantity(item.id, item.quantity + 1),
                ),
              ],
            ),
            
            // Remove Button
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _removeItem(item.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary() {
    final localizationService = LocalizationService.instance;
    final subtotal = _cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final discount = _appliedCoupon != null ? subtotal * 0.1 : 0; // 10% discount
    final total = subtotal - discount + _deliveryFee;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Coupon Section
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: localizationService.getString('couponCode'),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyCoupon,
                child: Text(localizationService.getString('applyCoupon')),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizationService.getString('subtotal')),
              Text('${AppConfig.defaultCurrency} ${subtotal.toStringAsFixed(0)}'),
            ],
          ),
          
          if (_appliedCoupon != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(localizationService.getString('discount')),
                Text(
                  '-${AppConfig.defaultCurrency} ${discount.toStringAsFixed(0)}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizationService.getString('delivery')),
              Text('${AppConfig.defaultCurrency} ${_deliveryFee.toStringAsFixed(0)}'),
            ],
          ),
          
          const Divider(),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizationService.getString('total'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${AppConfig.defaultCurrency} ${total.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _cartItems.isNotEmpty ? _proceedToCheckout : null,
              child: Text(localizationService.getString('checkout')),
            ),
          ),
        ],
      ),
    );
  }

  void _updateQuantity(String itemId, int newQuantity) {
    setState(() {
      final itemIndex = _cartItems.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        _cartItems[itemIndex] = _cartItems[itemIndex].copyWith(quantity: newQuantity);
      }
    });
  }

  void _removeItem(String itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == itemId);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocalizationService.instance.getString('productRemovedFromCart')),
        action: SnackBarAction(
          label: LocalizationService.instance.getString('undo'),
          onPressed: () {
            // Undo remove (would need to restore the item)
          },
        ),
      ),
    );
  }

  void _applyCoupon() {
    // Mock coupon application
    setState(() {
      _appliedCoupon = 'SAVE10';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocalizationService.instance.getString('couponApplied')),
      ),
    );
  }

  void _proceedToCheckout() {
    context.go(AppRouter.checkout);
  }
}

class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final double originalPrice;
  final int quantity;
  final String imageUrl;
  final String? selectedSize;
  final String? selectedColor;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    required this.imageUrl,
    this.selectedSize,
    this.selectedColor,
  });

  CartItem copyWith({
    String? id,
    String? productId,
    String? productName,
    double? price,
    double? originalPrice,
    int? quantity,
    String? imageUrl,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}
