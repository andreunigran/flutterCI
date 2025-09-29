import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db_provider.dart';
import 'data/product_dao.dart';
import 'repositories/product_repository.dart';
import 'providers/product_provider.dart';
import 'ui/screens/home_screen.dart';

void main() {
  final dbProvider = DBProvider.instance;
  final dao = ProductDao(dbProvider);
  final repo = ProductRepository(dao);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProductProvider(repo))],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Produtos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
