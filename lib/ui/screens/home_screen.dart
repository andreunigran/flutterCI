import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../widgets/product_item.dart';
import '../widgets/product_form.dart';
import '../../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // carrega produtos ao iniciar (listen: false para não recriar o widget)
    Future.microtask(() async {
      await Provider.of<ProductProvider>(context, listen: false).loadAll();
      if (!mounted) return; // ✅ evita usar context se widget foi desmontado
      setState(() {}); // opcional se quiser atualizar UI
    });
  }

  void _openForm([Product? product]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ProductForm(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Produtos')),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = provider.items;
          if (items.isEmpty) {
            return Center(
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Cadastrar primeiro produto'),
                onPressed: () => _openForm(),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, idx) => ProductItem(
              product: items[idx],
              onEdit: (_) => _openForm(items[idx]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
