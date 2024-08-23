import 'package:easy_data_storage/easy_data_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_model/test_model.dart';
import 'shared_pref_storage_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {
  group('Shared pref single data storage', () {
    final testPrefs = MockSharedPreferences();

    final testStorage = SharedPrefDataStorage<TestModel>(
        sharedPreferences: testPrefs,
        fromJson: TestModel.fromJson,
        toJson: (entity) => entity.toJson(),
        key: 'test');

    const testName = 'name';
    const testId = 1;

    final item = TestModel(
      name: testName,
      id: testId,
      isTest: true,
    );

    test('Success save single entity', () async {
      await testStorage.put(item);

      when(testPrefs.get('test')).thenReturn(item.toJson());

      final receivedItem = await testStorage.get();

      expect(receivedItem != null, true);

      expect(receivedItem!.name, item.name);

      expect(
        receivedItem.id,
        item.id,
      );

      expect(
        receivedItem.isTest,
        true,
      );
    });

    test('Success delete entity', () async {
      await testStorage.delete();

      when(testPrefs.get('test')).thenReturn(null);

      final receivedItem = await testStorage.get();

      expect(receivedItem == null, true);
    });

    tearDown(() => testPrefs.clear());
  });

  group('Shared prefs list data storage', () {
    final testPrefs = MockSharedPreferences();

    const prefsKey = 'test';

    final testStorage = SharedPrefsListDataStorage<TestModel>(
        sharedPreferences: testPrefs,
        fromJson: TestModel.fromJson,
        prefsKey: prefsKey,
        toJson: (entity) => entity.toJson(),
        getKeyFromEntity: (entity) => entity.id.toString());

    final items = List.generate(
        5,
        (index) => TestModel(
              name: 'name$index',
              id: index,
              isTest: true,
            ));

    test('Success save list of entities', () async {
      await testStorage.putAll(items);

      when(testPrefs.get(prefsKey))
          .thenReturn(items.map((e) => e.toJson()).toList());

      final receivedItems = await testStorage.getAll();

      expect(receivedItems.length, items.length);

      final actualFirstItem = receivedItems.first;

      expect(actualFirstItem.name, items.first.name);
    });

    test('Success get an entity by key', () async {
      final testItem = items.last;

      final key = testItem.id.toString();

      when(testPrefs.get(prefsKey))
          .thenReturn(items.map((e) => e.toJson()).toList());

      final receivedItem = await testStorage.getByKey(key);

      expect(receivedItem != null, true);

      expect(receivedItem!.name, testItem.name);
      expect(receivedItem.id, testItem.id);
    });

    test('Success get a non-existent entity by key', () async {
      const key = 'testKey';

      when(testPrefs.get(prefsKey))
          .thenReturn(items.map((e) => e.toJson()).toList());

      final receivedItem = await testStorage.getByKey(key);

      expect(receivedItem == null, true);
    });

    test('Success put one entity ', () async {
      const key = '5';

      final item = TestModel(
        name: 'name',
        id: 5,
        isTest: true,
      );

      await testStorage.put(item);

      when(testPrefs.get(prefsKey)).thenReturn([item.toJson()]);

      final actualItem = await testStorage.getByKey(key);

      expect(actualItem != null, true);

      expect(actualItem?.id, 5);
    });
  });
}
