
---

# easy_data_storage

`easy_data_storage` is a Flutter package that provides simple implementations for data storage using Hive, SQLite, and SharedPreferences. It is designed for storing single entities and lists of entities with ease and efficiency.

## Features

- **HiVe Integration**: Provides a lightweight, high-performance NoSQL database solution for storing entities.
- **SQLite Support**: Implements traditional SQL database capabilities for more complex data management.
- **SharedPreferences**: Facilitates the storage of simple key-value pairs for lightweight data storage needs.
- **Entity Storage**: Supports storing and retrieving both single entities and lists of entities.

## Getting started

To get started with `easy_data_storage`, follow these steps:

1. **Add Dependency**:
   Add `easy_data_storage` to your `pubspec.yaml` file:
   ```yaml
   dependencies:
     easy_data_storage: ^1.0.0
   ```

2. **Install Packages**:
   Run `flutter pub get` to install the new dependency.

3. **Initialization**:
   Initialize the storage components based on your requirements. You can choose between HiVe, SQLite, or SharedPreferences.

## Usage

Here are some basic examples of how to use the `easy_data_storage` package:

### HiVe Example

```dart
import 'package:easy_data_storage/easy_data_storage.dart';

// Initialize HiVe storage
final hiVeStorage = HiVeStorage();

// Define an entity
class User {
  String name;
  int age;

  User(this.name, this.age);
}

// Save a single entity
await hiVeStorage.saveEntity('user1', User('Alice', 30));

// Retrieve a single entity
User? user = await hiVeStorage.getEntity<User>('user1');
print(user?.name);  // Outputs: Alice

// Save a list of entities
await hiVeStorage.saveEntityList('users', [User('Bob', 25), User('Carol', 28)]);

// Retrieve a list of entities
List<User>? users = await hiVeStorage.getEntityList<User>('users');
users?.forEach((user) => print(user.name));  // Outputs: Bob, Carol
```

### SQLite Example

```dart
import 'package:easy_data_storage/easy_data_storage.dart';

// Initialize SQLite storage
final sqliteStorage = SQLiteStorage();

// Save a single entity
await sqliteStorage.saveEntity('user1', User('Alice', 30));

// Retrieve a single entity
User? user = await sqliteStorage.getEntity<User>('user1');
print(user?.name);  // Outputs: Alice

// Save a list of entities
await sqliteStorage.saveEntityList('users', [User('Bob', 25), User('Carol', 28)]);

// Retrieve a list of entities
List<User>? users = await sqliteStorage.getEntityList<User>('users');
users?.forEach((user) => print(user.name));  // Outputs: Bob, Carol
```

### SharedPreferences Example

```dart
import 'package:easy_data_storage/easy_data_storage.dart';

// Initialize SharedPreferences storage
final sharedPrefsStorage = SharedPreferencesStorage();

// Save a single entity
await sharedPrefsStorage.saveEntity('user1', User('Alice', 30));

// Retrieve a single entity
User? user = await sharedPrefsStorage.getEntity<User>('user1');
print(user?.name);  // Outputs: Alice

// Save a list of entities
await sharedPrefsStorage.saveEntityList('users', [User('Bob', 25), User('Carol', 28)]);

// Retrieve a list of entities
List<User>? users = await sharedPrefsStorage.getEntityList<User>('users');
users?.forEach((user) => print(user.name));  // Outputs: Bob, Carol
```

## Additional information

For more details, documentation, and examples, visit the [GitHub repository](https://github.com/your-repo/easy_data_storage).

- **Contributing**: If you would like to contribute to the development of `easy_data_storage`, please follow the [contributing guidelines](https://github.com/your-repo/easy_data_storage/blob/main/CONTRIBUTING.md).
- **Reporting Issues**: For reporting bugs or issues, please use the [issue tracker](https://github.com/your-repo/easy_data_storage/issues).
- **Support**: For questions or support, open an issue on GitHub or contact the maintainers via email.

---

Feel free to adjust the URLs and specific details to fit your actual project setup.