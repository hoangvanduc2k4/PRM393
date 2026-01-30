import 'package:finance/screens/production/add_production_screen.dart';
import 'package:finance/providers/transaction_provider.dart';
import 'package:finance/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductionScreen extends StatelessWidget {
  const ProductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch Sử Sản Xuất')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductionScreen()));
        },
        label: const Text('Ghi Nhận SX'),
        icon: const Icon(Icons.handyman),
      ),
      body: Consumer2<TransactionProvider, InventoryProvider>(
        builder: (context, transactionProvider, inventoryProvider, child) {
          final logs = transactionProvider.productionLogs;

          if (logs.isEmpty) {
            return const Center(child: Text('Chưa có dữ liệu sản xuất.', style: TextStyle(color: Colors.grey)));
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final item = logs[index];
              final product = inventoryProvider.getProductById(item.productId);
              final productName = product?.name ?? 'Unknown Product (#${item.productId})';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.blueAccent.withOpacity(0.3))),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.settings, color: Colors.white),
                  ),
                  title: Text(productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${DateFormat('dd/MM/yyyy HH:mm').format(item.date)}\nNote: ${item.note}'),
                  trailing: Text('+${item.quantityProduced} ${product?.unit ?? ''}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
