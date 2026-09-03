import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../components/bmn_badge.dart';
import '../../../components/bmn_empty_state.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/order.dart';
import '../../../logic/order/order_cubit.dart';
import '../../../logic/order/order_state.dart';
import '../../../theme/bmn_theme.dart';
import 'order_tracking_screen.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders & History'),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state.orders.isEmpty) {
            return const BmnEmptyState(
              title: 'No orders placed yet',
              subtitle: 'When you checkout an order, you can live-track delivery progress right here.',
              icon: IconsaxPlusLinear.receipt_item,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingScreen(orderId: order.orderId),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: BmnColors.gray200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order.orderNumber,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: BmnColors.gray900),
                          ),
                          BmnBadge(
                            label: order.status.displayName,
                            variant: order.status == OrderStatus.delivered
                                ? BmnBadgeVariant.success
                                : BmnBadgeVariant.warning,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${order.items.fold(0, (s, i) => s + i.quantity)} items: ${order.items.map((i) => i.product.name).take(2).join(', ')}${order.items.length > 2 ? '...' : ''}',
                        style: const TextStyle(fontSize: 13, color: BmnColors.gray500),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            CurrencyFormatter.format(order.totalAmount),
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: BmnColors.primaryDark),
                          ),
                          Row(
                            children: [
                              Text('Track Live', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: BmnColors.primaryDark)),
                              const SizedBox(width: 4),
                              Icon(IconsaxPlusLinear.arrow_right_3, size: 14, color: BmnColors.primaryDark),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
