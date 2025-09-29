import '../models/product.dart';
import 'db_provider.dart';

class ProductDao {
  final DBProvider dbProvider;

  ProductDao(this.dbProvider);

  Future<int> insert(Product p) async {
    final db = await dbProvider.database;
    return await db.insert('products', p.toMap());
  }

  Future<int> update(Product p) async {
    final db = await dbProvider.database;
    return await db.update(
      'products',
      p.toMap(),
      where: 'id = ?',
      whereArgs: [p.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbProvider.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Product>> getAll() async {
    final db = await dbProvider.database;
    final rows = await db.query('products', orderBy: 'name ASC');
    return rows.map((r) => Product.fromMap(r)).toList();
  }

  Future<Product?> getById(int id) async {
    final db = await dbProvider.database;
    final rows = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Product.fromMap(rows.first);
  }
}
