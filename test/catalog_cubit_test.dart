import 'package:flutter_test/flutter_test.dart';
import 'package:threezinstacart/data/models/category.dart';
import 'package:threezinstacart/data/repositories/catalog_repository.dart';
import 'package:threezinstacart/logic/catalog/catalog_cubit.dart';
import 'package:threezinstacart/logic/catalog/catalog_state.dart';

void main() {
  group('CatalogCubit Tests', () {
    late CatalogRepository repository;
    late CatalogCubit cubit;

    setUp(() {
      repository = CatalogRepository();
      cubit = CatalogCubit(repository);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty products', () {
      expect(cubit.state.allProducts, isEmpty);
      expect(cubit.state.status, CatalogStatus.initial);
    });

    test('loadCatalog populates products and best sellers', () {
      cubit.loadCatalog();
      expect(cubit.state.status, CatalogStatus.loaded);
      expect(cubit.state.allProducts.length, greaterThanOrEqualTo(25));
      expect(cubit.state.bestSellers, isNotEmpty);
    });

    test('selectCategory filters by category', () {
      cubit.loadCatalog();
      cubit.selectCategory(ProductCategory.produce);
      expect(cubit.state.selectedCategory, ProductCategory.produce);
      expect(cubit.state.filteredProducts.every((p) => p.category == ProductCategory.produce), isTrue);
    });

    test('search filters products by name query', () {
      cubit.loadCatalog();
      cubit.search('Avocado');
      expect(cubit.state.filteredProducts.length, 1);
      expect(cubit.state.filteredProducts.first.name, contains('Avocado'));
    });
  });
}
