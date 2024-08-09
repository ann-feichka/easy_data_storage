library data_storage;

typedef GetKeyFromEntity<Entity> = String Function(Entity entity);

/// Base interface for implementing local data storage for list of [Entity].
abstract class ListDataStorage<Entity> {
  /// Method for getting an identifier for structuring elements.
  /// Used in the [put] and [delete] methods to access the desired element.
  String getKey(Entity entity);

  /// Method for getting all elements.
  Future<List<Entity>?> getAll();

  /// Method for getting elements by specific identifier.
  Future<Entity?> getByKey(String key);

  /// Method for adding a single item to the data store.
  /// Should use [getKey] to make the item findable.
  Future<void> put(Entity entity);

  /// Method for adding a list of items to the data store.
  /// Should use [getKey] to make items findable.
  Future<void> putAll(List<Entity> entities);

  /// Method for deleting a specific item from the data store.
  /// Should use [getKey] to get access to the desired item
  Future<void> delete(Entity entity);

  /// Method for deleting all data from a data storage.
  Future<void> deleteAll();
}
