import '../datasources/mock_grocery_data.dart';
import '../models/category.dart';
import '../models/product.dart';

class CatalogRepository {
  final List<Product> _products = List.from(MockGroceryData.products);

  List<Product> getAllProducts() {
    return List.unmodifiable(_products);
  }

  List<Product> getProductsByCategory(ProductCategory category) {
    if (category == ProductCategory.all) {
      return getAllProducts();
    }
    if (category == ProductCategory.organic) {
      return _products.where((p) => p.isOrganic).toList();
    }
    return _products.where((p) => p.category == category).toList();
  }

  List<Product> searchProducts(String query, {ProductCategory category = ProductCategory.all}) {
    final cleanQuery = query.toLowerCase().trim();
    List<Product> baseList = getProductsByCategory(category);

    if (cleanQuery.isEmpty) {
      return baseList;
    }

    return baseList.where((p) {
      return p.name.toLowerCase().contains(cleanQuery) ||
          p.description.toLowerCase().contains(cleanQuery) ||
          p.sku.toLowerCase().contains(cleanQuery);
    }).toList();
  }

  Product? getProductById(int id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void deductStock(int productId, int quantity) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final current = _products[index];
      final newStock = (current.stockQuantity - quantity).clamp(0, 99999);
      _products[index] = current.copyWith(stockQuantity: newStock);
    }
  }

  void restoreStock(int productId, int quantity) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final current = _products[index];
      _products[index] = current.copyWith(stockQuantity: current.stockQuantity + quantity);
    }
  }
}
