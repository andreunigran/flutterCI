import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:produtos/data/db_provider.dart';
import 'package:produtos/data/product_dao.dart';
import 'package:produtos/models/product.dart';

void main() {
  // inicializa FFI para rodar sqlite em desktop/CI
  sqfliteFfiInit();

  final factory = databaseFactoryFfi;

  late DBProvider dbProvider;
  late ProductDao dao;

  setUp(() async {
    // usa DBProvider.test para criar DB em memória (inMemoryDatabasePath vem do sqflite_common_ffi)
    dbProvider = DBProvider.test(factory: factory, name: inMemoryDatabasePath);
    dao = ProductDao(dbProvider);
    // força criação de tabela
    await dbProvider.database;
  });

  tearDown(() async {
    await dbProvider.close();
  });

  test('insert and getAll', () async {
    final p = Product(
      name: 'Caneta',
      description: 'Azul',
      price: 2.5,
      quantity: 10,
    );
    final id = await dao.insert(p);
    final list = await dao.getAll();
    expect(list.length, 1);
    expect(list.first.id, id);
    expect(list.first.name, 'Caneta');
  });

  test('update and getById', () async {
    final p = Product(
      name: 'Lápis',
      description: null,
      price: 1.0,
      quantity: 5,
    );
    final id = await dao.insert(p);
    final inserted = (await dao.getById(id))!;
    final updated = Product(
      id: inserted.id,
      name: 'Lápis HB',
      description: 'HB 2',
      price: 1.2,
      quantity: 7,
    );
    final count = await dao.update(updated);
    expect(count, 1);
    final fetched = await dao.getById(id);
    expect(fetched!.name, 'Lápis HB');
  });

  test('delete', () async {
    final p = Product(
      name: 'Borracha',
      description: null,
      price: 0.8,
      quantity: 3,
    );
    final id = await dao.insert(p);
    final del = await dao.delete(id);
    expect(del, 1);
    final fetched = await dao.getById(id);
    expect(fetched, isNull);
  });
}
