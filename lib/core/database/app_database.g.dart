// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TodoItemsTable extends TodoItems
    with TableInfo<$TodoItemsTable, TodoItemEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    content,
    isCompleted,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodoItemEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isCompletedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoItemEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoItemEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TodoItemsTable createAlias(String alias) {
    return $TodoItemsTable(attachedDatabase, alias);
  }
}

class TodoItemEntry extends DataClass implements Insertable<TodoItemEntry> {
  final int id;
  final String title;
  final String content;
  final bool isCompleted;
  final DateTime createdAt;
  const TodoItemEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.isCompleted,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TodoItemsCompanion toCompanion(bool nullToAbsent) {
    return TodoItemsCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
    );
  }

  factory TodoItemEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoItemEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TodoItemEntry copyWith({
    int? id,
    String? title,
    String? content,
    bool? isCompleted,
    DateTime? createdAt,
  }) => TodoItemEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
  );
  TodoItemEntry copyWithCompanion(TodoItemsCompanion data) {
    return TodoItemEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoItemEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content, isCompleted, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoItemEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt);
}

class TodoItemsCompanion extends UpdateCompanion<TodoItemEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  const TodoItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TodoItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
    required bool isCompleted,
    required DateTime createdAt,
  }) : title = Value(title),
       content = Value(content),
       isCompleted = Value(isCompleted),
       createdAt = Value(createdAt);
  static Insertable<TodoItemEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TodoItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? content,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
  }) {
    return TodoItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TodoItemsTable todoItems = $TodoItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [todoItems];
}

typedef $$TodoItemsTableCreateCompanionBuilder =
    TodoItemsCompanion Function({
      Value<int> id,
      required String title,
      required String content,
      required bool isCompleted,
      required DateTime createdAt,
    });
typedef $$TodoItemsTableUpdateCompanionBuilder =
    TodoItemsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> content,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
    });

class $$TodoItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodoItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodoItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoItemsTable> {
  $$TodoItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TodoItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodoItemsTable,
          TodoItemEntry,
          $$TodoItemsTableFilterComposer,
          $$TodoItemsTableOrderingComposer,
          $$TodoItemsTableAnnotationComposer,
          $$TodoItemsTableCreateCompanionBuilder,
          $$TodoItemsTableUpdateCompanionBuilder,
          (
            TodoItemEntry,
            BaseReferences<_$AppDatabase, $TodoItemsTable, TodoItemEntry>,
          ),
          TodoItemEntry,
          PrefetchHooks Function()
        > {
  $$TodoItemsTableTableManager(_$AppDatabase db, $TodoItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TodoItemsCompanion(
                id: id,
                title: title,
                content: content,
                isCompleted: isCompleted,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String content,
                required bool isCompleted,
                required DateTime createdAt,
              }) => TodoItemsCompanion.insert(
                id: id,
                title: title,
                content: content,
                isCompleted: isCompleted,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodoItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodoItemsTable,
      TodoItemEntry,
      $$TodoItemsTableFilterComposer,
      $$TodoItemsTableOrderingComposer,
      $$TodoItemsTableAnnotationComposer,
      $$TodoItemsTableCreateCompanionBuilder,
      $$TodoItemsTableUpdateCompanionBuilder,
      (
        TodoItemEntry,
        BaseReferences<_$AppDatabase, $TodoItemsTable, TodoItemEntry>,
      ),
      TodoItemEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TodoItemsTableTableManager get todoItems =>
      $$TodoItemsTableTableManager(_db, _db.todoItems);
}
