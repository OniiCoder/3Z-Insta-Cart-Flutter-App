import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/catalog_repository.dart';
import 'data/repositories/order_repository.dart';
import 'logic/cart/cart_cubit.dart';
import 'logic/catalog/catalog_cubit.dart';
import 'logic/order/order_cubit.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'theme/bmn_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final catalogRepository = CatalogRepository();
  final cartRepository = CartRepository();
  final orderRepository = OrderRepository();

  runApp(
    ThreeZInstaCartApp(
      catalogRepository: catalogRepository,
      cartRepository: cartRepository,
      orderRepository: orderRepository,
    ),
  );
}

class ThreeZInstaCartApp extends StatelessWidget {
  final CatalogRepository catalogRepository;
  final CartRepository cartRepository;
  final OrderRepository orderRepository;

  const ThreeZInstaCartApp({
    super.key,
    required this.catalogRepository,
    required this.cartRepository,
    required this.orderRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: catalogRepository),
        RepositoryProvider.value(value: cartRepository),
        RepositoryProvider.value(value: orderRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CatalogCubit(catalogRepository)..loadCatalog(),
          ),
          BlocProvider(
            create: (_) => CartCubit(cartRepository),
          ),
          BlocProvider(
            create: (_) => OrderCubit(orderRepository, catalogRepository),
          ),
        ],
        child: MaterialApp(
          title: '3Z Insta Cart',
          debugShowCheckedModeBanner: false,
          theme: BmnTheme.lightTheme,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
