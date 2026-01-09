import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/packing_model.dart';
import '../widgets/category_card.dart';
import 'checklist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PackingCategory> categories = [];
  bool isLoading = true;

  // Lista de culori disponibile pentru alegere
  final List<Color> availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  // Lista de iconite disponibile pentru alegere
  final List<IconData> availableIcons = [
    Icons.home,
    Icons.flight,
    Icons.train,
    Icons.directions_car,
    Icons.hiking,
    Icons.beach_access,
    Icons.school,
    Icons.fitness_center,
    Icons.work,
    Icons.music_note,
    Icons.camera_alt,
    Icons.shopping_bag,
    Icons.pets,
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      categories.map((c) => c.toJson()).toList(),
    );
    await prefs.setString('packing_list_data', encodedData);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? startData = prefs.getString('packing_list_data');

    setState(() {
      if (startData != null) {
        final List<dynamic> decodedList = jsonDecode(startData);
        categories = decodedList
            .map((item) => PackingCategory.fromJson(item))
            .toList();
      } else {
        // Date implicite (doar la prima rulare)
        categories = [
          PackingCategory(
            title: "University",
            iconCode: Icons.school.codePoint,
            colorValue: const Color.fromARGB(255, 161, 114, 39).value,
            items: [
              PackingItem(name: "Laptop"),
              PackingItem(name: "ID Card"),
            ],
          ),
        ];
        _saveData();
      }
      isLoading = false;
    });
  }

  void _onCategoryUpdated() {
    setState(() {});
    _saveData();
  }

  // --- FUNCTIA MODIFICATA PENTRU SELECTIE CULOARE SI ICONITA ---
  void _addNewCategory() {
    TextEditingController titleController = TextEditingController();

    // Valori implicite pentru noua lista
    Color selectedColor = availableColors[0];
    IconData selectedIcon = availableIcons[0];

    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder ne permite sa schimbam starea (culoarea selectata) IN INTERIORUL dialogului
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("New Category"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Numele Listei
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "List Name",
                        hintText: "e.g. Gym, Holiday",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 2. Selectare Culoare
                    const Text(
                      "Pick a Color:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: availableColors.map((color) {
                        return GestureDetector(
                          onTap: () {
                            setStateDialog(() => selectedColor = color);
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: selectedColor == color
                                  ? Border.all(color: Colors.black, width: 3)
                                  : null,
                            ),
                            child: selectedColor == color
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // 3. Selectare Iconita
                    const Text(
                      "Pick an Icon:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: availableIcons.map((icon) {
                        return GestureDetector(
                          onTap: () {
                            setStateDialog(() => selectedIcon = icon);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: selectedIcon == icon
                                  ? selectedColor.withOpacity(0.2)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              border: selectedIcon == icon
                                  ? Border.all(color: selectedColor, width: 2)
                                  : null,
                            ),
                            child: Icon(
                              icon,
                              color: selectedIcon == icon
                                  ? selectedColor
                                  : Colors.grey,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      setState(() {
                        categories.add(
                          PackingCategory(
                            title: titleController.text,
                            iconCode: selectedIcon.codePoint,
                            colorValue: selectedColor.value,
                            items: [],
                          ),
                        );
                        _saveData();
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Create"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Packing Lists'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 106, 106, 106),
        foregroundColor: Colors.white,
      ),
      body: categories.isEmpty
          ? const Center(child: Text("No lists yet. Tap + to create one!"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Dismissible(
                  // BONUS: Swipe to delete entire list
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Delete List?"),
                        content: Text(
                          "Are you sure you want to delete '${category.title}'?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    setState(() {
                      categories.removeAt(index);
                      _saveData();
                    });
                  },
                  child: CategoryCard(
                    category: category,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChecklistScreen(
                            category: category,
                            onUpdate: _onCategoryUpdated,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCategory,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
