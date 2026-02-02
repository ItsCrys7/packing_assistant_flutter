/// Template item used for predefined packing entries.
class PackingTemplateItem {
  final String id;
  final String name;
  final String notes;
  final int iconCode;

  /// Creates a template item.
  const PackingTemplateItem({
    required this.id,
    required this.name,
    this.notes = '',
    this.iconCode = 0,
  });

  /// Returns a copy with the provided fields replaced.
  PackingTemplateItem copyWith({
    // ma ajuta sa inlocuiesc anumite valori din obiect fara a crea unul nou de la 0 si fara sa afectez valorile existente
    String? id,
    String? name,
    String? notes,
    int? iconCode,
  }) {
    return PackingTemplateItem(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      iconCode: iconCode ?? this.iconCode,
    );
  }
}
