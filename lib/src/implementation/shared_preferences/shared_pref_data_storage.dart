library data_storage;

import 'dart:convert';

import 'package:easy_data_storage/src/base/data_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [DataStorage] using [SharedPreferences] library.
/// For use this implementation with specific type of entity ,
/// you simple need to extends from this class and pass needed parameter.
/// Uses Map<String, dynamic> type for simplify implementation ,
/// so you can skip creating adapters for your models.
///
/// Example of constructor if you using [freezed] for your models:
///   ItemDataSource()
///       : super(
///           sharedPreferences: sharedPreferencesInstance,
///           fromJson: (json) => Item.fromJson(json),
///           toJson: (item) => item.toJson(),
///           key: <static_key>,
///         );
class SharedPrefDataStorage<Entity> implements DataStorage<Entity> {
  const SharedPrefDataStorage({
    required this.sharedPreferences,
    required this.fromJson,
    required this.toJson,
    required this.key,
  });

  /// SharedPreferences instance
  final SharedPreferences sharedPreferences;

  /// Method for converting json to [Entity]
  final Entity Function(Map<String, dynamic>) fromJson;

  /// Method for converting [Entity] to json
  final Map<String, dynamic> Function(Entity) toJson;

  /// Key for saving data
  final String key;

  @override
  Future<Entity?> get() async {
    final value = sharedPreferences.get(key);

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
    await sharedPreferences.setString(key, json.encode(toJson(entity)));
  }

  @override
  Future<void> delete() async {
    await sharedPreferences.remove(key);
  }
}
