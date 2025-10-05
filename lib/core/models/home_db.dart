import 'dart:convert';

import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HomeSectionsDB {
  static Database? _db;
  static const _dbName = 'gamenova_home.db';
  static const _table = 'home_sections';

  Future<Database> get database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), _dbName);

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE $_table (
            id INTEGER NOT NULL,
            section TEXT NOT NULL,
            json TEXT NOT NULL,
            updated_at INTEGER NOT NULL,
            PRIMARY KEY (id, section)
          )
        ''');
        await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_${_table}_section ON $_table(section)',
        );
      },
    );
    return _db!;
  }

  Future<void> saveSection(String section, List<Product> products) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(_table, where: 'section = ?', whereArgs: [section]);
      final batch = txn.batch();
      final now = DateTime.now().millisecondsSinceEpoch;
      for (final p in products) {
        batch.insert(_table, {
          'id': p.id,
          'section': section,
          'json': jsonEncode(p.toJson()),
          'updated_at': now,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<List<Product>> readSection(String section) async {
    final db = await database;
    final rows = await db.query(
      _table,
      where: 'section = ?',
      whereArgs: [section],
      orderBy: 'id DESC',
    );
    return rows
        .map((r) => Product.fromJson(jsonDecode(r['json'] as String)))
        .toList();
  }

  Future<bool> hasAnyCache() async {
    final db = await database;
    final res = await db.rawQuery('SELECT COUNT(*) as c FROM $_table');
    final c = (res.first['c'] as int?) ?? 0;
    return c > 0;
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete(_table);
  }
}
