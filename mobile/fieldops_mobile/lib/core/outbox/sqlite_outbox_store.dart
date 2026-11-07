import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'outbox.dart';

/// Drift database with one hand-written table (no code generation needed).
class _OutboxDb extends GeneratedDatabase {
  _OutboxDb(super.executor);

  @override
  Iterable<TableInfo<Table, dynamic>> get allTables => const [];

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await customStatement('''
            CREATE TABLE outbox (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              kind TEXT NOT NULL,
              client_uuid TEXT NOT NULL,
              payload TEXT NOT NULL,
              ref TEXT,
              attempts INTEGER NOT NULL DEFAULT 0,
              next_attempt_at INTEGER NOT NULL,
              created_at INTEGER NOT NULL,
              last_error TEXT,
              UNIQUE (kind, client_uuid)
            )''');
          await customStatement(
              'CREATE INDEX outbox_due ON outbox (kind, next_attempt_at, id)');
        },
      );
}

/// The outbox on the phone's SQLite (survives restarts and app kills).
class SqliteOutboxStore implements OutboxStore {
  final _OutboxDb _db;

  SqliteOutboxStore._(this._db);

  static Future<SqliteOutboxStore> open() async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'fieldops_outbox.sqlite'));
    return SqliteOutboxStore._(_OutboxDb(NativeDatabase.createInBackground(file)));
  }

  /// For tests on a desktop host with SQLite available.
  factory SqliteOutboxStore.memory() => SqliteOutboxStore._(_OutboxDb(NativeDatabase.memory()));

  @override
  Future<void> add(OutboxItem item) => _db.customStatement(
        'INSERT OR IGNORE INTO outbox '
        '(kind, client_uuid, payload, ref, attempts, next_attempt_at, created_at) '
        'VALUES (?, ?, ?, ?, ?, ?, ?)',
        [
          item.kind.name,
          item.clientUuid,
          item.payload,
          item.ref,
          item.attempts,
          item.nextAttemptAt.millisecondsSinceEpoch,
          item.createdAt.millisecondsSinceEpoch,
        ],
      );

  @override
  Future<List<OutboxItem>> due(OutboxKind kind, DateTime now, int limit) async {
    final rows = await _db.customSelect(
      'SELECT * FROM outbox WHERE kind = ? AND next_attempt_at <= ? ORDER BY id LIMIT ?',
      variables: [
        Variable.withString(kind.name),
        Variable.withInt(now.millisecondsSinceEpoch),
        Variable.withInt(limit),
      ],
    ).get();
    return rows
        .map((r) => OutboxItem(
              id: r.read<int>('id'),
              kind: kind,
              clientUuid: r.read<String>('client_uuid'),
              payload: r.read<String>('payload'),
              ref: r.readNullable<String>('ref'),
              attempts: r.read<int>('attempts'),
              nextAttemptAt: DateTime.fromMillisecondsSinceEpoch(
                  r.read<int>('next_attempt_at'),
                  isUtc: true),
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                  r.read<int>('created_at'),
                  isUtc: true),
              lastError: r.readNullable<String>('last_error'),
            ))
        .toList();
  }

  String _in(List<int> ids) => List.filled(ids.length, '?').join(',');

  @override
  Future<void> remove(List<int> ids) async {
    if (ids.isEmpty) return;
    await _db.customStatement('DELETE FROM outbox WHERE id IN (${_in(ids)})', ids);
  }

  @override
  Future<void> reschedule(List<int> ids, DateTime nextAttemptAt, String error) async {
    if (ids.isEmpty) return;
    final reason = error.length > 500 ? error.substring(0, 500) : error;
    await _db.customStatement(
      'UPDATE outbox SET attempts = attempts + 1, next_attempt_at = ?, last_error = ? '
      'WHERE id IN (${_in(ids)})',
      [nextAttemptAt.millisecondsSinceEpoch, reason, ...ids],
    );
  }

  @override
  Future<int> count([OutboxKind? kind]) async {
    final row = await (kind == null
            ? _db.customSelect('SELECT COUNT(*) AS c FROM outbox')
            : _db.customSelect('SELECT COUNT(*) AS c FROM outbox WHERE kind = ?',
                variables: [Variable.withString(kind.name)]))
        .getSingle();
    return row.read<int>('c');
  }

  @override
  Future<void> trim(OutboxKind kind, int max) => _db.customStatement(
        'DELETE FROM outbox WHERE kind = ? AND id NOT IN '
        '(SELECT id FROM outbox WHERE kind = ? ORDER BY id DESC LIMIT ?)',
        [kind.name, kind.name, max],
      );

  Future<void> close() => _db.close();
}
