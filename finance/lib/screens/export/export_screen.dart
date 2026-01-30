import 'package:finance/screens/export/add_export_screen.dart';
import 'package:finance/providers/transaction_provider.dart';
import 'package:finance/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch Sử Xuất Hàng')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExportScreen()));
        },
        label: const Text('Xuất Mới'),
        icon: const Icon(Icons.upload),
      ),
      body: Consumer2<TransactionProvider, InventoryProvider>(
         builder: (context, transactionProvider, inventoryProvider, child) {
          final exports = transactionProvider.transactions.where((t) => t.type == 'EXPORT').toList();

          if (exports.isEmpty) {
            return const Center(child: Text('Chưa có dữ liệu xuất hàng.', style: TextStyle(color: Colors.grey)));
          }

          return ListView.builder(
            itemCount: exports.length,
            itemBuilder: (context, index) {
              final item = exports[index];
              final product = inventoryProvider.getProductById(item.itemId);
              final productName = product?.name ?? 'Unknown Product (#${item.itemId})';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    child: Icon(Icons.arrow_upward, color: Colors.black),
                  ),
                  title: Text(productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${DateFormat('dd/MM/yyyy HH:mm').format(item.date)}\nKhách: ${item.partnerName}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('-${item.quantity} ${product?.unit ?? ''}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
