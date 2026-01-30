import 'package:finance/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kho Hàng'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Nguyên Liệu'),
              Tab(text: 'Sản Phẩm'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MaterialList(),
            _ProductList(),
          ],
        ),
      ),
    );
  }
}

class _MaterialList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        if (provider.materials.isEmpty) return const Center(child: Text('Chưa có nguyên liệu'));
        return ListView.builder(
          itemCount: provider.materials.length,
          itemBuilder: (context, index) {
            final item = provider.materials[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(item.name),
                subtitle: Text('Đơn vị: ${item.unit}'),
                trailing: Text('${item.quantity}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              ),
            );
          },
        );
      },
    );
  }
}

class _ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        if (provider.products.isEmpty) return const Center(child: Text('Chưa có sản phẩm'));
        return ListView.builder(
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            final item = provider.products[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(item.description),
                trailing: Text('${item.quantity}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              ),
            );
          },
        );
      },
    );
  }
}
