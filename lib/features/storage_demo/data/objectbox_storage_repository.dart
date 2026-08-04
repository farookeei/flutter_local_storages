import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../objectbox.g.dart';
import '../domain/entities/todo_item.dart';
import '../domain/repositories/storage_repository.dart';

class ObjectBoxStorageRepository implements StorageRepository {
  late Store _store;
  late Box<TodoItem> _box;
  final String? _customDirectory;

  ObjectBoxStorageRepository({String? directory})
    : _customDirectory = directory;

  @override
  String get engineName => 'ObjectBox C++ Native Engine';

  @override
  Future<void> init() async {
    String path;
    if (_customDirectory != null) {
      path = _customDirectory;
    } else {
      final dir = await getApplicationDocumentsDirectory();
      path = p.join(dir.path, 'objectbox');
    }

    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    _store = await openStore(directory: path);
    _box = _store.box<TodoItem>();
  }

  @override
  Future<int> insertBulk(List<TodoItem> items) async {
    // Reset IDs to 0 so ObjectBox auto-increments unique IDs for every insert
    for (final item in items) {
      item.id = 0;
    }
    _box.putMany(items);
    return items.length;
  }

  @override
  Future<List<TodoItem>> fetchAll() async {
    return _box.getAll();
  }

  @override
  Future<void> clearAll() async {
    _box.removeAll();
  }

  @override
  Future<int> getStorageSizeInBytes() async {
    final dirPath =
        _customDirectory ??
        p.join((await getApplicationDocumentsDirectory()).path, 'objectbox');
    final dir = Directory(dirPath);
    if (!await dir.exists()) return 0;
    int totalSize = 0;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
    return totalSize;
  }

  void close() {
    _store.close();
  }
}
