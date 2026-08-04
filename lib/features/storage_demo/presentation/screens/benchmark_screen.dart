import 'package:flutter/material.dart';
import '../../domain/entities/todo_item.dart';
import '../../domain/repositories/storage_repository.dart';

class BenchmarkScreen extends StatefulWidget {
  final StorageRepository repository;

  const BenchmarkScreen({super.key, required this.repository});

  @override
  State<BenchmarkScreen> createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  bool _isWorking = false;
  String _statusMessage = 'Ready';
  int _totalItems = 0;
  int _storageSizeInBytes = 0;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    setState(() => _isWorking = true);
    await widget.repository.init();
    await _refreshMetrics();
    setState(() {
      _isWorking = false;
      _statusMessage = 'Database Initialized';
    });
  }

  Future<void> _refreshMetrics() async {
    final items = await widget.repository.fetchAll();
    final bytes = await widget.repository.getStorageSizeInBytes();
    setState(() {
      _totalItems = items.length;
      _storageSizeInBytes = bytes;
    });
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  Future<void> _runWriteBenchmark() async {
    setState(() {
      _isWorking = true;
      _statusMessage = 'Generating 10,000 items...';
    });

    // Generate 10,000 items
    final items = List.generate(10000, (index) => TodoItem.generateMock(index));

    setState(() => _statusMessage = 'Writing to database...');

    final stopwatch = Stopwatch()..start();
    await widget.repository.insertBulk(items);
    stopwatch.stop();

    await _refreshMetrics();

    setState(() {
      _isWorking = false;
      _statusMessage = 'Inserted 10,000 items in ${stopwatch.elapsedMilliseconds} ms';
    });
  }

  Future<void> _runReadBenchmark() async {
    setState(() {
      _isWorking = true;
      _statusMessage = 'Reading all items...';
    });

    final stopwatch = Stopwatch()..start();
    final items = await widget.repository.fetchAll();
    stopwatch.stop();

    await _refreshMetrics();

    setState(() {
      _isWorking = false;
      _statusMessage = 'Read ${items.length} items in ${stopwatch.elapsedMilliseconds} ms';
    });
  }

  Future<void> _clearDatabase() async {
    setState(() => _isWorking = true);
    await widget.repository.clearAll();
    await _refreshMetrics();
    setState(() {
      _isWorking = false;
      _statusMessage = 'Database Cleared';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Benchmark'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoCard(context),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Active Engine',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              widget.repository.engineName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Items in DB:'),
                Text(
                  '$_totalItems',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Database Size:'),
                Text(
                  _formatBytes(_storageSizeInBytes),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueAccent),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isWorking ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  if (_isWorking)
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      _statusMessage,
                      style: TextStyle(
                        color: _isWorking ? Colors.orange[800] : Colors.green[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _isWorking ? null : _runWriteBenchmark,
          icon: const Icon(Icons.download),
          label: const Text('Insert 10,000 Items (Write)'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _isWorking ? null : _runReadBenchmark,
          icon: const Icon(Icons.upload),
          label: const Text('Fetch All Items (Read)'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _isWorking ? null : _clearDatabase,
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          label: const Text('Clear Database', style: TextStyle(color: Colors.red)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
