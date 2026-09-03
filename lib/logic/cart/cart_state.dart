import 'package:equatable/equatable.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final int totalItemCount;
  final double subtotal;
  final double taxAmount;
  final double deliveryFee;
  final double totalAmount;
  final String? promoCode;
  final double discountAmount;

  const CartState({
    this.items = const [],
    this.totalItemCount = 0,
    this.subtotal = 0.0,
    this.taxAmount = 0.0,
    this.deliveryFee = 0.0,
    this.totalAmount = 0.0,
    this.promoCode,
    this.discountAmount = 0.0,
  });

  bool get isEmpty => items.isEmpty;
  bool get hasFreeDelivery => subtotal >= AppConstants.freeDeliveryThreshold;
  double get freeDeliveryRemaining => (AppConstants.freeDeliveryThreshold - subtotal).clamp(0.0, AppConstants.freeDeliveryThreshold);

  int getProductQuantity(int productId) {
    try {
      return items.firstWhere((i) => i.product.id == productId).quantity;
    } catch (_) {
      return 0;
    }
  }

  CartState copyWith({
    List<CartItem>? items,
    int? totalItemCount,
    double? subtotal,
    double? taxAmount,
    double? deliveryFee,
    double? totalAmount,
    String? promoCode,
    double? discountAmount,
  }) {
    return CartState(
      items: items ?? this.items,
      totalItemCount: totalItemCount ?? this.totalItemCount,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      totalAmount: totalAmount ?? this.totalAmount,
      promoCode: promoCode ?? this.promoCode,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }

  @override
  List<Object?> get props => [
        items,
        totalItemCount,
        subtotal,
        taxAmount,
        deliveryFee,
        totalAmount,
        promoCode,
        discountAmount,
      ];
}
