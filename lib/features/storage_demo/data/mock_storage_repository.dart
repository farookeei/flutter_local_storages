import '../domain/entities/todo_item.dart';
import '../domain/repositories/storage_repository.dart';

class MockStorageRepository implements StorageRepository {
  final List<TodoItem> _inMemoryDb = [];

  @override
  String get engineName => 'Mock Engine (In-Memory)';

  @override
  Future<void> init() async {
    // Simulate initialization delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<int> insertBulk(List<TodoItem> items) async {
    // Simulate a slight I/O write delay for the benchmark
    await Future.delayed(const Duration(milliseconds: 200));
    _inMemoryDb.addAll(items);
    return items.length;
  }

  @override
  Future<List<TodoItem>> fetchAll() async {
    // Simulate a slight I/O read delay for the benchmark
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_inMemoryDb);
  }

  @override
  Future<void> clearAll() async {
    _inMemoryDb.clear();
  }

  @override
  Future<int> getStorageSizeInBytes() async {
    // Roughly estimate RAM size by stringifying the list
    return _inMemoryDb.fold<int>(0, (int sum, item) => sum + item.title.length + item.content.length + 32);
  }
}
