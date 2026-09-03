import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../components/bmn_badge.dart';
import '../../../components/bmn_button.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/order.dart';
import '../../../logic/order/order_cubit.dart';
import '../../../logic/order/order_state.dart';
import '../../../theme/bmn_theme.dart';
import '../../widgets/status_timeline_tile.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Order Tracking'),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          final now = DateTime.now();
          final order = state.orders.firstWhere(
            (o) => o.orderId == orderId,
            orElse: () => state.latestOrder ?? OrderModel(
              orderId: '0',
              orderNumber: '3Z-DEMO',
              items: const [],
              subtotal: 0,
              taxAmount: 0,
              deliveryFee: 0,
              totalAmount: 0,
              status: OrderStatus.pending,
              deliveryAddress: 'Springfield',
              createdAt: now,
              estimatedDeliveryTime: now.add(const Duration(minutes: 25)),
            ),
          );

          final currentStep = order.status.stepIndex;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Live Status Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [BmnColors.primaryDark, BmnColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: BmnColors.primaryDark.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BmnBadge(
                            label: order.status.displayName.toUpperCase(),
                            variant: order.status == OrderStatus.delivered
                                ? BmnBadgeVariant.success
                                : BmnBadgeVariant.warning,
                            icon: IconsaxPlusBold.flash_1,
                          ),
                          Text(
                            'ETA: ~25 mins',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        order.status.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Order #: ${order.orderNumber}',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Fast-Forward Simulation Controller
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: BmnColors.orange50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: BmnColors.orange200),
                  ),
                  child: Row(
                    children: [
                      const Icon(IconsaxPlusBold.forward_5_seconds, color: BmnColors.orange500),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Simulation Controller',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: BmnColors.gray900),
                            ),
                            Text(
                              'Advance order state for demo',
                              style: TextStyle(fontSize: 11, color: BmnColors.gray500),
                            ),
                          ],
                        ),
                      ),
                      BmnButton(
                        text: 'Advance Step',
                        size: BmnButtonSize.sm,
                        variant: BmnButtonVariant.secondary,
                        disabled: order.status == OrderStatus.delivered,
                        onPressed: order.status == OrderStatus.delivered
                            ? null
                            : () => context.read<OrderCubit>().fastForwardSimulation(order.orderId),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Step Timeline
                const Text(
                  'Delivery Progress',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: BmnColors.gray900),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: BmnColors.gray200),
                  ),
                  child: Column(
                    children: [
                      StatusTimelineTile(
                        title: 'Order Placed & Confirmed',
                        description: 'Your payment was processed and verified.',
                        isCompleted: currentStep > 0,
                        isCurrent: currentStep == 0,
                      ),
                      StatusTimelineTile(
                        title: 'Personal Shopper Picking Items',
                        description: 'Selecting the freshest produce and best expiry dates.',
                        isCompleted: currentStep > 1,
                        isCurrent: currentStep == 1,
                      ),
                      StatusTimelineTile(
                        title: 'Out for Express Delivery',
                        description: 'Driver is on the way to ${order.deliveryAddress}.',
                        isCompleted: currentStep > 2,
                        isCurrent: currentStep == 2,
                      ),
                      StatusTimelineTile(
                        title: 'Delivered to Doorstep',
                        description: 'Your 3Z groceries have arrived. Enjoy!',
                        isCompleted: currentStep >= 3,
                        isCurrent: currentStep == 3,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Items in this order
                const Text(
                  'Items in this Order',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: BmnColors.gray900),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: BmnColors.gray200),
                  ),
                  child: Column(
                    children: [
                      ...order.items.map((i) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    i.product.imageUrl,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 44,
                                      height: 44,
                                      color: BmnColors.gray100,
                                      child: const Icon(IconsaxPlusLinear.shopping_bag, size: 20, color: BmnColors.gray400),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(i.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: BmnColors.gray900)),
                                      Text('${i.quantity} x ${CurrencyFormatter.format(i.product.price)}', style: const TextStyle(fontSize: 12, color: BmnColors.gray500)),
                                    ],
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.format(i.itemTotal),
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: BmnColors.gray900),
                                ),
                              ],
                            ),
                          )),
                      const Divider(height: 20, color: BmnColors.gray200),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Paid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: BmnColors.gray900)),
                          Text(
                            CurrencyFormatter.format(order.totalAmount),
                            style: TextStyle(fontWeight: FontWeight.w900, color: BmnColors.primaryDark, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
