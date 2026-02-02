import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../common/app_constants.dart';
import '../models/packing_model.dart';

/// Builds the predefined packing lists used on first run.
class DefaultLists {
  /// Returns a list of default categories with items.
  static List<PackingCategory> build({
    required Map<int, String> iconQuotesByCodePoint,
  }) {
    return [
      _buildCategory(
        title: AppConstants.homeCategoryTitle,
        icon: Icons.home,
        color: AppColors.defaultHomeCategory,
        iconQuotesByCodePoint: iconQuotesByCodePoint,
        items: [
          PackingItem(name: AppConstants.itemKeys),
          PackingItem(name: AppConstants.itemWallet),
          PackingItem(name: AppConstants.itemPhone),
          PackingItem(name: AppConstants.itemCharger),
        ],
      ),
      _buildCategory(
        title: AppConstants.universityCategoryTitle,
        icon: Icons.school,
        color: AppColors.defaultUniversityCategory,
        iconQuotesByCodePoint: iconQuotesByCodePoint,
        items: [
          PackingItem(name: AppConstants.itemLaptop),
          PackingItem(name: AppConstants.itemCharger),
          PackingItem(name: AppConstants.itemIdCard),
        ],
      ),
    ];
  }

  /// Creates a single default category with the provided items.
  static PackingCategory _buildCategory({
    required String title,
    required IconData icon,
    required Color color,
    required Map<int, String> iconQuotesByCodePoint,
    List<PackingItem>? items,
  }) {
    return PackingCategory(
      title: title,
      iconCode: icon.codePoint,
      colorValue: color.value,
      quote: iconQuotesByCodePoint[icon.codePoint] ?? AppConstants.defaultQuote,
      items: items ?? <PackingItem>[],
    );
  }
}
