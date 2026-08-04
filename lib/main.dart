import 'package:flutter/material.dart';
import 'features/storage_demo/data/mock_storage_repository.dart';
import 'features/storage_demo/presentation/screens/benchmark_screen.dart';

void main() {
  // We initialize our storage repository here.
  // In a real app, you might use a dependency injection framework like GetIt or Provider.
  final storageRepository = MockStorageRepository();
  
  runApp(MyApp(storageRepository: storageRepository));
}

class MyApp extends StatelessWidget {
  final MockStorageRepository storageRepository;

  const MyApp({super.key, required this.storageRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storage Masterclass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: BenchmarkScreen(repository: storageRepository),
    );
  }
}
