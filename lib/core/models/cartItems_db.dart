import 'dart:convert';

import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartItemsDb {
  static Database? _db;
  static const _dbName = 'gamenova_cartItems.db';
  static const _table = 'products';

  Future<Database> get _database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $_table(
            id INTEGER PRIMARY KEY,
            json TEXT NOT NULL,
            updated_at INTEGER NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  Future<Product?> getAnItem(int id) async {
    final db = await _database;
    final rows = await db.query(
      _table,
      where: 'id=?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Product.fromJson(jsonDecode(rows.first['json'] as String));
  }

  Future<void> saveAnItem(Product p) async {
    final db = await _database;
    await db.insert(_table, {
      'id': p.id,
      'json': jsonEncode(p.toJson()),
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
