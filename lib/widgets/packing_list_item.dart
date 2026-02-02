import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../models/packing_model.dart';

/// List item widget for a packing list entry.
class PackingListItem extends StatelessWidget {
  final PackingItem item;
  final Color color;
  final bool isDeleteMode;
  final bool isSelectedForDelete;
  final Function(bool?) onCheckboxChanged;
  final VoidCallback onTapDelete;

  /// Creates a packing list item widget.
  const PackingListItem({
    super.key,
    required this.item,
    required this.color,
    required this.isDeleteMode,
    required this.isSelectedForDelete,
    required this.onCheckboxChanged,
    required this.onTapDelete,
  });

  /// Builds the list item UI based on the current mode.
  @override
  Widget build(BuildContext context) {
    // Luam tema curentă pentru a verifica dacă e Dark Mode sau nu
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. Daca suntem in modul de stergere
    if (isDeleteMode) {
      return Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        // MODIFICARE 1: Folosim o culoare transparenta care arată bine și pe Dark și pe Light
        color: isSelectedForDelete
            ? AppColors.deleteSelection.withOpacity(
                isDark ? 0.3 : 0.1,
              ) // <--- Mai închis pe Dark Mode
            : Colors.transparent,
        child: ListTile(
          leading: Icon(
            isSelectedForDelete ? Icons.check_circle : Icons.circle_outlined,
            color: AppColors.deleteSelection,
          ),
          // Aici nu puneai stil, deci Flutter lua automat culoarea corectă (Alb pe negru / Negru pe alb)
          title: Text(item.name),
          onTap: onTapDelete,
        ),
      );
    }

    // 2. Modul normal (Checklist)
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        item.name,
        style: TextStyle(
          fontSize: 16,
          decoration: item.isChecked
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          // MODIFICARE 2: Aici era problema cu textul invizibil
          // Dacă e bifat -> gri.
          // Dacă NU e bifat -> luăm culoarea textului din Tema curentă (Alb sau Negru)
          color: item.isChecked
              ? AppColors.checkedText
              : Theme.of(
                  context,
                ).textTheme.bodyLarge?.color, // <--- AICI E CHEIA
        ),
      ),
      value: item.isChecked,
      activeColor: color,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      onChanged: onCheckboxChanged,
    );
  }
}
