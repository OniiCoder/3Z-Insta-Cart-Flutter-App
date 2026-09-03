import 'package:equatable/equatable.dart';
import '../../data/models/order.dart';

enum OrderActionStatus { initial, placing, placed, error }

class OrderState extends Equatable {
  final List<OrderModel> orders;
  final OrderModel? latestOrder;
  final OrderActionStatus actionStatus;
  final String? errorMessage;

  const OrderState({
    this.orders = const [],
    this.latestOrder,
    this.actionStatus = OrderActionStatus.initial,
    this.errorMessage,
  });

  OrderState copyWith({
    List<OrderModel>? orders,
    OrderModel? latestOrder,
    OrderActionStatus? actionStatus,
    String? errorMessage,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      latestOrder: latestOrder ?? this.latestOrder,
      actionStatus: actionStatus ?? this.actionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [orders, latestOrder, actionStatus, errorMessage];
}
