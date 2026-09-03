import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/order.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/order_repository.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;
  final CatalogRepository _catalogRepository;
  StreamSubscription<List<OrderModel>>? _subscription;

  OrderCubit(this._orderRepository, this._catalogRepository) : super(const OrderState()) {
    _subscription = _orderRepository.ordersStream.listen((ordersList) {
      final latest = state.latestOrder != null
          ? ordersList.firstWhere(
              (o) => o.orderId == state.latestOrder!.orderId,
              orElse: () => ordersList.isNotEmpty ? ordersList.first : state.latestOrder!,
            )
          : (ordersList.isNotEmpty ? ordersList.first : null);

      emit(state.copyWith(
        orders: ordersList,
        latestOrder: latest,
      ));
    });
  }

  Future<OrderModel?> checkout({
    required List<CartItem> items,
    required double subtotal,
    required double taxAmount,
    required double deliveryFee,
    required double totalAmount,
    required String deliveryAddress,
    String? deliveryInstructions,
  }) async {
    emit(state.copyWith(actionStatus: OrderActionStatus.placing));
    try {
      // 1. Deduct stock from catalog
      for (final item in items) {
        _catalogRepository.deductStock(item.product.id, item.quantity);
      }

      // 2. Place Order
      final order = _orderRepository.placeOrder(
        items: items,
        subtotal: subtotal,
        taxAmount: taxAmount,
        deliveryFee: deliveryFee,
        totalAmount: totalAmount,
        deliveryAddress: deliveryAddress,
        deliveryInstructions: deliveryInstructions,
      );

      emit(state.copyWith(
        actionStatus: OrderActionStatus.placed,
        latestOrder: order,
        orders: _orderRepository.orders,
      ));

      return order;
    } catch (e) {
      emit(state.copyWith(
        actionStatus: OrderActionStatus.error,
        errorMessage: 'Checkout failed: $e',
      ));
      return null;
    }
  }

  void fastForwardSimulation(String orderId) {
    _orderRepository.advanceOrderStatusManually(orderId);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
