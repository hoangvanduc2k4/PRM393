import 'package:finance/screens/import/add_import_screen.dart';
import 'package:finance/providers/transaction_provider.dart';
import 'package:finance/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ImportScreen extends StatelessWidget {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch Sử Nhập Hàng')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddImportScreen()));
        },
        label: const Text('Nhập Mới'),
        icon: const Icon(Icons.add),
      ),
      body: Consumer2<TransactionProvider, InventoryProvider>(
        builder: (context, transactionProvider, inventoryProvider, child) {
          final imports = transactionProvider.transactions.where((t) => t.type == 'IMPORT').toList();

          if (imports.isEmpty) {
            return const Center(child: Text('Chưa có dữ liệu nhập hàng.', style: TextStyle(color: Colors.grey)));
          }

          return ListView.builder(
            itemCount: imports.length,
            itemBuilder: (context, index) {
              final item = imports[index];
              final material = inventoryProvider.getMaterialById(item.itemId);
              final materialName = material?.name ?? 'Unknown Material (#${item.itemId})';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.greenAccent,
                    child: Icon(Icons.arrow_downward, color: Colors.black),
                  ),
                  title: Text(materialName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${DateFormat('dd/MM/yyyy HH:mm').format(item.date)}\nNguồn: ${item.partnerName}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('+${item.quantity} ${material?.unit ?? ''}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      Text('${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(item.price)}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
