import 'package:objectbox/objectbox.dart';

@Entity()
class TodoItem {
  @Id()
  int id;

  String title;
  String content;
  bool isCompleted;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  TodoItem({
    this.id = 0,
    required this.title,
    required this.content,
    required this.isCompleted,
    required this.createdAt,
  });

  // A factory for quick mock data generation
  factory TodoItem.generateMock(int index) {
    return TodoItem(
      id: 0,
      title: 'Benchmark Task $index',
      content: 'This is the description for task $index used in benchmarking throughput.',
      isCompleted: index % 2 == 0,
      createdAt: DateTime.now().subtract(Duration(minutes: index)),
    );
  }
}
