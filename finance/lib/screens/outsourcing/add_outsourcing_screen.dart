import 'package:finance/models/outsourcing_log.dart';
import 'package:finance/providers/inventory_provider.dart';
import 'package:finance/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/material_item.dart';

class AddOutsourcingScreen extends StatefulWidget {
  const AddOutsourcingScreen({super.key});

  @override
  State<AddOutsourcingScreen> createState() => _AddOutsourcingScreenState();
}

class _AddOutsourcingScreenState extends State<AddOutsourcingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _workerNameController = TextEditingController();
  final _taskNameController = TextEditingController();
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  final _materialAmountController = TextEditingController();

  MaterialItem? _selectedMaterial;

  @override
  Widget build(BuildContext context) {
    final inventory = Provider.of<InventoryProvider>(context);
    final materials = inventory.materials;

    return Scaffold(
      appBar: AppBar(title: const Text('Ghi Nhận Gia Công')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _workerNameController,
                decoration: const InputDecoration(labelText: 'Tên Thợ / Xưởng', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Nhập tên thợ' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _taskNameController,
                decoration: const InputDecoration(labelText: 'Công việc (Vd: Đan chân)', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Nhập công việc' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qtyController,
                      decoration: const InputDecoration(labelText: 'Số lượng (TP)', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Nhập SL' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Giá công / cái', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Nhập giá' : null,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              const Text('TRỪ NGUYÊN LIỆU (TÙY CHỌN)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              
              DropdownButtonFormField<MaterialItem>(
                value: _selectedMaterial,
                decoration: const InputDecoration(labelText: 'Chọn Nguyên Liệu', border: OutlineInputBorder()),
                items: materials.map((m) {
                  return DropdownMenuItem(
                    value: m,
                    child: Text('${m.name} (Kho: ${m.quantity} ${m.unit})'),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedMaterial = val;
                  });
                },
              ),
              const SizedBox(height: 12),
              if (_selectedMaterial != null)
                TextFormField(
                  controller: _materialAmountController,
                  decoration: InputDecoration(
                    labelText: 'Số lượng dùng (${_selectedMaterial!.unit})', 
                    border: const OutlineInputBorder(),
                    helperText: 'Vd: 0.2 tấn hoặc 5kg'
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (_selectedMaterial != null && (value == null || value.isEmpty)) {
                      return 'Nhập số lượng tiêu hao';
                    }
                    return null;
                  },
                ),

              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.purpleAccent, foregroundColor: Colors.white),
                onPressed: _submit,
                child: const Text('LƯU GIA CÔNG & TRỪ KHO'),
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
         
         double price = double.parse(_priceController.text);
         int qty = int.parse(_qtyController.text);
         double total = price * qty;
         
         double? matAmount;
         if (_selectedMaterial != null && _materialAmountController.text.isNotEmpty) {
           matAmount = double.tryParse(_materialAmountController.text);
         }

         final log = OutsourcingLog(
           workerName: _workerNameController.text,
           taskName: _taskNameController.text,
           quantity: qty,
           pricePerUnit: price,
           totalCost: total,
           date: DateTime.now(),
           materialId: _selectedMaterial?.id,
           materialUsedAmount: matAmount,
         );

         await transactionProvider.addOutsourcingLog(log);

         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu!')));
           Navigator.pop(context);
         }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }
}
