import 'package:flutter/material.dart';

class PackingItem {
  String name;
  bool isChecked;

  PackingItem({required this.name, this.isChecked = false});

  // Convert object to Map (for saving)
  Map<String, dynamic> toJson() => {
        'name': name,
        'isChecked': isChecked,
      };

  // Create object from Map (for loading)
  factory PackingItem.fromJson(Map<String, dynamic> json) {
    return PackingItem(
      name: json['name'],
      isChecked: json['isChecked'],
    );
  }
}

class PackingCategory {
  String title; // Changed from final to allow editing
  final int iconCode; // Storing icon as int for saving
  final int colorValue; // Storing color as int for saving
  List<PackingItem> items;

  PackingCategory({
    required this.title,
    required this.iconCode,
    required this.colorValue,
    required this.items,
  });

  // Helper to get IconData from int
  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');
  
  // Helper to get Color from int
  Color get color => Color(colorValue);

  Map<String, dynamic> toJson() => {
        'title': title,
        'iconCode': iconCode,
        'colorValue': colorValue,
        'items': items.map((i) => i.toJson()).toList(),
      };

  factory PackingCategory.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<PackingItem> packingItems = itemsList.map((i) => PackingItem.fromJson(i)).toList();

    return PackingCategory(
      title: json['title'],
      iconCode: json['iconCode'],
      colorValue: json['colorValue'],
      items: packingItems,
    );
  }
}