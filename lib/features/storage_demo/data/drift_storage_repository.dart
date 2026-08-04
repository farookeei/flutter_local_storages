import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../core/database/app_database.dart';
import '../domain/entities/todo_item.dart';
import '../domain/repositories/storage_repository.dart';

class DriftStorageRepository implements StorageRepository {
  late AppDatabase _db;
  final String? _customPath;
  final String? _passphraseOverride;

  DriftStorageRepository({String? path, String? passphraseOverride})
      : _customPath = path,
        _passphraseOverride = passphraseOverride;

  @override
  String get engineName => 'Drift (SQLCipher Encrypted SQL)';

  @override
  Future<void> init() async {
    final executor = AppDatabase.openEncryptedDatabase(
      customPath: _customPath,
      passphraseOverride: _passphraseOverride,
    );
    _db = AppDatabase(executor);
  }

  @override
  Future<int> insertBulk(List<TodoItem> items) async {
    final companionEntries = items.map((item) {
      return TodoItemsCompanion.insert(
        title: item.title,
        content: item.content,
        isCompleted: item.isCompleted,
        createdAt: item.createdAt,
      );
    }).toList();

    await _db.batch((batch) {
      batch.insertAll(_db.todoItems, companionEntries);
    });

    return items.length;
  }

  @override
  Future<List<TodoItem>> fetchAll() async {
    final rows = await _db.select(_db.todoItems).get();
    return rows.map((row) {
      return TodoItem(
        id: row.id,
        title: row.title,
        content: row.content,
        isCompleted: row.isCompleted,
        createdAt: row.createdAt,
      );
    }).toList();
  }

  @override
  Future<void> clearAll() async {
    await _db.delete(_db.todoItems).go();
  }

  @override
  Future<int> getStorageSizeInBytes() async {
    String path;
    if (_customPath != null) {
      path = _customPath!;
    } else {
      final dbFolder = await getApplicationDocumentsDirectory();
      path = p.join(dbFolder.path, 'app_encrypted.sqlite');
    }
    final file = File(path);
    if (await file.exists()) {
      return await file.length();
    }
    return 0;
  }

  Future<void> close() async {
    await _db.close();
  }
}
