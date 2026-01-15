import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/packing_model.dart';
import '../widgets/category_card.dart';
import 'checklist_screen.dart';
import '../main.dart';

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

  // Quick quotes mapped to icon choice
  final Map<IconData, String> iconQuotes = {
    Icons.home: "Home is where your story begins.",
    Icons.flight: "Adventure awaits above the clouds.",
    Icons.train: "Stay on track and enjoy the journey.",
    Icons.directions_car: "Roads were made for journeys, not destinations.",
    Icons.hiking: "Take only memories, leave only footprints.",
    Icons.beach_access: "Salt in the air, sand in your hair.",
    Icons.school: "Learning is your passport to the future.",
    Icons.fitness_center: "One rep closer to your goal.",
    Icons.work: "Pack smart, deliver sharp.",
    Icons.music_note: "Pack the vibes, not just the gear.",
    Icons.camera_alt: "Collect moments, not things.",
    Icons.shopping_bag: "List it, pack it, enjoy it.",
    Icons.pets: "Don't forget the furry friend.",
  };

  late final Map<int, String> iconQuotesByCodePoint = {
    for (final entry in iconQuotes.entries) entry.key.codePoint: entry.value,
  };

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

  PackingCategory _buildCategory({
    required String title,
    required IconData icon,
    required Color color,
    String? quote,
    List<PackingItem>? items,
  }) {
    return PackingCategory(
      title: title,
      iconCode: icon.codePoint,
      colorValue: color.value,
      quote: quote ?? (iconQuotesByCodePoint[icon.codePoint] ?? ""),
      items: items ?? <PackingItem>[],
    );
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
        // Backfill quotes for older saved data
        for (final cat in categories) {
          if (cat.quote.isEmpty) {
            final resolved = iconQuotesByCodePoint[cat.iconCode];
            if (resolved != null && resolved.isNotEmpty) cat.quote = resolved;
          }
        }
      } else {
        // Date implicite (doar la prima rulare)
        categories = [
          _buildCategory(
            title: "Home",
            icon: Icons.home,
            color: Colors.teal,
            items: [
              PackingItem(name: "Keys"),
              PackingItem(name: "Wallet"),
              PackingItem(name: "Phone"),
              PackingItem(name: "Charger"),
            ],
          ),
          _buildCategory(
            title: "University",
            icon: Icons.school,
            color: const Color.fromARGB(255, 161, 114, 39),
            items: [
              PackingItem(name: "Laptop"),
              PackingItem(name: "Charger"),
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
    String selectedQuote = iconQuotes[selectedIcon] ?? "";

    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder ne permite sa schimbam starea (culoarea selectata) IN INTERIORUL dialogului
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Shortcuts(
              shortcuts: const {
                SingleActivator(LogicalKeyboardKey.tab): ActivateIntent(),
                SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
              },
              child: Actions(
                actions: {
                  ActivateIntent: CallbackAction<ActivateIntent>(
                    onInvoke: (intent) {
                      if (titleController.text.isNotEmpty) {
                        setState(() {
                          categories.add(
                            PackingCategory(
                              title: titleController.text,
                              iconCode: selectedIcon.codePoint,
                              colorValue: selectedColor.value,
                              quote: selectedQuote,
                              items: [],
                            ),
                          );
                          _saveData();
                        });
                        Navigator.pop(context);
                      }
                      return null;
                    },
                  ),
                },
                child: Focus(
                  autofocus: true,
                  child: AlertDialog(
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
                                        ? Border.all(
                                            color: Colors.black,
                                            width: 3,
                                          )
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
                                  setStateDialog(() {
                                    selectedIcon = icon;
                                    selectedQuote = iconQuotes[icon] ?? "";
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: selectedIcon == icon
                                        ? selectedColor.withOpacity(0.2)
                                        : const Color.fromARGB(255, 157, 157, 157),
                                    borderRadius: BorderRadius.circular(8),
                                    border: selectedIcon == icon
                                        ? Border.all(
                                            color: selectedColor,
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Icon(
                                    icon,
                                    color: selectedIcon == icon
                                        ? selectedColor
                                        : const Color.fromARGB(255, 0, 0, 0),
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
                                  quote: selectedQuote,
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
                  ),
                ),
              ),
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

        // Nu mai punem culori hardcodate aici, le luăm din Theme definit in main.dart
        // backgroundColor: ... (șterge linia asta sau las-o null)
        actions: [
          // Butonul de schimbare a temei
          IconButton(
            icon: Icon(
              themeNotifier.value == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () async {
              // 1. Schimbăm valoarea în notifier
              bool isNowDark = themeNotifier.value != ThemeMode.dark;
              themeNotifier.value = isNowDark
                  ? ThemeMode.dark
                  : ThemeMode.light;

              // 2. Salvăm preferința permanent
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isDarkMode', isNowDark);

              // Forțăm o actualizare a UI-ului local pentru iconiță
              setState(() {});
            },
          ),
        ],
      ),
      body: categories.isEmpty
          ? const Center(child: Text("No lists yet. Tap + to create one!"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Stack(
                    children: [
                      // Static background sitting behind the card
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                      ),
                      Dismissible(
                        // Swipe to delete
                        key: ValueKey(category.title),
                        direction: DismissDirection.endToStart,
                        background: const SizedBox.shrink(),
                        secondaryBackground: const SizedBox.shrink(),
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
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCategory,
        backgroundColor: const Color.fromARGB(255, 106, 106, 106),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
