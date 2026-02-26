import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/worker_provider.dart';
import '../../data/models/outsourcing_order_model.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/currency_formatter.dart';

class WorkerDetailScreen extends StatefulWidget {
  final String workerId;
  final String workerName;

  const WorkerDetailScreen({super.key, required this.workerId, required this.workerName});

  @override
  State<WorkerDetailScreen> createState() => _WorkerDetailScreenState();
}

class _WorkerDetailScreenState extends State<WorkerDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }
  
  void _loadOrders() {
      Future.microtask(() =>
        Provider.of<WorkerProvider>(context, listen: false).getWorkerOrders(widget.workerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Work for ${widget.workerName}')),
      body: Consumer<WorkerProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<List<OutsourcingOrderModel>>( // Using FutureBuilder slightly redundant if Provider manages state but okay for simple refresh
            future: provider.getWorkerOrders(widget.workerId), // This triggers rebuild loop if not careful!
            // Correction: remove FutureBuilder, use provider.getWorkerOrders return value? No, Provider pattern relies on notifyListeners.
            // Let's assume provider.getWorkerOrders caches and we just read from a map in provider? 
            // provider.getWorkerOrders updates the state, so we just need access to state.
            // But Provider here doesn't expose the list directly map-keyed. 
            // I will implement a simpler approach: Local State Future? 
            // Or better: Fix Provider to expose `orders` for current worker?
            // Let's convert to FutureBuilder for now to avoid complexity in this file, calling repository directly via provider wrapper.
            // Actually, the Provider method returns List. Let's use that.
            
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                 return const Center(child: Text('No orders found. Assign work!'));
              }
              final orders = snapshot.data!;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final isPending = order.status == 'Pending';
                  
                  return Card(
                    color: isPending ? Colors.orange[50] : Colors.green[50],
                    child: ListTile(
                      title: Text('Order #${order.id.substring(0, 4)} - ${order.status}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text('Date: ${DateFormat('dd/MM/yyyy').format(order.assignedDate)}'),
                            if (!isPending) Text('Total Payment: ${CurrencyFormatter.format(order.totalPayment)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                      trailing: isPending 
                          ? ElevatedButton(
                              onPressed: () => _showReceiveDialog(order.id),
                              child: const Text('Nhận Hàng'),
                            )
                          : const Icon(Icons.check_circle, color: Colors.green),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAssignDialog,
        label: const Text('Giao Việc (Assign)'),
        icon: const Icon(Icons.assignment_add),
      ),
    );
  }

  void _showAssignDialog() {
    final partController = TextEditingController();
    final qtyController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Giao Việc Mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: partController, decoration: const InputDecoration(labelText: 'Tên Bộ Phận (VD: Chân)')),
            TextField(controller: qtyController, decoration: const InputDecoration(labelText: 'Số lượng giao'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (partController.text.isEmpty || qtyController.text.isEmpty) {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập đủ thông tin!'), backgroundColor: Colors.red));
                 return;
              }
              
              final qty = int.tryParse(qtyController.text);
              if (qty == null || qty <= 0) {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Số lượng không hợp lệ!'), backgroundColor: Colors.red));
                 return;
              }

              await Provider.of<WorkerProvider>(context, listen: false).assignWork(widget.workerId, partController.text, qty);
              if (mounted) {
                 setState(() {}); // Refresh list
                 Navigator.pop(ctx);
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Giao việc thành công!'), backgroundColor: Colors.green));
              }
            },
            child: const Text('Giao'),
          )
        ],
      ),
    );
  }

  void _showReceiveDialog(String orderId) {
      final pairsController = TextEditingController();
      final priceController = TextEditingController();
      
      showDialog(
        context: context, 
        builder: (ctx) => AlertDialog(
          title: const Text('Nhận Hàng & Tính Tiền'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               TextField(controller: pairsController, decoration: const InputDecoration(labelText: 'Số lượng hoàn thành'), keyboardType: TextInputType.number),
               TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Đơn giá / Sản phẩm'), keyboardType: TextInputType.number),
            ],
          ),
           actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  if (pairsController.text.isEmpty || priceController.text.isEmpty) {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập đủ thông tin!'), backgroundColor: Colors.red));
                     return;
                  }

                  final pairs = int.tryParse(pairsController.text);
                  final price = double.tryParse(priceController.text);
                  
                  if (pairs != null && price != null && pairs > 0 && price >= 0) {
                     await Provider.of<WorkerProvider>(context, listen: false).completeWork(orderId, pairs, price, widget.workerId);
                     if (mounted) {
                        setState(() {});
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã cập nhật trạng thái!'), backgroundColor: Colors.green));
                     }
                  } else {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dữ liệu không hợp lệ!'), backgroundColor: Colors.red));
                  }
                },
                child: const Text('Hoàn Thành'),
              )
           ],
        )
      );
  }
}
