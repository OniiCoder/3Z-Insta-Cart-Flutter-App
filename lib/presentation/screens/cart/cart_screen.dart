import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../components/bmn_alert.dart';
import '../../../components/bmn_button.dart';
import '../../../components/bmn_empty_state.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../logic/cart/cart_cubit.dart';
import '../../../logic/cart/cart_state.dart';
import '../../../theme/bmn_theme.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Clear Cart?'),
                      content: const Text('Are you sure you want to remove all items from your cart?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<CartCubit>().clearCart();
                            Navigator.pop(ctx);
                          },
                          child: const Text('Clear All', style: TextStyle(color: BmnColors.red600)),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Clear', style: TextStyle(color: BmnColors.red600, fontWeight: FontWeight.bold)),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return BmnEmptyState(
              title: 'Your cart is empty',
              subtitle: 'Explore fresh produce, organic milk, bakery, and snacks to fill your basket.',
              icon: IconsaxPlusLinear.shopping_bag,
              hasCta: true,
              ctaText: 'Start Shopping',
              ctaIcon: IconsaxPlusLinear.arrow_right_3,
              onCtaClick: () => Navigator.of(context).pop(),
            );
          }

          return Column(
            children: [
              // BmnAlert for Free delivery progress
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: BmnAlert(
                  variant: state.hasFreeDelivery ? BmnAlertVariant.success : BmnAlertVariant.warning,
                  title: state.hasFreeDelivery ? 'FREE Delivery Unlocked!' : 'Free Delivery Goal',
                  message: state.hasFreeDelivery
                      ? 'Your order qualifies for FREE Express Delivery!'
                      : 'Add ${CurrencyFormatter.format(state.freeDeliveryRemaining)} more to get FREE Delivery!',
                ),
              ),

              // Item List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 24, color: BmnColors.gray200),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.product.imageUrl,
                            width: 68,
                            height: 68,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 68,
                              height: 68,
                              color: BmnColors.gray100,
                              child: const Icon(IconsaxPlusLinear.shopping_bag, color: BmnColors.gray400),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Title & pricing
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: BmnColors.gray900),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${CurrencyFormatter.format(item.product.price)} / ${item.product.unit}',
                                style: const TextStyle(fontSize: 12, color: BmnColors.gray500),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                CurrencyFormatter.format(item.itemTotal),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: BmnColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Quantity stepper
                        Container(
                          decoration: BoxDecoration(
                            color: BmnColors.gray50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: BmnColors.gray200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(IconsaxPlusLinear.minus, size: 14),
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  context.read<CartCubit>().updateQuantity(item.product.id, item.quantity - 1);
                                },
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              IconButton(
                                icon: const Icon(IconsaxPlusLinear.add, size: 14),
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  context.read<CartCubit>().updateQuantity(item.product.id, item.quantity + 1);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Bottom Order Summary Sheet
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(top: BorderSide(color: BmnColors.gray200)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSummaryRow('Subtotal (${state.totalItemCount} items)', CurrencyFormatter.format(state.subtotal)),
                      const SizedBox(height: 6),
                      _buildSummaryRow('Sales Tax (7%)', CurrencyFormatter.format(state.taxAmount)),
                      const SizedBox(height: 6),
                      _buildSummaryRow(
                        'Delivery Fee',
                        state.deliveryFee == 0 ? 'FREE' : CurrencyFormatter.format(state.deliveryFee),
                        isHighlight: state.deliveryFee == 0,
                      ),
                      const Divider(height: 20, color: BmnColors.gray200),
                      _buildSummaryRow(
                        'Total',
                        CurrencyFormatter.format(state.totalAmount),
                        isTotal: true,
                      ),
                      const SizedBox(height: 16),
                      BmnButton(
                        text: 'Proceed to Checkout • ${CurrencyFormatter.format(state.totalAmount)}',
                        size: BmnButtonSize.lg,
                        variant: BmnButtonVariant.primary,
                        icon: IconsaxPlusLinear.arrow_right_3,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, {bool isHighlight = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            color: isTotal ? BmnColors.gray900 : BmnColors.gray500,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
            color: isHighlight
                ? BmnColors.green600
                : isTotal
                    ? BmnColors.primaryDark
                    : BmnColors.gray900,
          ),
        ),
      ],
    );
  }
}
