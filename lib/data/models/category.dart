import 'package:flutter/material.dart';

enum ProductCategory {
  all,
  produce,
  dairyEggs,
  bakery,
  beverages,
  snacks,
  pantry,
  meatSeafood,
  frozen,
  organic,
  household,
}

extension ProductCategoryExtension on ProductCategory {
  String get displayName {
    switch (this) {
      case ProductCategory.all:
        return 'All';
      case ProductCategory.produce:
        return 'Produce';
      case ProductCategory.dairyEggs:
        return 'Dairy & Eggs';
      case ProductCategory.bakery:
        return 'Bakery';
      case ProductCategory.beverages:
        return 'Beverages';
      case ProductCategory.snacks:
        return 'Snacks';
      case ProductCategory.pantry:
        return 'Pantry';
      case ProductCategory.meatSeafood:
        return 'Meat & Seafood';
      case ProductCategory.frozen:
        return 'Frozen';
      case ProductCategory.organic:
        return 'Organic';
      case ProductCategory.household:
        return 'Household';
    }
  }

  IconData get icon {
    switch (this) {
      case ProductCategory.all:
        return Icons.grid_view_rounded;
      case ProductCategory.produce:
        return Icons.eco_rounded;
      case ProductCategory.dairyEggs:
        return Icons.egg_rounded;
      case ProductCategory.bakery:
        return Icons.bakery_dining_rounded;
      case ProductCategory.beverages:
        return Icons.local_cafe_rounded;
      case ProductCategory.snacks:
        return Icons.cookie_rounded;
      case ProductCategory.pantry:
        return Icons.kitchen_rounded;
      case ProductCategory.meatSeafood:
        return Icons.set_meal_rounded;
      case ProductCategory.frozen:
        return Icons.ac_unit_rounded;
      case ProductCategory.organic:
        return Icons.spa_rounded;
      case ProductCategory.household:
        return Icons.cleaning_services_rounded;
    }
  }
}
