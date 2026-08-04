import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/entities/todo_item.dart';
import '../domain/repositories/storage_repository.dart';

class IsarStorageRepository implements StorageRepository {
  late Isar _isar;
  final String? _customDirectory;

  IsarStorageRepository({String? directory}) : _customDirectory = directory;

  @override
  String get engineName => 'Isar Database (Inspector Enabled)';

  @override
  Future<void> init() async {
    if (Isar.instanceNames.isEmpty) {
      String path;
      if (_customDirectory != null) {
        path = _customDirectory;
      } else {
        final dir = await getApplicationDocumentsDirectory();
        path = dir.path;
      }
      _isar = await Isar.open(
        [TodoItemSchema],
        directory: path,
        inspector: true, // Enables web-based Isar Inspector
      );
    } else {
      _isar = Isar.getInstance()!;
    }
  }

  @override
  Future<int> insertBulk(List<TodoItem> items) async {
    await _isar.writeTxn(() async {
      await _isar.todoItems.putAll(items);
    });
    return items.length;
  }

  @override
  Future<List<TodoItem>> fetchAll() async {
    return await _isar.todoItems.where().findAll();
  }

  @override
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.todoItems.clear();
    });
  }

  @override
  Future<int> getStorageSizeInBytes() async {
    final path = _isar.directory;
    if (path != null) {
      final isarFile = File('$path/default.isar');
      if (isarFile.existsSync()) {
        return isarFile.length();
      }
    }
    return 0;
  }
}
