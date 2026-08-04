import 'package:flutter/material.dart';
import 'features/storage_demo/data/shared_preferences_storage_repository.dart';
import 'features/storage_demo/domain/repositories/storage_repository.dart';
import 'features/storage_demo/presentation/screens/benchmark_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final storageRepository = SharedPreferencesStorageRepository();
  
  runApp(MyApp(storageRepository: storageRepository));
}

class MyApp extends StatelessWidget {
  final StorageRepository storageRepository;

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
