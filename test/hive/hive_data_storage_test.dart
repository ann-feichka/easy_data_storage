import 'package:easy_data_storage/easy_data_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../test_model/test_model.dart';
import 'hive_data_storage_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Box>()])
void main() {
  group('Hive single data storage', () {
    final testBox = MockBox<Map<String, dynamic>>();

    final testStorage = HiveDataStorage<TestModel>(
        hiveBox: testBox,
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

      when(testBox.get('test')).thenReturn(item.toJson());

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

      when(testBox.get('test')).thenReturn(null);

      final receivedItem = await testStorage.get();

      expect(receivedItem == null, true);
    });

    tearDown(() => testBox.close());
  });

  group('Hive list data storage', () {
    final testBox = MockBox<Map<String, dynamic>>();

    final testStorage = HiveListDataStorage<TestModel>(
        hiveBox: testBox,
        fromJson: TestModel.fromJson,
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

      when(testBox.values.toList())
          .thenReturn(items.map((e) => e.toJson()).toList());

      final receivedItems = await testStorage.getAll();

      expect(receivedItems.length, items.length);

      final actualFirstItem = receivedItems.first;

      expect(actualFirstItem.name, items.first.name);
    });

    test('Success get an entity by key ', () async {
      final testItem = items.last;

      final key = testItem.id.toString();

      when(testBox.get(key)).thenReturn(testItem.toJson());

      final actualItem = await testStorage.getByKey(key);

      expect(actualItem != null, true);

      expect(actualItem!.name, testItem.name);
    });

    test('Success get a non-existent entity by key ', () async {
      const key = 'testKey';

      when(testBox.get(key)).thenReturn(null);

      final actualItem = await testStorage.getByKey(key);

      expect(actualItem == null, true);
    });
  });
}
