library easy_data_storage;

import 'dart:convert';

import 'package:darq/darq.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
class SharedPrefsListDataStorage<Entity> implements ListDataStorage<Entity> {
  const SharedPrefsListDataStorage({
    required this.sharedPreferences,
    required this.fromJson,
    required this.toJson,
    required this.getKeyFromEntity,
    required this.prefsKey,
  });

  /// SharedPreferences instance
  final SharedPreferences sharedPreferences;

  /// Method for converting json to [Entity]
  final Entity Function(Map<String, dynamic>) fromJson;

  /// Method for converting [Entity] to json
  final Map<String, dynamic> Function(Entity) toJson;

  /// Method for getting an identifier for entity.
  final GetKeyFromEntity<Entity> getKeyFromEntity;

  final String prefsKey;

  @override
  Future<List<Entity>> getAll() async {
    final values = sharedPreferences.get(prefsKey) as List;

    final entities = (values)
        .map(
          (itemsJson) => fromJson(
            json.decode(
              json.encode(itemsJson),
            ) as Map<String, dynamic>,
          ),
        )
        .toList();

    return entities;
  }

  @override
  Future<Entity?> getByKey(String key) async {
    final values = sharedPreferences.get(prefsKey) as List;

    final entities = (values)
        .map(
          (itemsJson) => fromJson(
            json.decode(
              json.encode(itemsJson),
            ) as Map<String, dynamic>,
          ),
        )
        .toList();

    final entity = entities.firstWhereOrDefault((item) => getKey(item) == key);

    return entity;
  }

  @override
  Future<void> put(Entity entity) async {
    var values = sharedPreferences.get(prefsKey) as List;

    values = [...values, json.encode(toJson(entity))];

    await sharedPreferences.setString(prefsKey, values.toString());
  }

  @override
  Future<void> putAll(
    List<Entity> entities,
  ) async {
    final values = entities.map((entity) => json.encode(toJson(entity)));

    await sharedPreferences.setString(prefsKey, values.toString());
  }

  @override
  Future<void> delete(Entity entity) async {
    final values = sharedPreferences.get(prefsKey) as List;

    var entities = (values)
        .map(
          (itemsJson) => fromJson(
            json.decode(
              json.encode(itemsJson),
            ) as Map<String, dynamic>,
          ),
        )
        .toList();

    entities
        .removeWhere((savedEntity) => getKey(entity) == getKey(savedEntity));

    final updatedValues = entities.map((entity) => json.encode(toJson(entity)));

    await sharedPreferences.setString(prefsKey, updatedValues.toString());
  }

  @override
  Future<void> deleteAll() async {
    await sharedPreferences.remove(prefsKey);
  }

  @override
  String getKey(Entity entity) => getKeyFromEntity(entity);
}
