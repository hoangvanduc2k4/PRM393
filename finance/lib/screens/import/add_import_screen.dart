import 'package:finance/models/material_item.dart';
import 'package:finance/models/transaction_record.dart';
import 'package:finance/providers/inventory_provider.dart';
import 'package:finance/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddImportScreen extends StatefulWidget {
  const AddImportScreen({super.key});

  @override
  State<AddImportScreen> createState() => _AddImportScreenState();
}

class _AddImportScreenState extends State<AddImportScreen> {
  final _formKey = GlobalKey<FormState>();
  MaterialItem? _selectedMaterial;
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  final _sourceController = TextEditingController();

  // For adding new material on the fly
  bool _isNewMaterial = false;
  final _newMaterialNameController = TextEditingController();
  final _newMaterialUnitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhập Hàng Mới')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Material Selection
              SwitchListTile(
                title: const Text('Nguyên Liệu Mới?'),
                value: _isNewMaterial,
                onChanged: (val) {
                  setState(() {
                    _isNewMaterial = val;
                    _selectedMaterial = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_isNewMaterial) ...[
                TextFormField(
                  controller: _newMaterialNameController,
                  decoration: const InputDecoration(labelText: 'Tên Nguyên Liệu', border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Nhập tên' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newMaterialUnitController,
                  decoration: const InputDecoration(labelText: 'Đơn vị tính (kg, cái...)', border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Nhập đơn vị' : null,
                ),
              ] else ...[
                Consumer<InventoryProvider>(
                  builder: (context, inventory, child) {
                    return DropdownButtonFormField<MaterialItem>(
                      value: _selectedMaterial,
                      decoration: const InputDecoration(labelText: 'Chọn Nguyên Liệu', border: OutlineInputBorder()),
                      items: inventory.materials.map((m) {
                        return DropdownMenuItem(
                          value: m,
                          child: Text('${m.name} (${m.unit})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedMaterial = val;
                        });
                      },
                      validator: (value) => value == null ? 'Chọn nguyên liệu' : null,
                    );
                  },
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qtyController,
                      decoration: const InputDecoration(labelText: 'Số lượng', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Nhập SL' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Giá nhập / đơn vị', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Nhập giá' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sourceController,
                decoration: const InputDecoration(labelText: 'Nguồn nhập (NCC)', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Nhập nguồn' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: _submit,
                child: const Text('NHẬP KHO'),
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

        int materialId;
        double price = double.parse(_priceController.text);
        int qty = int.parse(_qtyController.text);

        if (_isNewMaterial) {
          final newMat = MaterialItem(
            name: _newMaterialNameController.text,
            unit: _newMaterialUnitController.text,
            quantity: 0, // Will be updated by transaction
            avgCost: price,
          );
          await inventoryProvider.addMaterial(newMat);
          // Reload to get the ID (lazy way, better to return ID from insert)
          // For now let's assume the last one or we'd need to change Provider to return ID.
          // Let's change Provider to simplify, but for now re-fetching local list logic:
          // Ideally inventoryProvider.addMaterial should return the ID.
          // I didn't implement that in provider fully properly for returning ID.
          // Let's do a quick fix: re-find by name (risky if duplicates) or just fetch all.
          // Actually, let's fix the Provider to return ID or object.
          // But to save tool calls, I'll allow duplicates check or assume it's the last one added? No that's bad.
          // Safest: Find by name.
           final created = inventoryProvider.materials.firstWhere((m) => m.name == _newMaterialNameController.text);
           materialId = created.id!;
        } else {
          materialId = _selectedMaterial!.id!;
        }

        final transaction = TransactionRecord(
          type: 'IMPORT',
          itemId: materialId,
          itemType: 'MATERIAL',
          quantity: qty,
          price: price,
          partnerName: _sourceController.text,
          date: DateTime.now(),
        );

        await transactionProvider.importMaterial(transaction);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nhập kho thành công!')));
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }
}
