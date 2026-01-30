import 'package:finance/models/product_item.dart';
import 'package:finance/models/transaction_record.dart';
import 'package:finance/providers/inventory_provider.dart';
import 'package:finance/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExportScreen extends StatefulWidget {
  const AddExportScreen({super.key});

  @override
  State<AddExportScreen> createState() => _AddExportScreenState();
}

class _AddExportScreenState extends State<AddExportScreen> {
  final _formKey = GlobalKey<FormState>();
  ProductItem? _selectedProduct;
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  final _customerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xuất Hàng (Bán)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Consumer<InventoryProvider>(
                builder: (context, inventory, child) {
                  return DropdownButtonFormField<ProductItem>(
                    value: _selectedProduct,
                    decoration: const InputDecoration(labelText: 'Chọn Sản Phẩm Xuất', border: OutlineInputBorder()),
                    items: inventory.products.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text('${p.name} (Tồn: ${p.quantity} ${p.unit})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedProduct = val;
                        // Auto fill price if setting exists (not implemented yet, creating fresh field)
                        if (val != null && val.sellingPrice > 0) {
                          _priceController.text = val.sellingPrice.toString();
                        }
                      });
                    },
                    validator: (value) => value == null ? 'Chọn sản phẩm' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qtyController,
                      decoration: const InputDecoration(labelText: 'Số lượng bán', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                         if (value == null || value.isEmpty) return 'Nhập SL';
                         int? qty = int.tryParse(value);
                         if (qty == null) return 'Phải là số';
                         if (_selectedProduct != null && qty > _selectedProduct!.quantity) {
                           return 'Vượt quá tồn kho';
                         }
                         return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Giá bán / đơn vị', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Nhập giá' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _customerController,
                decoration: const InputDecoration(labelText: 'Khách hàng / Nơi xuất', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Nhập khách hàng' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: _submit,
                child: const Text('XUẤT KHO'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

        int productId = _selectedProduct!.id!;
        double price = double.parse(_priceController.text);
        int qty = int.parse(_qtyController.text);

        final transaction = TransactionRecord(
          type: 'EXPORT',
          itemId: productId,
          itemType: 'PRODUCT',
          quantity: qty,
          price: price,
          partnerName: _customerController.text,
          date: DateTime.now(),
        );

        await transactionProvider.exportProduct(transaction);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xuất kho thành công!')));
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }
}
