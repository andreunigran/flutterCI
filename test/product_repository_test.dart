// test/product_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:produtos/data/db_provider.dart';
import 'package:produtos/data/product_dao.dart';
import 'package:produtos/models/product.dart';
import 'package:produtos/repositories/product_repository.dart';

void main() {
  // inicializa FFI para rodar sqlite em ambiente de teste/CI
  sqfliteFfiInit();
  final factory = databaseFactoryFfi;

  late DBProvider dbProvider;
  late ProductDao dao;
  late ProductRepository repository;

  setUp(() async {
    // usa DBProvider.test para criar DB em memória
    dbProvider = DBProvider.test(factory: factory, name: inMemoryDatabasePath);
    dao = ProductDao(dbProvider);
    repository = ProductRepository(dao);
    await dbProvider.database; // garante criação da tabela antes dos testes
  });

  tearDown(() async {
    await dbProvider.close();
  });

  test('add and list', () async {
    final p = Product(
      name: 'Caneta',
      description: 'Azul',
      price: 2.5,
      quantity: 10,
    );
    final id = await repository.add(p);
    final items = await repository.list();
    expect(items.length, 1);
    expect(items.first.id, id);
    expect(items.first.name, 'Caneta');
  });

  test('findById and edit', () async {
    final p = Product(
      name: 'Lápis',
      description: null,
      price: 1.0,
      quantity: 5,
    );
    final id = await repository.add(p);

    final fetched = await repository.findById(id);
    expect(fetched, isNotNull);
    expect(fetched!.name, 'Lápis');

    final updated = Product(
      id: id,
      name: 'Lápis HB',
      description: 'HB 2',
      price: 1.2,
      quantity: 7,
    );
    final updatedCount = await repository.edit(updated);
    expect(updatedCount, 1);

    final after = await repository.findById(id);
    expect(after, isNotNull);
    expect(after!.name, 'Lápis HB');
    expect(after.price, 1.2);
    expect(after.quantity, 7);
  });

  test('remove', () async {
    final p = Product(
      name: 'Borracha',
      description: null,
      price: 0.8,
      quantity: 3,
    );
    final id = await repository.add(p);

    final delCount = await repository.remove(id);
    expect(delCount, 1);

    final fetched = await repository.findById(id);
    expect(fetched, isNull);
  });
}
