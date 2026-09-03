import 'package:equatable/equatable.dart';
import 'cart_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Shopper Preparing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.pending:
        return 'Placing your order with 3Z Insta Cart...';
      case OrderStatus.confirmed:
        return 'Payment verified! Assigning personal shopper.';
      case OrderStatus.preparing:
        return 'Your 3Z shopper is picking fresh items at the store.';
      case OrderStatus.outForDelivery:
        return 'Courier is en route to your delivery address.';
      case OrderStatus.delivered:
        return 'Order delivered right to your doorstep. Enjoy!';
      case OrderStatus.cancelled:
        return 'This order was cancelled.';
    }
  }

  int get stepIndex {
    switch (this) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.preparing:
        return 2;
      case OrderStatus.outForDelivery:
        return 3;
      case OrderStatus.delivered:
        return 4;
      case OrderStatus.cancelled:
        return -1;
    }
  }
}

class OrderModel extends Equatable {
  final String orderId;
  final String orderNumber;
  final List<CartItem> items;
  final double subtotal;
  final double taxAmount;
  final double deliveryFee;
  final double totalAmount;
  final OrderStatus status;
  final String deliveryAddress;
  final String? deliveryInstructions;
  final DateTime createdAt;
  final DateTime estimatedDeliveryTime;

  const OrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.deliveryFee,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    this.deliveryInstructions,
    required this.createdAt,
    required this.estimatedDeliveryTime,
  });

  OrderModel copyWith({
    String? orderId,
    String? orderNumber,
    List<CartItem>? items,
    double? subtotal,
    double? taxAmount,
    double? deliveryFee,
    double? totalAmount,
    OrderStatus? status,
    String? deliveryAddress,
    String? deliveryInstructions,
    DateTime? createdAt,
    DateTime? estimatedDeliveryTime,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      createdAt: createdAt ?? this.createdAt,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
    );
  }

  @override
  List<Object?> get props => [
        orderId,
        orderNumber,
        items,
        subtotal,
        taxAmount,
        deliveryFee,
        totalAmount,
        status,
        deliveryAddress,
        deliveryInstructions,
        createdAt,
        estimatedDeliveryTime,
      ];
}
