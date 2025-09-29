import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import 'product_form.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final void Function(Product)? onEdit;
  const ProductItem({Key? key, required this.product, this.onEdit})
    : super(key: key);

  void _showEdit(BuildContext context) {
    if (onEdit != null) {
      onEdit!(product);
      return;
    }
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

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir produto'),
        content: Text('Deseja excluir "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await Provider.of<ProductProvider>(
        context,
        listen: false,
      ).remove(product.id!);
      if (!context.mounted) return; // ✅ garante que o widget ainda existe
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text(
        'Preço: ${product.price.toStringAsFixed(2)} • Qtd: ${product.quantity}',
      ),
      onTap: () => _showEdit(context),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEdit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }
}
