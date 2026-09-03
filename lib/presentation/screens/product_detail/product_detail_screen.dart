import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../components/bmn_badge.dart';
import '../../../components/bmn_button.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/category.dart';
import '../../../data/models/product.dart';
import '../../../logic/cart/cart_cubit.dart';
import '../../../theme/bmn_theme.dart';
import '../../widgets/cart_badge_icon.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.category.displayName),
        actions: const [
          CartBadgeIcon(),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Hero Image
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.1,
                  child: Image.network(
                    p.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: BmnColors.gray100,
                      child: const Center(
                        child: Icon(IconsaxPlusLinear.shopping_bag, size: 60, color: BmnColors.gray400),
                      ),
                    ),
                  ),
                ),
                if (p.isOrganic)
                  const Positioned(
                    top: 16,
                    left: 16,
                    child: BmnBadge(
                      label: '100% ORGANIC',
                      variant: BmnBadgeVariant.success,
                      icon: IconsaxPlusLinear.tree,
                    ),
                  ),
                if (p.hasDiscount)
                  const Positioned(
                    top: 16,
                    right: 16,
                    child: BmnBadge(
                      label: 'SPECIAL OFFER',
                      variant: BmnBadgeVariant.warning,
                      icon: IconsaxPlusLinear.discount_shape,
                    ),
                  ),
              ],
            ),

            // Product Details Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        p.unit,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: BmnColors.gray500,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: BmnColors.orange500, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${p.rating} (${p.reviewCount})',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: BmnColors.gray900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: BmnColors.gray900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Pricing
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        CurrencyFormatter.format(p.price),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: BmnColors.primaryDark,
                        ),
                      ),
                      if (p.hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          CurrencyFormatter.format(p.originalPrice!),
                          style: const TextStyle(
                            fontSize: 16,
                            color: BmnColors.gray400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: BmnColors.gray200),
                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'About this item',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: BmnColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: BmnColors.gray600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stock & Guarantee Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: BmnColors.brand50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: BmnColors.brand200),
                    ),
                    child: Row(
                      children: [
                        Icon(IconsaxPlusBold.verify, color: BmnColors.primaryDark, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.inStock ? 'In Stock (${p.stockQuantity} available)' : 'Out of Stock',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: BmnColors.primaryDark,
                                ),
                              ),
                              const Text(
                                'Freshness guaranteed or 100% money back',
                                style: TextStyle(fontSize: 12, color: BmnColors.gray600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          child: Row(
            children: [
              // Quantity selector
              Container(
                decoration: BoxDecoration(
                  color: BmnColors.gray50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: BmnColors.gray200),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(IconsaxPlusLinear.minus, size: 16),
                      onPressed: _selectedQuantity > 1
                          ? () => setState(() => _selectedQuantity--)
                          : null,
                    ),
                    Text(
                      '$_selectedQuantity',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(IconsaxPlusLinear.add, size: 16),
                      onPressed: () => setState(() => _selectedQuantity++),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Add to Cart Button with BmnButton
              Expanded(
                child: BmnButton(
                  text: 'Add to Cart • ${CurrencyFormatter.format(p.price * _selectedQuantity)}',
                  size: BmnButtonSize.lg,
                  variant: BmnButtonVariant.primary,
                  icon: IconsaxPlusLinear.shopping_bag,
                  onPressed: () {
                    context.read<CartCubit>().addItem(p, quantity: _selectedQuantity);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added $_selectedQuantity x ${p.name} to cart'),
                        duration: const Duration(milliseconds: 1500),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: BmnColors.primaryDark,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
