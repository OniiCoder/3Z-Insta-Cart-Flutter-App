import 'dart:async';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrderRepository {
  final List<OrderModel> _orders = [];
  final _orderStreamController = StreamController<List<OrderModel>>.broadcast();

  Stream<List<OrderModel>> get ordersStream => _orderStreamController.stream;
  List<OrderModel> get orders => List.unmodifiable(_orders);

  OrderModel placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double taxAmount,
    required double deliveryFee,
    required double totalAmount,
    required String deliveryAddress,
    String? deliveryInstructions,
  }) {
    final now = DateTime.now();
    final timestamp = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    final randomSuffix = (1000 + (now.millisecond % 9000)).toString();
    final orderNumber = '3Z-$timestamp-$randomSuffix';

    final order = OrderModel(
      orderId: 'ORD-${_orders.length + 1}',
      orderNumber: orderNumber,
      items: List.from(items),
      subtotal: subtotal,
      taxAmount: taxAmount,
      deliveryFee: deliveryFee,
      totalAmount: totalAmount,
      status: OrderStatus.pending,
      deliveryAddress: deliveryAddress,
      deliveryInstructions: deliveryInstructions,
      createdAt: now,
      estimatedDeliveryTime: now.add(const Duration(minutes: 25)),
    );

    _orders.insert(0, order);
    _emitOrders();

    // Start auto simulation lifecycle
    _simulateOrderLifecycle(order.orderId);

    return order;
  }

  void _simulateOrderLifecycle(String orderId) {
    // Stage 1: Pending -> Confirmed (after 3 seconds)
    Timer(const Duration(seconds: 3), () {
      _updateStatus(orderId, OrderStatus.confirmed);
    });

    // Stage 2: Confirmed -> Preparing (after 7 seconds)
    Timer(const Duration(seconds: 7), () {
      _updateStatus(orderId, OrderStatus.preparing);
    });

    // Stage 3: Preparing -> Out for Delivery (after 13 seconds)
    Timer(const Duration(seconds: 13), () {
      _updateStatus(orderId, OrderStatus.outForDelivery);
    });

    // Stage 4: Out for Delivery -> Delivered (after 20 seconds)
    Timer(const Duration(seconds: 20), () {
      _updateStatus(orderId, OrderStatus.delivered);
    });
  }

  void advanceOrderStatusManually(String orderId) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index != -1) {
      final current = _orders[index];
      OrderStatus nextStatus;
      switch (current.status) {
        case OrderStatus.pending:
          nextStatus = OrderStatus.confirmed;
          break;
        case OrderStatus.confirmed:
          nextStatus = OrderStatus.preparing;
          break;
        case OrderStatus.preparing:
          nextStatus = OrderStatus.outForDelivery;
          break;
        case OrderStatus.outForDelivery:
          nextStatus = OrderStatus.delivered;
          break;
        case OrderStatus.delivered:
        case OrderStatus.cancelled:
          return;
      }
      _updateStatus(orderId, nextStatus);
    }
  }

  void _updateStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: status);
      _emitOrders();
    }
  }

  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.orderId == orderId);
    } catch (_) {
      return null;
    }
  }

  void _emitOrders() {
    _orderStreamController.add(List.unmodifiable(_orders));
  }

  void dispose() {
    _orderStreamController.close();
  }
}
