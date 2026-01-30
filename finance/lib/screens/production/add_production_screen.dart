import 'package:finance/models/product_item.dart';
import 'package:finance/models/production_log.dart';
import 'package:finance/providers/inventory_provider.dart';
import 'package:finance/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductionScreen extends StatefulWidget {
  const AddProductionScreen({super.key});

  @override
  State<AddProductionScreen> createState() => _AddProductionScreenState();
}

class _AddProductionScreenState extends State<AddProductionScreen> {
  final _formKey = GlobalKey<FormState>();
  ProductItem? _selectedProduct;
  final _qtyController = TextEditingController();
  final _noteController = TextEditingController();

  // New Product
  bool _isNewProduct = false;
  final _newProductNameController = TextEditingController();
  final _newProductUnitController = TextEditingController();
  final _newProductDescController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ghi Nhận Sản Xuất')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SwitchListTile(
                title: const Text('Sản Phẩm Mới?'),
                value: _isNewProduct,
                onChanged: (val) {
                  setState(() {
                    _isNewProduct = val;
                    _selectedProduct = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_isNewProduct) ...[
                TextFormField(
                  controller: _newProductNameController,
                  decoration: const InputDecoration(labelText: 'Tên Sản Phẩm', border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Nhập tên' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newProductUnitController,
                  decoration: const InputDecoration(labelText: 'Đơn vị tính', border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Nhập đơn vị' : null,
                ),
                 const SizedBox(height: 16),
                TextFormField(
                  controller: _newProductDescController,
                  decoration: const InputDecoration(labelText: 'Mô tả', border: OutlineInputBorder()),
                ),
              ] else ...[
                Consumer<InventoryProvider>(
                  builder: (context, inventory, child) {
                    return DropdownButtonFormField<ProductItem>(
                      value: _selectedProduct,
                      decoration: const InputDecoration(labelText: 'Chọn Sản Phẩm', border: OutlineInputBorder()),
                      items: inventory.products.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text('${p.name} (${p.unit})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedProduct = val;
                        });
                      },
                      validator: (value) => value == null ? 'Chọn sản phẩm' : null,
                    );
                  },
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(labelText: 'Số lượng sản xuất', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Nhập SL' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Ghi chú (ngày giờ...)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: _submit,
                child: const Text('LƯU KẾT QUẢ SẢN XUẤT'),
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
        final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
        final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

        int productId;
        int qty = int.parse(_qtyController.text);

        if (_isNewProduct) {
          final newProd = ProductItem(
            name: _newProductNameController.text,
            unit: _newProductUnitController.text,
            quantity: 0,
            description: _newProductDescController.text,
          );
          await inventoryProvider.addProduct(newProd);
          
          final created = inventoryProvider.products.firstWhere((p) => p.name == _newProductNameController.text);
          productId = created.id!;
        } else {
          productId = _selectedProduct!.id!;
        }

        final log = ProductionLog(
          productId: productId,
          quantityProduced: qty,
          date: DateTime.now(),
          note: _noteController.text,
        );

        await transactionProvider.produceProduct(log);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ghi nhận sản xuất thành công!')));
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }
}
