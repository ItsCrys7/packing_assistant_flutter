class FoodItem {
  final String id;
  final String name;
  final int calories;
  final String imageAsset;

  const FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.imageAsset,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    int? calories,
    String? imageAsset,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      imageAsset: imageAsset ?? this.imageAsset,
    );
  }
}
