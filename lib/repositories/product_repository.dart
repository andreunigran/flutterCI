import '../models/product.dart';
import '../data/product_dao.dart';

class ProductRepository {
  final ProductDao dao;
  ProductRepository(this.dao);

  Future<int> add(Product p) => dao.insert(p);
  Future<List<Product>> list() => dao.getAll();
  Future<int> remove(int id) => dao.delete(id);
  Future<int> edit(Product p) => dao.update(p);
  Future<Product?> findById(int id) => dao.getById(id);
}
