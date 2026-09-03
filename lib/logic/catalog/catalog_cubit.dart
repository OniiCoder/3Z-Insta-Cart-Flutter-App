import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/category.dart';
import '../../data/repositories/catalog_repository.dart';
import 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final CatalogRepository _repository;

  CatalogCubit(this._repository) : super(const CatalogState());

  void loadCatalog() {
    emit(state.copyWith(status: CatalogStatus.loading));
    try {
      final all = _repository.getAllProducts();
      emit(state.copyWith(
        status: CatalogStatus.loaded,
        allProducts: all,
        filteredProducts: all,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CatalogStatus.error,
        errorMessage: 'Failed to load grocery catalog: $e',
      ));
    }
  }

  void selectCategory(ProductCategory category) {
    emit(state.copyWith(selectedCategory: category));
    _applyFilter(category, state.searchQuery);
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilter(state.selectedCategory, query);
  }

  void _applyFilter(ProductCategory category, String query) {
    final results = _repository.searchProducts(query, category: category);
    emit(state.copyWith(filteredProducts: results));
  }
}
