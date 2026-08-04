import 'package:flutter_local_storages/features/storage_demo/domain/entities/todo_item.dart';
import 'package:flutter_local_storages/features/storage_demo/domain/repositories/storage_repository.dart';
import 'package:flutter_local_storages/features/storage_demo/data/mock_storage_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// ---------------------------------------------------------------------------
/// Contract Test Suite for [StorageRepository]
///
/// HOW TO USE ON EVERY FUTURE BRANCH:
/// 1. Create your new repository (e.g., IsarStorageRepository).
/// 2. Change the `createRepository()` factory function below to return
///    your new implementation.
/// 3. Run `flutter test`. All tests must pass green.
///
/// This ensures every database implementation honours the same contract.
/// ---------------------------------------------------------------------------

/// Factory function — swap this out on each feature branch.
StorageRepository createRepository() => MockStorageRepository();

void main() {
  group('TodoItem Entity', () {
    test('generateMock creates item with correct index', () {
      final item = TodoItem.generateMock(42);
      expect(item.id, equals(42));
      expect(item.title, equals('Benchmark Task 42'));
      expect(item.isCompleted, isTrue); // 42 % 2 == 0, so isCompleted = true
    });

    test('generateMock alternates isCompleted correctly', () {
      final even = TodoItem.generateMock(4);
      final odd = TodoItem.generateMock(5);
      expect(even.isCompleted, isTrue);  // 4 % 2 == 0
      expect(odd.isCompleted, isFalse); // 5 % 2 != 0
    });

    test('generateMock has non-empty content', () {
      final item = TodoItem.generateMock(1);
      expect(item.content, isNotEmpty);
      expect(item.title, isNotEmpty);
    });
  });

  group('StorageRepository Contract Tests', () {
    late StorageRepository repository;

    setUp(() async {
      // A fresh repository instance before every test.
      repository = createRepository();
      await repository.init();
    });

    // ── 1. Engine Name ───────────────────────────────────────────────────────

    test('engineName is non-empty', () {
      expect(repository.engineName, isNotEmpty);
    });

    // ── 2. Initial State ─────────────────────────────────────────────────────

    test('fetchAll returns empty list on fresh database', () async {
      final items = await repository.fetchAll();
      expect(items, isEmpty);
    });

    // ── 3. Insert ────────────────────────────────────────────────────────────

    test('insertBulk inserts correct number of items', () async {
      final batch = List.generate(100, TodoItem.generateMock);
      final insertedCount = await repository.insertBulk(batch);
      expect(insertedCount, equals(100));
    });

    test('insertBulk persists items — fetchAll returns them', () async {
      final batch = List.generate(100, TodoItem.generateMock);
      await repository.insertBulk(batch);

      final fetched = await repository.fetchAll();
      expect(fetched.length, equals(100));
    });

    test('inserting 0 items does not throw', () async {
      expect(() async => await repository.insertBulk([]), returnsNormally);
    });

    test('multiple insertBulk calls accumulate correctly', () async {
      await repository.insertBulk(List.generate(50, TodoItem.generateMock));
      await repository.insertBulk(List.generate(50, (i) => TodoItem.generateMock(i + 50)));

      final fetched = await repository.fetchAll();
      expect(fetched.length, equals(100));
    });

    // ── 4. Read ──────────────────────────────────────────────────────────────

    test('fetchAll returns all inserted items', () async {
      const count = 500;
      await repository.insertBulk(List.generate(count, TodoItem.generateMock));

      final fetched = await repository.fetchAll();
      expect(fetched.length, equals(count));
    });

    // ── 5. Clear ─────────────────────────────────────────────────────────────

    test('clearAll empties the database', () async {
      await repository.insertBulk(List.generate(100, TodoItem.generateMock));
      await repository.clearAll();

      final fetched = await repository.fetchAll();
      expect(fetched, isEmpty);
    });

    test('clearAll on empty database does not throw', () async {
      expect(() async => await repository.clearAll(), returnsNormally);
    });

    test('insertBulk works correctly after clearAll', () async {
      await repository.insertBulk(List.generate(100, TodoItem.generateMock));
      await repository.clearAll();
      await repository.insertBulk(List.generate(25, TodoItem.generateMock));

      final fetched = await repository.fetchAll();
      expect(fetched.length, equals(25));
    });

    // ── 6. 10k Benchmark Smoke Test ──────────────────────────────────────────

    test('insertBulk handles 10,000 items without throwing', () async {
      final batch = List.generate(10000, TodoItem.generateMock);
      final stopwatch = Stopwatch()..start();
      final count = await repository.insertBulk(batch);
      stopwatch.stop();

      expect(count, equals(10000));
      // Sanity: the entire 10k operation should complete in under 10 seconds.
      expect(stopwatch.elapsedMilliseconds, lessThan(10000));
    });

    test('fetchAll handles 10,000 items without throwing', () async {
      await repository.insertBulk(List.generate(10000, TodoItem.generateMock));

      final stopwatch = Stopwatch()..start();
      final fetched = await repository.fetchAll();
      stopwatch.stop();

      expect(fetched.length, equals(10000));
      expect(stopwatch.elapsedMilliseconds, lessThan(10000));
    });
  });
}
