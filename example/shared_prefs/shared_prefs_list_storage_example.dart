import 'package:easy_data_storage/src/implementation/shared_preferences/shared_pref_list_data_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Define your entity class (for example, using freezed)
class Item {
  final String id;
  final String name;

  Item({required this.id, required this.name});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

/// Example usage of the SharedPrefsListDataStorage with the Item entity
void main() async {
  // Obtain the SharedPreferences instance
  final sharedPreferences = await SharedPreferences.getInstance();

  // Define a key for storing list of items in SharedPreferences
  const prefsKey = 'itemsListKey';

  // Create an instance of SharedPrefsListDataStorage for Item entity
  final itemListStorage = SharedPrefsListDataStorage<Item>(
    sharedPreferences: sharedPreferences,
    fromJson: (json) => Item.fromJson(json),
    toJson: (item) => item.toJson(),
    getKeyFromEntity: (item) => item.id,
    prefsKey: prefsKey,
  );

  // Create a list of Item entities
  final items = [
    Item(id: '1', name: 'Item 1'),
    Item(id: '2', name: 'Item 2'),
  ];

  // Save all items to SharedPreferences
  await itemListStorage.putAll(items);

  // Retrieve all items from SharedPreferences
  final retrievedItems = await itemListStorage.getAll();
  print(
      'Retrieved Items: ${retrievedItems.map((item) => item.name).join(', ')}');
  // Output: Retrieved Items: Item 1, Item 2

  // Get a specific item by key
  final specificItem = await itemListStorage.getByKey('1');
  print(
      'Specific Item: ${specificItem?.name}'); // Output: Specific Item: Item 1

  // Add a new item
  final newItem = Item(id: '3', name: 'Item 3');
  await itemListStorage.put(newItem);

  // Verify addition
  final updatedItems = await itemListStorage.getAll();
  print('Updated Items: ${updatedItems.map((item) => item.name).join(', ')}');
  // Output: Updated Items: Item 1, Item 2, Item 3

  // Delete a specific item
  await itemListStorage.delete(items[0]);

  // Verify deletion
  final remainingItems = await itemListStorage.getAll();
  print(
      'Remaining Items: ${remainingItems.map((item) => item.name).join(', ')}');
  // Output: Remaining Items: Item 2, Item 3

  // Clear all items from SharedPreferences
  await itemListStorage.deleteAll();
}
