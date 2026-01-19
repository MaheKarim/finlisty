import 'package:finlisty/features/category/domain/entities/category.dart';

/// Category model for Firestore serialization/deserialization
class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.nameEn,
    required super.nameBn,
    required super.icon,
    required super.color,
    super.sortOrder = 0,
    super.isDefault = false,
    super.isActive = true,
  });

  /// Create CategoryModel from Firestore document
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameBn: json['nameBn'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      sortOrder: json['sortOrder'] as int? ?? 0,
      isDefault: json['isDefault'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Convert CategoryModel to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameBn': nameBn,
      'icon': icon,
      'color': color,
      'sortOrder': sortOrder,
      'isDefault': isDefault,
      'isActive': isActive,
    };
  }

  /// Convert to Category entity
  Category toEntity() {
    return Category(
      id: id,
      nameEn: nameEn,
      nameBn: nameBn,
      icon: icon,
      color: color,
      sortOrder: sortOrder,
      isDefault: isDefault,
      isActive: isActive,
    );
  }

  /// Create CategoryModel from Category entity
  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      nameEn: category.nameEn,
      nameBn: category.nameBn,
      icon: category.icon,
      color: category.color,
      sortOrder: category.sortOrder,
      isDefault: category.isDefault,
      isActive: category.isActive,
    );
  }

  /// Default categories for new users
  static List<CategoryModel> getDefaultCategories() {
    return [
      CategoryModel(
        id: 'cat_food',
        nameEn: 'Food',
        nameBn: 'খাবার',
        icon: 'restaurant',
        color: '#F97316',
        sortOrder: 1,
        isDefault: true,
      ),
      CategoryModel(
        id: 'cat_transport',
        nameEn: 'Transport',
        nameBn: 'যাতায়াত',
        icon: 'directions_bus',
        color: '#3B82F6',
        sortOrder: 2,
        isDefault: true,
      ),
      CategoryModel(
        id: 'cat_rent',
        nameEn: 'Rent',
        nameBn: 'ভাড়া',
        icon: 'home',
        color: '#8B5CF6',
        sortOrder: 3,
        isDefault: true,
      ),
      CategoryModel(
        id: 'cat_bill',
        nameEn: 'Bill',
        nameBn: 'বিল',
        icon: 'receipt',
        color: '#EF4444',
        sortOrder: 4,
        isDefault: true,
      ),
      CategoryModel(
        id: 'cat_shopping',
        nameEn: 'Shopping',
        nameBn: 'শপিং',
        icon: 'shopping_bag',
        color: '#EC4899',
        sortOrder: 5,
        isDefault: true,
      ),
      CategoryModel(
        id: 'cat_health',
        nameEn: 'Health',
        nameBn: 'স্বাস্থ্য',
        icon: 'local_hospital',
        color: '#22C55E',
        sortOrder: 6,
        isDefault: true,
      ),
      CategoryModel(
        id: 'cat_others',
        nameEn: 'Others',
        nameBn: 'অন্যান্য',
        icon: 'more_horiz',
        color: '#64748B',
        sortOrder: 7,
        isDefault: true,
      ),
    ];
  }
}
