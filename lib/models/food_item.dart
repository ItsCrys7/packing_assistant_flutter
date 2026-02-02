class ListTemplateItem {
  final String id;
  final String name;
  final String notes;
  final String iconName;

  const ListTemplateItem({
    required this.id,
    required this.name,
    this.notes = '',
    this.iconName = '',
  });

  ListTemplateItem copyWith({
    String? id,
    String? name,
    String? notes,
    String? iconName,
  }) {
    return ListTemplateItem(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      iconName: iconName ?? this.iconName,
    );
  }
}
