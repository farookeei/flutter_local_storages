class TodoItem {
  final int id;
  final String title;
  final String content;
  final bool isCompleted;
  final DateTime createdAt;

  TodoItem({
    required this.id,
    required this.title,
    required this.content,
    required this.isCompleted,
    required this.createdAt,
  });

  // A factory for quick mock data generation
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
