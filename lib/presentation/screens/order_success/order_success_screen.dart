import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../components/bmn_button.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/order.dart';
import '../../../theme/bmn_theme.dart';
import '../orders/order_tracking_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderModel order;

  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated Success Graphic
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: BmnColors.brand50,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(IconsaxPlusBold.tick_circle, color: BmnColors.primaryDark, size: 64),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Placed Successfully! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: BmnColors.gray900),
              ),
              const SizedBox(height: 8),
              Text(
                'Tracking #: ${order.orderNumber}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: BmnColors.primaryDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Estimated delivery in 25 minutes to:\n${order.deliveryAddress}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: BmnColors.gray500, height: 1.4),
              ),

              const SizedBox(height: 32),

              // Order Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BmnColors.gray50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: BmnColors.gray200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Items:', style: TextStyle(color: BmnColors.gray500)),
                        Text('${order.items.fold(0, (s, i) => s + i.quantity)} items', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Paid Amount:', style: TextStyle(color: BmnColors.gray500)),
                        Text(
                          CurrencyFormatter.format(order.totalAmount),
                          style: TextStyle(fontWeight: FontWeight.w900, color: BmnColors.primaryDark, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons with BmnButton
              BmnButton(
                text: 'Live Track Order Simulation',
                size: BmnButtonSize.lg,
                variant: BmnButtonVariant.primary,
                icon: IconsaxPlusLinear.routing,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingScreen(orderId: order.orderId),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              BmnButton(
                text: 'Back to Home',
                size: BmnButtonSize.defaultSize,
                variant: BmnButtonVariant.ghost,
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
