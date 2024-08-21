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
  });
}
