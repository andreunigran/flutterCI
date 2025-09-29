import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static const _defaultDbName = 'products.db';
  static const _dbVersion = 1;

  final DatabaseFactory _factory;
  final String _dbName;
  Database? _database;

  DBProvider._internal(this._factory, this._dbName);

  // singleton padrão usado pela app (usa `databaseFactory` global do sqflite)
  static final DBProvider instance = DBProvider._internal(
    databaseFactory,
    _defaultDbName,
  );

  // fábrica para testes: forneça DatabaseFactory (ex: databaseFactoryFfi) e nome (ex: inMemoryDatabasePath)
  factory DBProvider.test({
    required DatabaseFactory factory,
    required String name,
  }) {
    return DBProvider._internal(factory, name);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    final path = (_dbName == ':memory:')
        ? _dbName
        : join(await getDatabasesPath(), _dbName);
    _database = await _factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: _dbVersion,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE products (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              description TEXT,
              price REAL NOT NULL,
              quantity INTEGER NOT NULL
            )
          ''');
        },
      ),
    );
    return _database!;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
