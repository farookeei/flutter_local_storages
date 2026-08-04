import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../security/secure_key_manager.dart';

part 'app_database.g.dart';

@DataClassName('TodoItemEntry')
class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  BoolColumn get isCompleted => boolean()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [TodoItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openEncryptedDatabase());

  @override
  int get schemaVersion => 1;

  static QueryExecutor openEncryptedDatabase({String? customPath, String? passphraseOverride}) {
    return LazyDatabase(() async {
      File file;
      if (customPath != null) {
        file = File(customPath);
      } else {
        final dbFolder = await getApplicationDocumentsDirectory();
        file = File(p.join(dbFolder.path, 'app_encrypted.sqlite'));
      }

      final passphrase = passphraseOverride ?? await SecureKeyManager.getOrCreatePassphrase();

      return NativeDatabase.createInBackground(
        file,
        setup: (rawDb) {
          // Execute SQLCipher encryption pragma prior to any query
          rawDb.execute("PRAGMA key = '$passphrase';");
        },
      );
    });
  }
}
