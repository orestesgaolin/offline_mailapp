import 'dart:io';

import 'package:drift/drift.dart';
import 'package:mailapp/model.dart';
import 'package:mailapp/storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:drift/native.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  EmailItems,
  SynchronizationTaskItems,
])
class AppDatabase extends _$AppDatabase implements Storage {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  Future<void> clear() async {}

  @override
  Future<T?> read<T extends Model>(int id) async {
    switch (T) {
      case const (Email):
        final query = select(emailItems)
          ..where((tbl) => tbl.id.equals(id))
          ..limit(1);
        final result = await query.get();
        if (result.isEmpty) return null;
        final row = result.first;
        return Email(
          id: row.id,
          content: row.content,
          subject: row.subject,
          recipient: row.recipient,
          sender: row.sender,
          sentAt: row.sentAt,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt,
          status: row.status,
        ) as T;

      case const (SynchronizationTask):
        final query = select(synchronizationTaskItems)
          ..where((tbl) => tbl.id.equals(id))
          ..limit(1);
        final result = await query.get();
        if (result.isEmpty) return null;
        final row = result.first;
        return SynchronizationTask(
          id: row.id,
          name: row.name,
          entityId: row.entityId,
          table: row.table,
          status: row.status,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt,
        ) as T;
    }
    return null;
  }

  @override
  Future<T> save<T extends Model>(int id, T value) {
    final query = switch (value) {
      Email() => into(emailItems)
            .insertReturningOnConflictUpdate(
          EmailItemsCompanion.insert(
            id: id == 0 ? const Value.absent() : Value(id),
            subject: value.subject,
            content: value.content,
            createdAt: Value(value.createdAt),
            updatedAt: Value(value.updatedAt),
            recipient: value.recipient,
            sender: value.sender,
            sentAt: value.sentAt != null
                ? Value(value.sentAt)
                : const Value.absent(),
            status: value.status,
          ),
        )
            .then((saved) {
          return Email(
            id: saved.id,
            content: saved.content,
            subject: saved.subject,
            recipient: saved.recipient,
            sender: saved.sender,
            sentAt: saved.sentAt,
            createdAt: saved.createdAt,
            updatedAt: saved.updatedAt,
            status: saved.status,
          );
        }),
      SynchronizationTask() => into(synchronizationTaskItems)
            .insertReturningOnConflictUpdate(
          SynchronizationTaskItemsCompanion.insert(
            id: id == 0 ? const Value.absent() : Value(id),
            name: value.name,
            entityId: value.entityId,
            table: value.table,
            status: value.status,
          ),
        )
            .then((saved) {
          return SynchronizationTask(
            id: saved.id,
            name: saved.name,
            entityId: saved.entityId,
            table: saved.table,
            status: saved.status,
            createdAt: saved.createdAt,
            updatedAt: saved.updatedAt,
          );
        })
    };

    return query as Future<T>;
  }

  @override
  Stream<List<T>> watchAll<T extends Model>() {
    switch (T) {
      case const (Email):
        final query = (select(emailItems)
              ..orderBy([
                (t) => OrderingTerm(
                      expression: t.updatedAt,
                      mode: OrderingMode.desc,
                    ),
              ]))
            .watch();

        return query.map((rows) {
          return rows.map((e) {
            return Email(
              id: e.id,
              content: e.content,
              subject: e.subject,
              recipient: e.recipient,
              sender: e.sender,
              sentAt: e.sentAt,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              status: e.status,
            ) as T;
          }).toList();
        });

      case const (SynchronizationTask):
        final query = (select(synchronizationTaskItems)
              ..orderBy([
                (t) => OrderingTerm(
                      expression: t.updatedAt,
                      mode: OrderingMode.desc,
                    ),
              ]))
            .watch();

        return query.map((rows) {
          return rows.map((e) {
            return SynchronizationTask(
              id: e.id,
              name: e.name,
              entityId: e.entityId,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              status: e.status,
              table: e.table,
            ) as T;
          }).toList();
        });
    }

    return const Stream.empty();
  }

