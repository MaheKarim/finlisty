import 'package:equatable/equatable.dart';

/// Category entity for expense classification
/// Supports both English and Bangla names
class Category extends Equatable {
  final String id;
  final String nameEn; // English name
  final String nameBn; // Bangla name
  final String icon; // Icon identifier
  final String color; // Hex color code
  final int sortOrder; // For display ordering
  final bool isDefault; // Whether this is a default category
  final bool isActive; // Whether the category is active

  const Category({
    required this.id,
    required this.nameEn,
    required this.nameBn,
    required this.icon,
    required this.color,
    this.sortOrder = 0,
    this.isDefault = false,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        nameEn,
        nameBn,
        icon,
        color,
        sortOrder,
        isDefault,
        isActive,
      ];

  /// Get localized name based on language code
  String getLocalizedName(String languageCode) {
    return languageCode == 'bn' ? nameBn : nameEn;
  }

  /// Create a copy with modified fields
  Category copyWith({
    String? id,
    String? nameEn,
    String? nameBn,
    String? icon,
    String? color,
    int? sortOrder,
    bool? isDefault,
    bool? isActive,
  }) {
    return Category(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameBn: nameBn ?? this.nameBn,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
    );
  }
}
