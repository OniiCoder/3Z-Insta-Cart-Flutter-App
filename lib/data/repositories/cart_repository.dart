import '../../core/constants/app_constants.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartCalculationResult {
  final List<CartItem> items;
  final int totalItemCount;
  final double subtotal;
  final double taxAmount;
  final double deliveryFee;
  final double totalAmount;

  const CartCalculationResult({
    required this.items,
    required this.totalItemCount,
    required this.subtotal,
    required this.taxAmount,
    required this.deliveryFee,
    required this.totalAmount,
  });

  factory CartCalculationResult.empty() {
    return const CartCalculationResult(
      items: [],
      totalItemCount: 0,
      subtotal: 0.0,
      taxAmount: 0.0,
      deliveryFee: 0.0,
      totalAmount: 0.0,
    );
  }
}

class CartRepository {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  CartCalculationResult calculateTotals() {
    if (_items.isEmpty) {
      return CartCalculationResult.empty();
    }

    final totalItemCount = _items.fold<int>(0, (sum, item) => sum + item.quantity);
    final rawSubtotal = _items.fold<double>(0.0, (sum, item) => sum + item.itemTotal);
    final subtotal = double.parse(rawSubtotal.toStringAsFixed(2));

    final taxAmount = double.parse((subtotal * AppConstants.taxRate).toStringAsFixed(2));
    final deliveryFee = subtotal >= AppConstants.freeDeliveryThreshold ? 0.0 : AppConstants.deliveryFee;
    final totalAmount = double.parse((subtotal + taxAmount + deliveryFee).toStringAsFixed(2));

    return CartCalculationResult(
      items: List.unmodifiable(_items),
      totalItemCount: totalItemCount,
      subtotal: subtotal,
      taxAmount: taxAmount,
      deliveryFee: deliveryFee,
      totalAmount: totalAmount,
    );
  }

  CartCalculationResult addItem(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index != -1) {
      final existing = _items[index];
      _items[index] = existing.copyWith(quantity: existing.quantity + quantity);
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    return calculateTotals();
  }

  CartCalculationResult updateItemQuantity(int productId, int quantity) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
    }
    return calculateTotals();
  }

  CartCalculationResult removeItem(int productId) {
    _items.removeWhere((i) => i.product.id == productId);
    return calculateTotals();
  }

  CartCalculationResult clear() {
    _items.clear();
    return calculateTotals();
  }
}