  @override
  Future<T> create<T extends Model>(T value) {
    final query = switch (value) {
      Email() => into(emailItems)
            .insertReturning(
          EmailItemsCompanion.insert(
            subject: value.subject,
            content: value.content,
            createdAt: Value(value.createdAt),
            updatedAt: Value(value.updatedAt),
            recipient: value.recipient,
            sender: value.sender,
            sentAt: value.sentAt != null
                ? Value(value.sentAt)
                : const Value.absent(),
            status: value.status,
          ),
        )
            .then(
          (emailItem) {
            return Email(
              id: emailItem.id,
              content: emailItem.content,
              subject: emailItem.subject,
              recipient: emailItem.recipient,
              sender: emailItem.sender,
              sentAt: emailItem.sentAt,
              createdAt: emailItem.createdAt,
              updatedAt: emailItem.updatedAt,
              status: emailItem.status,
            );
          },
        ),
      SynchronizationTask() => into(synchronizationTaskItems)
            .insertReturning(
          SynchronizationTaskItemsCompanion.insert(
            name: value.name,
            entityId: value.entityId,
            table: value.table,
            status: value.status,
          ),
        )
            .then((syncItem) {
          return SynchronizationTask(
            id: syncItem.id,
            name: syncItem.name,
            entityId: syncItem.entityId,
            table: syncItem.table,
            status: syncItem.status,
            createdAt: syncItem.createdAt,
            updatedAt: syncItem.updatedAt,
          );
        })
    };

    return query as Future<T>;
  }

  @override
  Stream<T?> watch<T extends Model>(int id) {
    switch (T) {
      case const (Email):
        final query = (select(emailItems)
              ..where((tbl) => tbl.id.equals(id))
              ..limit(1))
            .watchSingleOrNull();

        return query.map((row) {
          if (row == null) return null;
          return Email(
            id: row.id,
            content: row.content,
            subject: row.subject,
            recipient: row.recipient,
            sender: row.sender,
            sentAt: row.sentAt,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
            status: row.status,
          ) as T;
        });

      case const (SynchronizationTask):
        final query = (select(synchronizationTaskItems)
              ..where((tbl) => tbl.id.equals(id))
              ..limit(1))
            .watchSingleOrNull();

        return query.map((row) {
          if (row == null) return null;
          return SynchronizationTask(
            id: row.id,
            name: row.name,
            entityId: row.entityId,
            table: row.table,
            status: row.status,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
          ) as T;
        });
    }
    return const Stream.empty();
  }

  @override
  Future<T?> find<T extends Model>({required String where}) {
    switch (T) {
      case const (Email):
        final query = customSelect(
          '''
          SELECT * FROM email_items WHERE $where LIMIT 1
        ''',
          readsFrom: {emailItems},
        ).get();

        return query.then((rows) {
          if (rows.isEmpty) return null;
          final row = rows.first;
          return Email(
            id: row.read('id') as int,
            content: row.read('content') as String,
            subject: row.read('subject') as String,
            recipient: row.read('recipient') as String,
            sender: row.read('sender') as String,
            sentAt: row.read('sent_at') as DateTime?,
            createdAt: row.read('created_at') as DateTime,
            updatedAt: row.read('updated_at') as DateTime,
            status: row.read('status') as EmailStatus,
          );
        }) as Future<T?>;

      case const (SynchronizationTask):
        final query = customSelect(
          '''
          SELECT * FROM synchronization_task_items WHERE $where LIMIT 1
        ''',
          readsFrom: {synchronizationTaskItems},
        ).get();

        return query.then((rows) {
          if (rows.isEmpty) return null;
          final row = rows.first;

          return SynchronizationTask(
            id: row.read<int>('id'),
            name: row.read<String>('name'),
            entityId: row.read<int>('entity_id'),
            table: SynchronizationTaskTable.values
                .where((element) => element.name == row.read<String>('table'))
                .first,
            status: SynchronizationTaskStatus.values
                .where((element) => element.name == row.read<String>('status'))
                .first,
            createdAt: row.read<DateTime>('created_at'),
            updatedAt: row.read<DateTime>('updated_at'),
          );
        }) as Future<T?>;
    }

    return Future.value(null);
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(
      file,
      setup: (database) {
        database.execute('PRAGMA journal_mode=WAL;');
      },
    );
  });
}

class SynchronizationTaskItems extends Table {
  @override
  Set<Column<Object>>? get primaryKey => {id};

  IntColumn get id => integer()();
  TextColumn get name => text()();
  IntColumn get entityId => integer()();
  TextColumn get status => textEnum<SynchronizationTaskStatus>()();
  TextColumn get table => textEnum<SynchronizationTaskTable>()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class EmailItems extends Table {
  // primary key
  @override
  Set<Column<Object>>? get primaryKey => {id};

  IntColumn get id => integer()();
  TextColumn get content => text()();
  TextColumn get subject => text()();
  TextColumn get recipient => text()();
  TextColumn get sender => text()();
  DateTimeColumn get sentAt => dateTime().nullable()();
  TextColumn get status => textEnum<EmailStatus>()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

extension CustomStatement<T extends Table, D> on InsertStatement<T, D> {
  Future<D> insertReturningOnConflictUpdate(Insertable<D> entity) {
    return insertReturning(entity, onConflict: DoUpdate((_) => entity));
  }
}
