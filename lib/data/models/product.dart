import 'package:equatable/equatable.dart';
import 'category.dart';

class Product extends Equatable {
  final int id;
  final String sku;
  final String name;
  final String description;
  final ProductCategory category;
  final double price;
  final double? originalPrice;
  final int stockQuantity;
  final String imageUrl;
  final String unit;
  final double rating;
  final int reviewCount;
  final bool isOrganic;
  final bool isBestSeller;

  const Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.stockQuantity,
    required this.imageUrl,
    required this.unit,
    this.rating = 4.8,
    this.reviewCount = 120,
    this.isOrganic = false,
    this.isBestSeller = false,
  });

  bool get inStock => stockQuantity > 0;
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  Product copyWith({
    int? id,
    String? sku,
    String? name,
    String? description,
    ProductCategory? category,
    double? price,
    double? originalPrice,
    int? stockQuantity,
    String? imageUrl,
    String? unit,
    double? rating,
    int? reviewCount,
    bool? isOrganic,
    bool? isBestSeller,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      imageUrl: imageUrl ?? this.imageUrl,
      unit: unit ?? this.unit,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isOrganic: isOrganic ?? this.isOrganic,
      isBestSeller: isBestSeller ?? this.isBestSeller,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sku,
        name,
        description,
        category,
        price,
        originalPrice,
        stockQuantity,
        imageUrl,
        unit,
        rating,
        reviewCount,
        isOrganic,
        isBestSeller,
      ];
}
