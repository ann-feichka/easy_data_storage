library data_storage;

/// Base interface for implementing local data storage of [Entity].
abstract class DataStorage<Entity> {
  /// Method for getting saved data.
  Future<Entity?> get();

  /// Method for adding the item to the data store.
  Future<void> put(Entity entity);

  /// Method for deleting data from a data storage.
  Future<void> delete();
}
