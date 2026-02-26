import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/financial_provider.dart';
import '../../../workers/presentation/providers/worker_provider.dart';
import '../../../../core/utils/currency_formatter.dart';
import 'package:intl/intl.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  String? _selectedWorkerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salary Payment Closing')),
      body: Consumer2<FinancialProvider, WorkerProvider>(
        builder: (context, financeProvider, workerProvider, child) {
          // Ensure workers are loaded
          if (workerProvider.workers.isEmpty) {
             workerProvider.loadWorkers();
             return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Select Worker to Pay'),
                  value: _selectedWorkerId,
                  items: workerProvider.workers.map((w) {
                    return DropdownMenuItem(value: w.id, child: Text(w.name));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedWorkerId = val;
                    });
                    if (val != null) {
                      financeProvider.loadUnpaidWork(val);
                    }
                  },
                ),
              ),

              Expanded(
                child: _selectedWorkerId == null
                    ? const Center(child: Text('Select a worker to view unpaid work'))
                    : financeProvider.unpaidOrders.isEmpty
                        ? const Center(child: Text('No unpaid completed work found.'))
                        : ListView.builder(
                            itemCount: financeProvider.unpaidOrders.length,
                            itemBuilder: (context, index) {
                              final order = financeProvider.unpaidOrders[index];
                              return ListTile(
                                title: Text('Order #${order.id.substring(0, 4)}'),
                                subtitle: Text(DateFormat('yyyy-MM-dd').format(order.assignedDate)),
                                trailing: Text(
                                  CurrencyFormatter.format(order.totalPayment),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                              );
                            },
                          ),
              ),

              if (_selectedWorkerId != null && financeProvider.unpaidOrders.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Payable:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            CurrencyFormatter.format(
                                financeProvider.unpaidOrders.fold(0.0, (sum, item) => sum + item.totalPayment)
                            ),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                          onPressed: () {
                             _confirmPayment(context, financeProvider, _selectedWorkerId!);
                          },
                          child: const Text('CONFIRM PAYMENT & CLOSE'),
                        ),
                      )
                    ],
                  ),
                )
            ],
          );
        },
      ),
    );
  }

  void _confirmPayment(BuildContext context, FinancialProvider provider, String workerId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: const Text('This will create a Salary Transaction and mark these orders as PAID. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final total = provider.unpaidOrders.fold(0.0, (sum, item) => sum + item.totalPayment);
              final ids = provider.unpaidOrders.map((e) => e.id).toList().cast<String>();
              
              await provider.payWorker(workerId, total, ids);
              if (context.mounted) {
                 Navigator.pop(ctx);
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Successful!')));
              }
            },
            child: const Text('Confirm'),
          )
        ],
      ),
    );
  }
}
