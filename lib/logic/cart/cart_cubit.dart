import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product.dart';
import '../../data/repositories/cart_repository.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;

  CartCubit(this._repository) : super(const CartState());

  void addItem(Product product, {int quantity = 1}) {
    final result = _repository.addItem(product, quantity: quantity);
    _emitResult(result);
  }

  void updateQuantity(int productId, int quantity) {
    final result = _repository.updateItemQuantity(productId, quantity);
    _emitResult(result);
  }

  void removeItem(int productId) {
    final result = _repository.removeItem(productId);
    _emitResult(result);
  }

  void clearCart() {
    final result = _repository.clear();
    _emitResult(result);
  }

  void _emitResult(CartCalculationResult result) {
    emit(state.copyWith(
      items: result.items,
      totalItemCount: result.totalItemCount,
      subtotal: result.subtotal,
      taxAmount: result.taxAmount,
      deliveryFee: result.deliveryFee,
      totalAmount: result.totalAmount,
    ));
  }
}
