import 'package:flutter_test/flutter_test.dart';
import 'package:threezinstacart/data/models/cart_item.dart';
import 'package:threezinstacart/data/models/order.dart';
import 'package:threezinstacart/data/repositories/catalog_repository.dart';
import 'package:threezinstacart/data/repositories/order_repository.dart';
import 'package:threezinstacart/logic/order/order_cubit.dart';
import 'package:threezinstacart/logic/order/order_state.dart';

void main() {
  group('OrderCubit & Lifecycle Simulation Tests', () {
    late OrderRepository orderRepository;
    late CatalogRepository catalogRepository;
    late OrderCubit cubit;

    setUp(() {
      orderRepository = OrderRepository();
      catalogRepository = CatalogRepository();
      cubit = OrderCubit(orderRepository, catalogRepository);
    });

    tearDown(() {
      cubit.close();
      orderRepository.dispose();
    });

    test('Checkout places order and starts in pending state with deducted stock', () async {
      final avocado = catalogRepository.getAllProducts().firstWhere((p) => p.id == 1);
      final initialStock = avocado.stockQuantity;

      final items = [CartItem(product: avocado, quantity: 2)];
      final order = await cubit.checkout(
        items: items,
        subtotal: 9.98,
        taxAmount: 0.70,
        deliveryFee: 3.99,
        totalAmount: 14.67,
        deliveryAddress: '742 Evergreen Terrace',
      );

      expect(order, isNotNull);
      expect(order!.status, OrderStatus.pending);
      expect(order.orderNumber, startsWith('3Z-'));
      expect(cubit.state.actionStatus, OrderActionStatus.placed);

      // Verify stock was deducted
      final updatedAvocado = catalogRepository.getProductById(1);
      expect(updatedAvocado!.stockQuantity, initialStock - 2);
    });

    test('Manual fast-forward simulation advances order state', () async {
      final avocado = catalogRepository.getAllProducts().first;
      final items = [CartItem(product: avocado, quantity: 1)];

      final order = await cubit.checkout(
        items: items,
        subtotal: avocado.price,
        taxAmount: 0.35,
        deliveryFee: 3.99,
        totalAmount: avocado.price + 0.35 + 3.99,
        deliveryAddress: '742 Evergreen Terrace',
      );

      expect(orderRepository.getOrderById(order!.orderId)!.status, OrderStatus.pending);

      // Advance 1: Pending -> Confirmed
      cubit.fastForwardSimulation(order.orderId);
      expect(orderRepository.getOrderById(order.orderId)!.status, OrderStatus.confirmed);

      // Advance 2: Confirmed -> Preparing
      cubit.fastForwardSimulation(order.orderId);
      expect(orderRepository.getOrderById(order.orderId)!.status, OrderStatus.preparing);

      // Advance 3: Preparing -> Out for Delivery
      cubit.fastForwardSimulation(order.orderId);
      expect(orderRepository.getOrderById(order.orderId)!.status, OrderStatus.outForDelivery);

      // Advance 4: Out for Delivery -> Delivered
      cubit.fastForwardSimulation(order.orderId);
      expect(orderRepository.getOrderById(order.orderId)!.status, OrderStatus.delivered);
    });
  });
}
