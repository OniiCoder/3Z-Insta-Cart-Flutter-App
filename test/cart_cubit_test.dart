import 'package:flutter_test/flutter_test.dart';
import 'package:threezinstacart/data/datasources/mock_grocery_data.dart';
import 'package:threezinstacart/data/repositories/cart_repository.dart';
import 'package:threezinstacart/logic/cart/cart_cubit.dart';

void main() {
  group('CartCubit & Financial Calculations Tests', () {
    late CartRepository repository;
    late CartCubit cubit;

    setUp(() {
      repository = CartRepository();
      cubit = CartCubit(repository);
    });

    tearDown(() {
      cubit.close();
    });

    test('Adding products computes correct subtotal, 7% tax, and \$3.99 delivery fee', () {
      final avocado = MockGroceryData.products.firstWhere((p) => p.name.contains('Avocados')); // $4.99
      final milk = MockGroceryData.products.firstWhere((p) => p.name.contains('Whole Milk')); // $4.29

      // 2 Avocados ($9.98) + 1 Milk ($4.29) = $14.27 subtotal
      cubit.addItem(avocado, quantity: 2);
      cubit.addItem(milk, quantity: 1);

      final state = cubit.state;
      expect(state.totalItemCount, 3);
      expect(state.subtotal, 14.27);
      expect(state.taxAmount, 1.00); // round(14.27 * 0.07) = 1.00
      expect(state.deliveryFee, 3.99); // < $35 -> $3.99
      expect(state.totalAmount, 19.26); // 14.27 + 1.00 + 3.99 = 19.26
      expect(state.hasFreeDelivery, isFalse);
    });

    test('Orders over \$35 qualify for FREE delivery', () {
      final oliveOil = MockGroceryData.products.firstWhere((p) => p.name.contains('Olive Oil')); // $14.99
      // 3 Olive Oils = $44.97 subtotal
      cubit.addItem(oliveOil, quantity: 3);

      final state = cubit.state;
      expect(state.subtotal, 44.97);
      expect(state.deliveryFee, 0.0);
      expect(state.hasFreeDelivery, isTrue);
      expect(state.totalAmount, 48.12); // 44.97 + round(44.97 * 0.07 = 3.15) = 48.12
    });

    test('Updating quantity and clearing cart works accurately', () {
      final avocado = MockGroceryData.products.first;
      cubit.addItem(avocado, quantity: 2);
      expect(cubit.state.totalItemCount, 2);

      cubit.updateQuantity(avocado.id, 5);
      expect(cubit.state.totalItemCount, 5);

      cubit.clearCart();
      expect(cubit.state.isEmpty, isTrue);
      expect(cubit.state.subtotal, 0.0);
      expect(cubit.state.totalAmount, 0.0);
    });
  });
}
