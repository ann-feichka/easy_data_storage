library data_storage;

import 'dart:convert';

import 'package:hive/hive.dart';

import '../../base/list_data_storage.dart';

/// Implementation of [ListDataStorage] using [Hive] library.
/// For use this implementation with specific type of entity ,
/// you simple need to extends from this class and pass needed parameter.
/// Uses Map<String, dynamic> type for simplify implementation ,
/// so you can skip creating adapters for your models.
///
/// Example of constructor if you using [freezed] for your models:
///   ItemListDataSource()
///       : super(
///           hiveBox: HiveService.itemsBox!,
///           fromJson: (json) => Item.fromJson(json),
///           toJson: (item) => item.toJson(),
///           getKeyFromEntity: (item) => item.id,
///         );
class HiveListDataStorage<Entity> implements ListDataStorage<Entity> {
  const HiveListDataStorage({
    required this.hiveBox,
    required this.fromJson,
    required this.toJson,
    required this.getKeyFromEntity,
  });

  /// Specific Hive [Box] where you saved data
  final Box<Map<String, dynamic>> hiveBox;

  /// Method for converting json to [Entity]
  final Entity Function(Map<String, dynamic>) fromJson;

  /// Method for converting [Entity] to json
  final Map<String, dynamic> Function(Entity) toJson;

  /// Method for getting an identifier for entity.
  final GetKeyFromEntity<Entity> getKeyFromEntity;

  @override
  Future<List<Entity>> getAll() async {
    final values = hiveBox.values.toList();

    final validMapList = values
        .map(
          (itemsJson) => fromJson(
            json.decode(
              json.encode(itemsJson),
            ) as Map<String, dynamic>,
          ),
        )
        .toList();

    return validMapList;
  }

  @override
  Future<Entity?> getByKey(String key) async {
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
    await hiveBox.put(getKey(entity), toJson(entity));
  }

  @override
  Future<void> putAll(
    List<Entity> entities,
  ) async {
    await hiveBox.putAll(
      {for (final e in entities) getKey(e): toJson(e)},
    );
  }

  @override
  Future<void> delete(Entity entity) async {
    await hiveBox.delete(getKey(entity));
  }

  @override
  Future<void> deleteAll() async {
    await hiveBox.clear();
  }

  @override
  String getKey(Entity entity) => getKeyFromEntity(entity);
}
