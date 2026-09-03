import 'package:equatable/equatable.dart';
import '../../data/models/category.dart';
import '../../data/models/product.dart';

enum CatalogStatus { initial, loading, loaded, error }

class CatalogState extends Equatable {
  final CatalogStatus status;
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final ProductCategory selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  const CatalogState({
    this.status = CatalogStatus.initial,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.selectedCategory = ProductCategory.all,
    this.searchQuery = '',
    this.errorMessage,
  });

  List<Product> get bestSellers => allProducts.where((p) => p.isBestSeller).toList();
  List<Product> get deals => allProducts.where((p) => p.hasDiscount).toList();

  CatalogState copyWith({
    CatalogStatus? status,
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    ProductCategory? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return CatalogState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allProducts,
        filteredProducts,
        selectedCategory,
        searchQuery,
        errorMessage,
      ];
}
