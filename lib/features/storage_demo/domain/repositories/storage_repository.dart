import '../entities/todo_item.dart';

abstract class StorageRepository {
  /// Name of the current active storage engine (e.g., 'SharedPreferences', 'Isar')
  String get engineName;

  /// Initialize the database or storage engine
  Future<void> init();

  /// Insert a large batch of items (for write benchmarking)
  Future<int> insertBulk(List<TodoItem> items);

  /// Fetch all items (for read benchmarking)
  Future<List<TodoItem>> fetchAll();

  /// Clear all data in the storage
  Future<void> clearAll();
}
