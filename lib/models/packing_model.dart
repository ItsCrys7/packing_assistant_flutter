import 'package:flutter/material.dart';

/// Single item in a packing list.
class PackingItem {
  String name;
  bool isChecked;

  /// Creates a packing item.
  PackingItem({required this.name, this.isChecked = false});

  /// Converts this item to JSON for persistence.
  Map<String, dynamic> toJson() => {
    'name': name,
    'isChecked': isChecked,
  }; // se face mapare la salvare

  /// Creates an item from JSON data.
  factory PackingItem.fromJson(Map<String, dynamic> json) {
    return PackingItem(name: json['name'], isChecked: json['isChecked']);
  }
}

/// Packing list category containing items and metadata.
class PackingCategory {
  // aici definim modelul pentru o categorie de ambalare
  String title; // Changed from final to allow editing
  final int iconCode; // Storing icon as int for saving
  final int colorValue; // Storing color as int for saving
  String quote;
  List<PackingItem> items;

  /// Creates a packing category.
  PackingCategory({
    required this.title,
    required this.iconCode,
    required this.colorValue,
    required this.quote,
    required this.items,
  });

  /// Returns the category icon.
  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

  /// Returns the category color.
  Color get color => Color(colorValue);

  /// Converts this category to JSON for persistence.
  Map<String, dynamic> toJson() => {
    'title': title,
    'iconCode': iconCode,
    'colorValue': colorValue,
    'quote': quote,
    'items': items.map((i) => i.toJson()).toList(),
  };

  /// Creates a category from JSON data.
  factory PackingCategory.fromJson(Map<String, dynamic> json) {
    // aici cream obiectul din map pentru incarcarea datelor
    var itemsList = json['items'] as List;
    List<PackingItem> packingItems = itemsList
        .map((i) => PackingItem.fromJson(i))
        .toList();

    return PackingCategory(
      title: json['title'],
      iconCode: json['iconCode'],
      colorValue: json['colorValue'],
      quote: json['quote'] ?? '',
      items: packingItems,
    );
  }
}
