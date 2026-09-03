import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../components/bmn_badge.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/product.dart';
import '../../logic/cart/cart_cubit.dart';
import '../../logic/cart/cart_state.dart';
import '../../theme/bmn_theme.dart';
import '../screens/product_detail/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BmnColors.gray200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with BmnBadge for Organic / Deal
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 1.25,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: BmnColors.gray100,
                        child: const Center(
                          child: Icon(IconsaxPlusLinear.shopping_bag, color: BmnColors.gray400, size: 36),
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: BmnColors.gray100,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: BmnColors.primary),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (product.isOrganic)
                  const Positioned(
                    top: 8,
                    left: 8,
                    child: BmnBadge(
                      label: 'ORGANIC',
                      variant: BmnBadgeVariant.success,
                      icon: IconsaxPlusLinear.tree,
                    ),
                  ),
                if (product.hasDiscount)
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: BmnBadge(
                      label: 'SALE',
                      variant: BmnBadgeVariant.warning,
                      icon: IconsaxPlusLinear.discount_shape,
                    ),
                  ),
              ],
            ),

            // Product Information
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: BmnColors.gray900,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.unit,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BmnColors.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.hasDiscount)
                              Text(
                                CurrencyFormatter.format(product.originalPrice!),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: BmnColors.gray400,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              CurrencyFormatter.format(product.price),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: BmnColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                        _buildCartActionButton(context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartActionButton(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final quantity = state.getProductQuantity(product.id);

        if (quantity == 0) {
          return InkWell(
            onTap: () {
              context.read<CartCubit>().addItem(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to cart'),
                  duration: const Duration(milliseconds: 1200),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: BmnColors.primaryDark,
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: BmnColors.brand50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: BmnColors.brand200),
              ),
              child: Icon(IconsaxPlusLinear.add, color: BmnColors.primaryDark, size: 20),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: BmnColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => context.read<CartCubit>().updateQuantity(product.id, quantity - 1),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Icon(IconsaxPlusLinear.minus, color: Colors.white, size: 14),
                ),
              ),
              Text(
                '$quantity',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              InkWell(
                onTap: () => context.read<CartCubit>().updateQuantity(product.id, quantity + 1),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Icon(IconsaxPlusLinear.add, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
