import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  const ProductForm({Key? key, this.product}) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  String? _description;
  late String _price;
  late String _quantity;

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _description = widget.product?.description;
    _price = widget.product?.price.toString() ?? '';
    _quantity = widget.product?.quantity.toString() ?? '';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final price = double.tryParse(_price.replaceAll(',', '.')) ?? 0.0;
    final qty = int.tryParse(_quantity) ?? 0;

    final product = Product(
      id: widget.product?.id,
      name: _name.trim(),
      description: _description?.trim(),
      price: price,
      quantity: qty,
    );

    final provider = Provider.of<ProductProvider>(context, listen: false);
    if (widget.product == null) {
      await provider.add(product);
    } else {
      await provider.update(product);
    }
    if (!mounted) return; // ✅ garante que o widget ainda existe

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing ? 'Editar Produto' : 'Novo Produto',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _name,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Nome obrigatório'
                          : null,
                      onSaved: (v) => _name = v ?? '',
                    ),
                    TextFormField(
                      initialValue: _description,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      onSaved: (v) => _description = v,
                    ),
                    TextFormField(
                      initialValue: _price,
                      decoration: const InputDecoration(labelText: 'Preço'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) {
                        final vv = v?.replaceAll(',', '.') ?? '';
                        final val = double.tryParse(vv);
                        if (val == null || val < 0) return 'Preço inválido';
                        return null;
                      },
                      onSaved: (v) => _price = v ?? '0',
                    ),
                    TextFormField(
                      initialValue: _quantity,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final val = int.tryParse(v ?? '');
                        if (val == null || val < 0)
                          return 'Quantidade inválida';
                        return null;
                      },
                      onSaved: (v) => _quantity = v ?? '0',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _save,
                          child: Text(isEditing ? 'Atualizar' : 'Salvar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
