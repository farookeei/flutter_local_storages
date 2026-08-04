import 'package:isar/isar.dart';

part 'todo_item.g.dart';

@collection
class TodoItem {
  Id id;
  String title;
  String content;
  bool isCompleted;
  DateTime createdAt;

  TodoItem({
    required this.id,
    required this.title,
    required this.content,
    required this.isCompleted,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
      };

  factory TodoItem.fromJson(Map<String, dynamic> json) => TodoItem(
        id: json['id'] as int,
        title: json['title'] as String,
        content: json['content'] as String,
        isCompleted: json['isCompleted'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  factory TodoItem.generateMock(int index) {
    return TodoItem(
      id: index,
      title: 'Benchmark Task $index',
      content: 'This is the description for task $index used in benchmarking throughput.',
      isCompleted: index % 2 == 0,
      createdAt: DateTime.now().subtract(Duration(minutes: index)),
    );
  }
}
