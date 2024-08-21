library data_storage;

import 'dart:convert';

import 'package:hive/hive.dart';

import '../../base/data_storage.dart';

/// Implementation of [DataStorage] using [Hive] library.
/// For use this implementation with specific type of entity ,
/// you simple need to extends from this class and pass needed parameter.
/// Uses Map<String, dynamic> type for simplify implementation ,
/// so you can skip creating adapters for your models.
///
/// Example of constructor if you using [freezed] for your models:
///   ItemDataSource()
///       : super(
///           hiveBox: HiveService.itemBox!,
///           fromJson: (json) => Item.fromJson(json),
///           toJson: (item) => item.toJson(),
///           key: <static_key>,
///         );
class HiveDataStorage<Entity> implements DataStorage<Entity> {
  const HiveDataStorage({
    required this.hiveBox,
    required this.fromJson,
    required this.toJson,
    required this.key,
  });

  /// Specific Hive [Box] where you saved data
  final Box<Map<String, dynamic>> hiveBox;

  /// Method for converting json to [Entity]
  final Entity Function(Map<String, dynamic>) fromJson;

  /// Method for converting [Entity] to json
  final Map<String, dynamic> Function(Entity) toJson;

  /// Key for saving data
  final String key;

  @override
  Future<Entity?> get() async {
    final value = hiveBox.get(key);

    if (value != null) {
      final entity = fromJson(
        json.decode(
          json.encode(value),
        ) as Map<String, dynamic>,
      );
      return entity;
    }

    return null;
  }

  @override
  Future<void> put(Entity entity) async {
    await hiveBox.put(key, toJson(entity));
  }

  @override
  Future<void> delete() async {
    await hiveBox.clear();
  }
}
