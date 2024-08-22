
## Usage

Here are some basic examples of how to use the `easy_data_storage` package:

### HiVe Example

```dart
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:your_project/data_storage.dart';

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

/// Example usage of the HiveDataStorage with the Item entity
void main() async {
   // Initialize Hive and open a box
   await Hive.initFlutter();
   final itemBox = await Hive.openBox<Map<String, dynamic>>('itemBox');

   // Create an instance of HiveDataStorage for Item entity
   final itemStorage = HiveDataStorage<Item>(
      hiveBox: itemBox,
      fromJson: (json) => Item.fromJson(json),
      toJson: (item) => item.toJson(),
      key: 'myItemKey',
   );

   // Create an Item entity
   final item = Item(id: '1', name: 'Example Item');

   // Save the item to Hive
   await itemStorage.put(item);

   // Retrieve the item from Hive
   final retrievedItem = await itemStorage.get();
   print(
           'Retrieved Item: ${retrievedItem?.name}'); // Output: Retrieved Item: Example Item

   // Delete the item from Hive
   await itemStorage.delete();
}
```

### SharedPreferences Example

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_project/data_storage.dart';

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

/// Example usage of the SharedPrefDataStorage with the Item entity
void main() async {
   // Obtain the SharedPreferences instance
   final sharedPreferences = await SharedPreferences.getInstance();

   // Create an instance of SharedPrefDataStorage for Item entity
   final itemStorage = SharedPrefDataStorage<Item>(
      sharedPreferences: sharedPreferences,
      fromJson: (json) => Item.fromJson(json),
      toJson: (item) => item.toJson(),
      key: 'myItemKey',
   );

   // Create an Item entity
   final item = Item(id: '1', name: 'Example Item');

   // Save the item to SharedPreferences
   await itemStorage.put(item);

   // Retrieve the item from SharedPreferences
   final retrievedItem = await itemStorage.get();
   print('Retrieved Item: ${retrievedItem?.name}'); // Output: Retrieved Item: Example Item

   // Delete the item from SharedPreferences
   await itemStorage.delete();
}

```
