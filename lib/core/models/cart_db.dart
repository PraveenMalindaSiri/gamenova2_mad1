import 'package:gamenova2_mad1/core/models/cart.dart';
import 'package:gamenova2_mad1/core/models/product.dart';
import 'package:gamenova2_mad1/core/service/product_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartDB {
  static Database? _db;
  static const _dbName = 'gamenova_cart.db';
  static const _table = 'cart';

  Future<Database> get database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), _dbName);

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE $_table(
            cart_id   INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id   INTEGER    NOT NULL,
            product_id      INTEGER    NOT NULL,
            quantity  INTEGER NOT NULL CHECK(quantity > 0),
            UNIQUE(user_id, product_id)
          )
        ''');
        await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_cart_user ON $_table(user_id)',
        );
      },
    );
    return _db!;
  }

  Future<List<CartItem>> getCart(int userId) async {
    final db = await database;
    final rows = await db.query(
      _table,
      where: 'user_id = ?',
      whereArgs: [userId], // bind parameters
    );

    final List<CartItem> items = [];

    for (var r in rows) {
      final pid = r['product_id'] as String;
      Product product;

      try {
        final p = await ProductService.getProductDetails(pid);
        product = p;
      } catch (_) {
        product = Product(
          id: int.tryParse(pid) ?? 0,
          title: 'Unavailable',
          genre: 'N/A',
          platform: 'N/A',
          type: 'digital',
          price: 0,
          company: 'N/A',
          size: 0.0,
          duration: 'N/A',
          ageRating: 0,
          description: 'N/A',
          imageUrl: 'N/A',
          sellerId: 0,
          createdAt: 'N/A',
          featured: false,
        );
      }
      items.add(
        CartItem(
          id: r['cart_id'] as int,
          userId: r['user_id'] as int,
          productId: pid as int,
          quantity: r['quantity'] as int,
          product: product,
        ),
      );
    }
    return items;
  }

  Future<void> addItem({
    required int userId,
    required int productId,
    int amount = 1,
  }) async {
    final db = await database;
    await db.insert(_table, {
      'user_id': userId,
      'product_id': productId,
      'quantity': amount < 1 ? 1 : amount,
    });
  }

  Future<void> removeItem({required int userId, required int productId}) async {
    final db = await database;
    await db.delete(
      _table,
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  Future<void> clearCart(String userId) async {
    final db = await database;
    await db.delete(_table, where: 'user_id = ?', whereArgs: [userId]);
  }
}
