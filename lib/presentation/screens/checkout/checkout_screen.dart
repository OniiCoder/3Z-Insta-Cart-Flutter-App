import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../components/bmn_button.dart';
import '../../../components/bmn_radio.dart';
import '../../../components/bmn_text_input.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/customer.dart';
import '../../../logic/cart/cart_cubit.dart';
import '../../../logic/cart/cart_state.dart';
import '../../../logic/order/order_cubit.dart';
import '../../../theme/bmn_theme.dart';
import '../order_success/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController(text: CustomerProfile.demo.defaultAddress);
  final _cityController = TextEditingController(text: CustomerProfile.demo.defaultCity);
  final _zipController = TextEditingController(text: CustomerProfile.demo.defaultZipCode);
  final _instructionsController = TextEditingController(text: 'Leave at the front door please.');
  String _selectedPaymentMethod = 'Apple Pay / Instant Card';

  bool _isProcessing = false;

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _handlePlaceOrder(CartState cartState) async {
    setState(() => _isProcessing = true);

    final fullAddress = '${_addressController.text.trim()}, ${_cityController.text.trim()} ${_zipController.text.trim()}';

    final order = await context.read<OrderCubit>().checkout(
      items: cartState.items,
      subtotal: cartState.subtotal,
      taxAmount: cartState.taxAmount,
      deliveryFee: cartState.deliveryFee,
      totalAmount: cartState.totalAmount,
      deliveryAddress: fullAddress,
      deliveryInstructions: _instructionsController.text.trim(),
    );

    setState(() => _isProcessing = false);

    if (order != null && mounted) {
      context.read<CartCubit>().clearCart();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(order: order),
        ),
        (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout & Review'),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          if (cartState.isEmpty) {
            return const Center(child: Text('No items in cart to checkout'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Address Section with BmnTextInput
                _buildSectionHeader('Delivery Address', IconsaxPlusLinear.location),
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
                      BmnTextInput(
                        label: 'Street Address',
                        controller: _addressController,
                        startContent: const Icon(IconsaxPlusLinear.home, color: BmnColors.gray400, size: 18),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: BmnTextInput(
                              label: 'City',
                              controller: _cityController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: BmnTextInput(
                              label: 'Zip Code',
                              controller: _zipController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      BmnTextInput(
                        label: 'Delivery Instructions (Optional)',
                        controller: _instructionsController,
                        startContent: const Icon(IconsaxPlusLinear.note, color: BmnColors.gray400, size: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Method Simulation with BmnRadio
                _buildSectionHeader('Payment Method', IconsaxPlusLinear.card),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: BmnColors.gray200),
                  ),
                  child: Column(
                    children: [
                      BmnRadio(
                        label: 'Apple Pay / Instant Credit Card',
                        variant: BmnRadioVariant.card,
                        checked: _selectedPaymentMethod == 'Apple Pay / Instant Card',
                        icon: const Icon(Icons.apple, color: BmnColors.gray900, size: 20),
                        onChange: (_) => setState(() => _selectedPaymentMethod = 'Apple Pay / Instant Card'),
                      ),
                      const SizedBox(height: 8),
                      BmnRadio(
                        label: '3Z Insta Wallet (Balance: \$150.00)',
                        variant: BmnRadioVariant.card,
                        checked: _selectedPaymentMethod == '3Z Wallet',
                        icon: const Icon(IconsaxPlusLinear.wallet_3, color: BmnColors.green600, size: 20),
                        onChange: (_) => setState(() => _selectedPaymentMethod = '3Z Wallet'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Order Review Summary
                _buildSectionHeader('Order Summary (${cartState.totalItemCount} items)', IconsaxPlusLinear.receipt_text),
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
                      ...cartState.items.map((i) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${i.quantity}x ${i.product.name}',
                                    style: const TextStyle(fontSize: 13, color: BmnColors.gray600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.format(i.itemTotal),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                              ],
                            ),
                          )),
                      const Divider(height: 20, color: BmnColors.gray200),
                      _buildPriceRow('Subtotal', CurrencyFormatter.format(cartState.subtotal)),
                      const SizedBox(height: 4),
                      _buildPriceRow('Sales Tax (7%)', CurrencyFormatter.format(cartState.taxAmount)),
                      const SizedBox(height: 4),
                      _buildPriceRow(
                        'Delivery Fee',
                        cartState.deliveryFee == 0 ? 'FREE' : CurrencyFormatter.format(cartState.deliveryFee),
                        highlight: cartState.deliveryFee == 0,
                      ),
                      const Divider(height: 16, color: BmnColors.gray200),
                      _buildPriceRow('Total Amount', CurrencyFormatter.format(cartState.totalAmount), isBold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Place Order Button with BmnButton
                BmnButton(
                  text: 'Place Order • ${CurrencyFormatter.format(cartState.totalAmount)}',
                  size: BmnButtonSize.lg,
                  variant: BmnButtonVariant.primary,
                  processing: _isProcessing,
                  icon: IconsaxPlusLinear.tick_circle,
                  onPressed: _isProcessing ? null : () => _handlePlaceOrder(cartState),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: BmnColors.primaryDark),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: BmnColors.gray900),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false, bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? BmnColors.gray900 : BmnColors.gray500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 17 : 13,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
            color: highlight
                ? BmnColors.green600
                : isBold
                    ? BmnColors.primaryDark
                    : BmnColors.gray900,
          ),
        ),
      ],
    );
  }
}
