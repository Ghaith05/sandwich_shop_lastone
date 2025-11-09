import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/repositories/sandwich_repository.dart';

void main() {
  group('SandwichRepository', () {
    const sampleJson =
        '{"sandwiches":[{"id":"s1","name":"S1","description":"d","available":true},{"id":"s2","name":"S2","description":"d2","available":false}]}';

    test('getAllSandwiches loads and parses JSON', () async {
      final repo = SandwichRepository();
      repo.clearCache();
      final list =
          await repo.getAllSandwiches(loader: (path) async => sampleJson);
      expect(list, isNotEmpty);
      expect(list.length, 2);
      expect(list[0].id, 's1');
      expect(list[1].available, isFalse);
    });

    test('getSandwichById returns item when present', () async {
      final repo = SandwichRepository();
      repo.clearCache();
      final item =
          await repo.getSandwichById('s2', loader: (path) async => sampleJson);
      expect(item, isNotNull);
      expect(item!.id, 's2');
    });

    test('clearCache forces reload', () async {
      int calls = 0;
      Future<String> loader(String path) async {
        calls++;
        return sampleJson;
      }

      final repo = SandwichRepository();
      repo.clearCache();
      await repo.getAllSandwiches(loader: loader);
      await repo.getAllSandwiches(loader: loader);
      expect(calls, 1); // cached second call
      repo.clearCache();
      await repo.getAllSandwiches(loader: loader);
      expect(calls, 2);
    });
  });
}
