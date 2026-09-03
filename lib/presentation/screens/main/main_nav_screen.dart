import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/category.dart';
import '../../../logic/cart/cart_cubit.dart';
import '../../../logic/cart/cart_state.dart';
import '../../../logic/catalog/catalog_cubit.dart';
import '../cart/cart_screen.dart';
import '../home/home_screen.dart';
import '../orders/orders_list_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => MainNavScreenState();
}

class MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  void selectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const _CategoriesExploreTab(),
      const CartScreen(),
      const OrdersListScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          return NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: selectTab,
            indicatorColor: AppColors.primaryLight,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.storefront_outlined),
                selectedIcon: Icon(Icons.storefront_rounded, color: AppColors.primaryDark),
                label: 'Shop',
              ),
              NavigationDestination(
                icon: const Icon(Icons.grid_view_outlined),
                selectedIcon: Icon(Icons.grid_view_rounded, color: AppColors.primaryDark),
                label: 'Categories',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: cartState.totalItemCount > 0,
                  label: Text('${cartState.totalItemCount}'),
                  backgroundColor: AppColors.primaryDark,
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: cartState.totalItemCount > 0,
                  label: Text('${cartState.totalItemCount}'),
                  backgroundColor: AppColors.primaryDark,
                  child: Icon(Icons.shopping_bag_rounded, color: AppColors.primaryDark),
                ),
                label: 'Cart',
              ),
              NavigationDestination(
                icon: const Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long_rounded, color: AppColors.primaryDark),
                label: 'Orders',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoriesExploreTab extends StatelessWidget {
  const _CategoriesExploreTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Categories'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: ProductCategory.values.where((c) => c != ProductCategory.all).length,
        itemBuilder: (context, index) {
          final cat = ProductCategory.values.where((c) => c != ProductCategory.all).toList()[index];
          return InkWell(
            onTap: () {
              context.read<CatalogCubit>().selectCategory(cat);
              final navState = context.findAncestorStateOfType<MainNavScreenState>();
              if (navState != null) {
                navState.selectTab(0);
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(cat.icon, color: AppColors.primaryDark, size: 28),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    cat.displayName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
