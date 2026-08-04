import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/todo_item.dart';
import '../domain/repositories/storage_repository.dart';

class SharedPreferencesStorageRepository implements StorageRepository {
  static const String _storageKey = 'benchmark_todo_items';
  late SharedPreferences _prefs;

  @override
  String get engineName => 'SharedPreferences';

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<int> insertBulk(List<TodoItem> items) async {
    // 1. Fetch existing items
    final existingJsonList = _prefs.getStringList(_storageKey) ?? [];
    
    // 2. Convert new items to JSON strings
    final newJsonList = items.map((item) => jsonEncode(item.toJson())).toList();
    
    // 3. Append and save back to SharedPreferences
    final combinedList = [...existingJsonList, ...newJsonList];
    await _prefs.setStringList(_storageKey, combinedList);
    
    return items.length;
  }

  @override
  Future<List<TodoItem>> fetchAll() async {
    final jsonList = _prefs.getStringList(_storageKey) ?? [];
    return jsonList
        .map((jsonStr) => TodoItem.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> clearAll() async {
    await _prefs.remove(_storageKey);
  }
}
