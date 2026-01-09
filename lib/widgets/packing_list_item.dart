import 'package:flutter/material.dart';
import '../models/packing_model.dart';

class PackingListItem extends StatelessWidget {
  final PackingItem item;
  final Color color;
  final bool isDeleteMode;
  final bool isSelectedForDelete;
  final Function(bool?) onCheckboxChanged;
  final VoidCallback onTapDelete;

  const PackingListItem({
    super.key,
    required this.item,
    required this.color,
    required this.isDeleteMode,
    required this.isSelectedForDelete,
    required this.onCheckboxChanged,
    required this.onTapDelete,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Daca suntem in modul de stergere
    if (isDeleteMode) {
      return Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        color: isSelectedForDelete ? Colors.red[50] : Colors.transparent,
        child: ListTile(
          leading: Icon(
            isSelectedForDelete ? Icons.check_circle : Icons.circle_outlined,
            color: Colors.red,
          ),
          title: Text(item.name),
          onTap: onTapDelete,
        ),
      );
    }

    // 2. Modul normal (Checklist)
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading, // Checkbox in stanga
      title: Text(
        item.name,
        style: TextStyle(
          fontSize: 16,
          decoration: item.isChecked ? TextDecoration.lineThrough : TextDecoration.none,
          color: item.isChecked ? Colors.grey : Colors.black87,
        ),
      ),
      value: item.isChecked,
      activeColor: color,
      checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      onChanged: onCheckboxChanged,
    );
  }
}