import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart'; // <--- IMPORT IMPORTANT
import 'package:flutter/services.dart';
import '../models/packing_model.dart';
import '../widgets/packing_list_item.dart'; // <--- Importam widgetul nou creat

class ChecklistScreen extends StatefulWidget {
  final PackingCategory category;
  final VoidCallback onUpdate;

  const ChecklistScreen({
    super.key,
    required this.category,
    required this.onUpdate,
  });

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  bool isDeleteMode = false;
  // Nota: Am sters "isMenuOpen", SpeedDial se ocupa singur de asta!
  List<PackingItem> itemsToDelete = [];

  void _showInputDialog({
    required String title,
    String initialValue = '',
    String hint = '',
    required Function(String) onSave,
  }) {
    final controller = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (context) => Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.tab): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        },
        child: Actions(
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (intent) {
                if (controller.text.isNotEmpty) {
                  onSave(controller.text);
                  Navigator.pop(context);
                }
                return null;
              },
            ),
          },
          child: Focus(
            // ensures shortcuts receive focus
            autofocus: true,
            child: AlertDialog(
              title: Text(title),
              content: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(hintText: hint),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      onSave(controller.text);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Logic Methods ---
  void _addNewTask() {
    _showInputDialog(
      title: "Add New Item",
      hint: "Item name (e.g. Towel)",
      onSave: (text) {
        setState(() {
          widget.category.items.add(PackingItem(name: text));
        });
        widget.onUpdate();
      },
    );
  }

  void _editTitle() {
    _showInputDialog(
      title: "Rename List",
      initialValue: widget.category.title,
      onSave: (text) {
        setState(() => widget.category.title = text);
        widget.onUpdate();
      },
    );
  }

  void _resetList() {
    setState(() {
      for (var item in widget.category.items) item.isChecked = false;
    });
    widget.onUpdate();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("List reset!"),
        backgroundColor: widget.category.color,
      ),
    );
  }

  void _deleteSelectedItems() {
    setState(() {
      widget.category.items.removeWhere((item) => itemsToDelete.contains(item));
      itemsToDelete.clear();
      isDeleteMode = false;
    });
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final String headerQuote = widget.category.quote.isNotEmpty
        ? widget.category.quote
        : "Pack smart and travel light.";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDeleteMode ? Colors.red : widget.category.color,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(child: Text(widget.category.title)),
            if (!isDeleteMode)
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: _editTitle,
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDeleteMode ? Icons.check : Icons.delete),
            onPressed: () {
              if (isDeleteMode && itemsToDelete.isNotEmpty) {
                _deleteSelectedItems();
              } else {
                setState(() {
                  isDeleteMode = !isDeleteMode;
                  itemsToDelete.clear();
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          if (!isDeleteMode)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.category.color.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(
                      widget.category.icon,
                      color: widget.category.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    headerQuote,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

          if (isDeleteMode)
            Container(
              color: Colors.red[50],
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: const Text(
                "Tap items to delete",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ),

          // LISTA EFICIENTA
          Expanded(
            child: widget.category.items.isEmpty
                ? const Center(child: Text("List is empty."))
                : ListView.separated(
                    padding: const EdgeInsets.only(
                      bottom: 80,
                    ), // Loc pentru butonul SpeedDial
                    itemCount: widget.category.items.length,
                    separatorBuilder: (ctx, i) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = widget.category.items[index];

                      // AICI FOLOSIM WIDGETUL NOU SI EFICIENT
                      return PackingListItem(
                        item: item,
                        color: widget.category.color,
                        isDeleteMode: isDeleteMode,
                        isSelectedForDelete: itemsToDelete.contains(item),
                        onCheckboxChanged: (val) {
                          setState(() => item.isChecked = val ?? false);
                          widget.onUpdate();
                        },
                        onTapDelete: () {
                          setState(() {
                            if (itemsToDelete.contains(item)) {
                              itemsToDelete.remove(item);
                            } else {
                              itemsToDelete.add(item);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // IMPLEMENTAREA SPEED DIAL
      floatingActionButton: isDeleteMode
          ? null
          : SpeedDial(
              icon: Icons.lunch_dining, // iconita burger cand e inchis
              activeIcon: Icons.close,
              backgroundColor: widget.category.color,
              foregroundColor: Colors.white,
              overlayColor: Colors.black,
              overlayOpacity: 0.4,
              spacing: 10,
              spaceBetweenChildren: 8,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  label: 'Add Item',
                  onTap: _addNewTask,
                ),
                SpeedDialChild(
                  child: const Icon(Icons.refresh),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  label: 'Reset List',
                  onTap: _resetList,
                ),
              ],
            ),
    );
  }
}
