import 'dart:io';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../domain/entities/todo_item.dart';
import '../domain/repositories/storage_repository.dart';

/// Lightweight, manual Hive TypeAdapter for TodoItem (TypeId: 1)
class TodoItemAdapter extends TypeAdapter<TodoItem> {
  @override
  final int typeId = 1;

  @override
  TodoItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoItem(
      id: fields[0] as int,
      title: fields[1] as String,
      content: fields[2] as String,
      isCompleted: fields[3] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[4] as int),
    );
  }

  @override
  void write(BinaryWriter writer, TodoItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.createdAt.millisecondsSinceEpoch);
  }
}

class HiveStorageRepository implements StorageRepository {
  static const String _boxName = 'todo_items_box';
  late Box<TodoItem> _box;

  @override
  String get engineName => 'Hive CE (Community Edition)';

  @override
  Future<void> init() async {
    try {
      await Hive.initFlutter();
    } catch (_) {
      // In unit tests, Hive.init(path) is called directly before init()
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TodoItemAdapter());
    }
    _box = await Hive.openBox<TodoItem>(_boxName);
  }

  @override
  Future<int> insertBulk(List<TodoItem> items) async {
    final currentLength = _box.length;
    final Map<dynamic, TodoItem> entries = {};

    for (var i = 0; i < items.length; i++) {
      final uniqueId = currentLength + i;
      final item = items[i];
      entries[uniqueId] = TodoItem(
        id: uniqueId,
        title: 'Benchmark Task $uniqueId',
        content: item.content,
        isCompleted: item.isCompleted,
        createdAt: item.createdAt,
      );
    }

    await _box.putAll(entries);
    return items.length;
  }

  @override
  Future<List<TodoItem>> fetchAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
  }

  @override
  Future<int> getStorageSizeInBytes() async {
    final path = _box.path;
    if (path != null && File(path).existsSync()) {
      return File(path).length();
    }
    return 0;
  }
}
