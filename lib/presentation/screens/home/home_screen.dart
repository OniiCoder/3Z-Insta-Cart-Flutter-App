import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../components/bmn_avatar.dart';
import '../../../components/bmn_text_input.dart';
import '../../../data/models/category.dart';
import '../../../logic/catalog/catalog_cubit.dart';
import '../../../logic/catalog/catalog_state.dart';
import '../../../theme/bmn_theme.dart';
import '../../widgets/cart_badge_icon.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const BmnAvatar(
              size: BmnAvatarSize.sm,
              child: Text(
                '3Z',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(IconsaxPlusLinear.location, color: BmnColors.orange500, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Delivering to',
                      style: TextStyle(fontSize: 11, color: BmnColors.gray500, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Springfield, 97477',
                      style: TextStyle(fontSize: 11, color: BmnColors.gray800, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '3Z Insta Cart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: BmnColors.primaryDark,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          CartBadgeIcon(),
          SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<CatalogCubit, CatalogState>(
        builder: (context, state) {
          if (state.status == CatalogStatus.loading) {
            return Center(child: CircularProgressIndicator(color: BmnColors.primary));
          }

          return CustomScrollView(
            slivers: [
              // BmnTextInput Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: BmnTextInput(
                    placeholder: 'Search organic avocados, milk, sourdough...',
                    onChanged: (val) => context.read<CatalogCubit>().search(val),
                    startContent: const Icon(IconsaxPlusLinear.search_normal_1, color: BmnColors.gray400, size: 18),
                    endContent: state.searchQuery.isNotEmpty
                        ? GestureDetector(
                            onTap: () => context.read<CatalogCubit>().search(''),
                            child: const Icon(IconsaxPlusLinear.close_circle, color: BmnColors.gray400, size: 18),
                          )
                        : null,
                  ),
                ),
              ),

              // Promotional Banner with Bmn styling
              if (state.searchQuery.isEmpty && state.selectedCategory == ProductCategory.all)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Container(
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
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    '⚡ FREE DELIVERY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Free Delivery on Orders over \$35',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Farm-fresh produce, dairy, bakery & snacks',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(IconsaxPlusBold.flash_circle, color: BmnColors.orange400, size: 54),
                        ],
                      ),
                    ),
                  ),
                ),

              // Categories Horizontal List
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: ProductCategory.values.length,
                    itemBuilder: (context, index) {
                      final cat = ProductCategory.values[index];
                      return CategoryChip(
                        category: cat,
                        isSelected: state.selectedCategory == cat,
                        onTap: () => context.read<CatalogCubit>().selectCategory(cat),
                      );
                    },
                  ),
                ),
              ),

              // Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Text(
                    state.searchQuery.isNotEmpty
                        ? 'Search Results (${state.filteredProducts.length})'
                        : '${state.selectedCategory.displayName} Products (${state.filteredProducts.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: BmnColors.gray900,
                    ),
                  ),
                ),
              ),

              // Product Grid
              if (state.filteredProducts.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(IconsaxPlusLinear.search_status, size: 56, color: BmnColors.gray400),
                          SizedBox(height: 16),
                          Text(
                            'No items match your search',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BmnColors.gray700),
                          ),
                          SizedBox(height: 4),
                          Text('Try searching with different keywords', style: TextStyle(color: BmnColors.gray400)),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.64,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = state.filteredProducts[index];
                        return ProductCard(product: product);
                      },
                      childCount: state.filteredProducts.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
