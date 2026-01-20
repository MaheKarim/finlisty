import 'package:flutter/material.dart';

/// Shadcn-inspired color system for Finlisty
/// Modern, clean, and accessible color palette
class AppColors {
  // ========================
  // Primary Colors
  // ========================
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color accentCyan = Color(0xFF06B6D4);

  // ========================
  // Neutral Colors
  // ========================
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  // ========================
  // Semantic Colors
  // ========================
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF38BDF8);

  // ========================
  // Transaction Type Colors
  // ========================
  static const Color income = success;
  static const Color expense = error;

  // ========================
  // Category Colors
  // ========================
  static const Color categoryFood = Color(0xFFF59E0B);
  static const Color categoryTransport = Color(0xFF3B82F6);
  static const Color categoryRent = Color(0xFFEF4444);
  static const Color categoryBill = Color(0xFFEF4444);
  static const Color categoryEntertainment = Color(0xFFEC4899);
  static const Color categoryHealth = Color(0xFF10B981);
  static const Color categoryShopping = Color(0xFF8B5CF6);
  static const Color categoryOther = primaryIndigo;
  static const Color categoryOthers = categoryOther;

  // ========================
  // Local Wallet Colors
  // ========================
  static const Color bkash = Color(0xFFE2136E);
  static const Color nagad = Color(0xFFF1592A);

  // ========================
  // Gradients (Subtle, max 2 colors)
  // ========================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryIndigo],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF4ADE80)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ========================
  // Shadows
  // ========================
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      offset: const Offset(0, 4),
      blurRadius: 20,
    ),
  ];

  // ========================
  // Currency Symbol
  // ========================
  static const String currencySymbol = '৳'; // Bangladeshi Taka

  // ========================
  // Helper Methods
  // ========================
  static Color getWalletColor(String type) {
    switch (type.toLowerCase()) {
      case 'bkash':
        return bkash;
      case 'nagad':
        return nagad;
      case 'bank':
        return primaryBlue;
      case 'cash':
        return success;
      default:
        return textSecondary;
    }
  }

  static Color getWalletLightColor(String type) {
    return getWalletColor(type).withOpacity(0.1);
  }

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
      case 'dining':
        return const Color(0xFFF59E0B);
      case 'shopping':
        return const Color(0xFF8B5CF6);
      case 'transport':
      case 'fuel':
        return const Color(0xFF3B82F6);
      case 'bills':
      case 'utilities':
        return const Color(0xFFEF4444);
      case 'entertainment':
        return const Color(0xFFEC4899);
      case 'health':
      case 'medical':
        return const Color(0xFF10B981);
      case 'education':
        return const Color(0xFF6366F1);
      case 'income':
      case 'salary':
        return const Color(0xFF10B981);
      default:
        return primaryIndigo;
    }
  }

  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
      case 'dining':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_bag;
      case 'transport':
      case 'fuel':
        return Icons.directions_car;
      case 'bills':
      case 'utilities':
        return Icons.receipt;
      case 'entertainment':
        return Icons.movie;
      case 'health':
      case 'medical':
        return Icons.medical_services;
      case 'education':
        return Icons.school;
      case 'income':
      case 'salary':
        return Icons.payments;
      default:
        return Icons.category;
    }
  }
}
