import 'package:easy_data_storage/easy_data_storage.dart';
import 'package:hive/hive.dart';

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

/// Example usage of the HiveListDataStorage with the Item entity
void main() async {
  // Initialize Hive and open a box
  Hive.init('path');
  final itemsBox = await Hive.openBox<Map<String, dynamic>>('itemsBox');

  // Create an instance of HiveListDataStorage for Item entity
  final itemListStorage = HiveListDataStorage<Item>(
    hiveBox: itemsBox,
    fromJson: (json) => Item.fromJson(json),
    toJson: (item) => item.toJson(),
    getKeyFromEntity: (item) => item.id,
  );

  // Create a list of Item entities
  final items = [
    Item(id: '1', name: 'Item 1'),
    Item(id: '2', name: 'Item 2'),
  ];

  // Save all items to Hive
  await itemListStorage.putAll(items);

  // Retrieve all items from Hive
  final retrievedItems = await itemListStorage.getAll();
  print(
      'Retrieved Items: ${retrievedItems.map((item) => item.name).join(', ')}');
  // Output: Retrieved Items: Item 1, Item 2

  // Get a specific item by key
  final specificItem = await itemListStorage.getByKey('1');
  print(
      'Specific Item: ${specificItem?.name}'); // Output: Specific Item: Item 1

  // Delete a specific item
  await itemListStorage.delete(items[0]);

  // Verify deletion
  final remainingItems = await itemListStorage.getAll();
  print(
      'Remaining Items: ${remainingItems.map((item) => item.name).join(', ')}');
  // Output: Remaining Items: Item 2

  // Clear all items from Hive
  await itemListStorage.deleteAll();
}
