import 'package:flutter/material.dart';

/// Shadcn-inspired color system for Finlisty
/// Modern, clean, and accessible color palette
class AppColors {
  // ========================
  // Primary Colors (Teal/Emerald theme)
  // ========================
  static const Color primary = Color(0xFF10B981); // Emerald 500
  static const Color primaryDark = Color(0xFF059669); // Emerald 600
  static const Color primaryLight = Color(0xFF34D399); // Emerald 400
  static const Color primaryContainer = Color(0xFFD1FAE5); // Emerald 100
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ========================
  // Secondary / Accent
  // ========================
  static const Color secondary = Color(0xFF64748B); // Slate 500
  static const Color secondaryContainer = Color(0xFFF1F5F9); // Slate 100
  static const Color onSecondary = Color(0xFFFFFFFF);

  // ========================
  // Backgrounds (Light Mode)
  // ========================
  static const Color backgroundLight = Color(0xFFFAFAFA); // Neutral 50
  static const Color surfaceLight = Color(0xFFFFFFFF); // White
  static const Color surfaceVariantLight = Color(0xFFF8FAFC); // Slate 50
  static const Color cardLight = Color(0xFFFFFFFF);

  // ========================
  // Backgrounds (Dark Mode)
  // ========================
  static const Color backgroundDark = Color(0xFF09090B); // Zinc 950
  static const Color surfaceDark = Color(0xFF18181B); // Zinc 900
  static const Color surfaceVariantDark = Color(0xFF27272A); // Zinc 800
  static const Color cardDark = Color(0xFF18181B);

  // ========================
  // Functional Colors
  // ========================
  static const Color success = Color(0xFF22C55E); // Green 500
  static const Color successLight = Color(0xFFDCFCE7); // Green 100
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorLight = Color(0xFFFEE2E2); // Red 100
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningLight = Color(0xFFFEF3C7); // Amber 100
  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color infoLight = Color(0xFFDBEAFE); // Blue 100

  // ========================
  // Transaction Type Colors
  // ========================
  static const Color income = Color(0xFF22C55E); // Green 500
  static const Color expense = Color(0xFFEF4444); // Red 500

  // ========================
  // Currency Symbol
  // ========================
  static const String currencySymbol = '৳'; // Bangladeshi Taka

  // ========================
  // Text Colors (Light Mode)
  // ========================
  static const Color textPrimaryLight = Color(0xFF0F172A); // Slate 900
  static const Color textSecondaryLight = Color(0xFF64748B); // Slate 500
  static const Color textTertiaryLight = Color(0xFF94A3B8); // Slate 400
  static const Color textDisabledLight = Color(0xFFCBD5E1); // Slate 300

  // ========================
  // Text Colors (Dark Mode)
  // ========================
  static const Color textPrimaryDark = Color(0xFFFAFAFA); // Neutral 50
  static const Color textSecondaryDark = Color(0xFFA1A1AA); // Zinc 400
  static const Color textTertiaryDark = Color(0xFF71717A); // Zinc 500
  static const Color textDisabledDark = Color(0xFF52525B); // Zinc 600

  // ========================
  // Border Colors
  // ========================
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200
  static const Color borderDark = Color(0xFF27272A); // Zinc 800
  static const Color inputBorderLight = Color(0xFFCBD5E1); // Slate 300
  static const Color inputBorderDark = Color(0xFF3F3F46); // Zinc 700

  // ========================
  // Shadow Colors
  // ========================
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x14000000);
  static const Color shadowDark = Color(0x1F000000);

  // ========================
  // Wallet Specific Colors
  // ========================
  static const Color cash = Color(0xFF10B981); // Emerald
  static const Color cashLight = Color(0xFFD1FAE5);
  static const Color bkash = Color(0xFFE2136E); // bKash Pink
  static const Color bkashLight = Color(0xFFFCE7F3);
  static const Color nagad = Color(0xFFFB923C); // Nagad Orange
  static const Color nagadLight = Color(0xFFFED7AA);
  static const Color bank = Color(0xFF3B82F6); // Blue
  static const Color bankLight = Color(0xFFDBEAFE);
  static const Color other = Color(0xFF8B5CF6); // Violet
  static const Color otherLight = Color(0xFFEDE9FE);

  // ========================
  // Category Colors
  // ========================
  static const Color categoryFood = Color(0xFFF97316); // Orange
  static const Color categoryTransport = Color(0xFF3B82F6); // Blue
  static const Color categoryRent = Color(0xFF8B5CF6); // Violet
  static const Color categoryBill = Color(0xFFEF4444); // Red
  static const Color categoryShopping = Color(0xFFEC4899); // Pink
  static const Color categoryHealth = Color(0xFF22C55E); // Green
  static const Color categoryOthers = Color(0xFF64748B); // Slate

  // ========================
  // Gradient Colors
  // ========================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient incomeGradient = LinearGradient(
    colors: [success, Color(0xFF4ADE80)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [error, Color(0xFFF87171)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ========================
  // Helper Methods
  // ========================
  static Color getWalletColor(String type) {
    switch (type.toLowerCase()) {
      case 'cash':
        return cash;
      case 'bkash':
        return bkash;
      case 'nagad':
        return nagad;
      case 'bank':
        return bank;
      default:
        return other;
    }
  }

  static Color getWalletLightColor(String type) {
    switch (type.toLowerCase()) {
      case 'cash':
        return cashLight;
      case 'bkash':
        return bkashLight;
      case 'nagad':
        return nagadLight;
      case 'bank':
        return bankLight;
      default:
        return otherLight;
    }
  }

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return categoryFood;
      case 'transport':
        return categoryTransport;
      case 'rent':
        return categoryRent;
      case 'bill':
        return categoryBill;
      case 'shopping':
        return categoryShopping;
      case 'health':
        return categoryHealth;
      default:
        return categoryOthers;
    }
  }
}
