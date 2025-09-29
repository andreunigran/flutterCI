import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;
  List<Product> _items = [];
  bool _loading = false;

  ProductProvider(this.repository);

  List<Product> get items => _items;
  bool get loading => _loading;

  Future<void> loadAll() async {
    _loading = true;
    notifyListeners();
    _items = await repository.list();
    _loading = false;
    notifyListeners();
  }

  Future<void> add(Product p) async {
    await repository.add(p);
    await loadAll();
  }

  Future<void> update(Product p) async {
    await repository.edit(p);
    await loadAll();
  }

  Future<void> remove(int id) async {
    await repository.remove(id);
    await loadAll();
  }
}
