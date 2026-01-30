import 'package:finance/screens/outsourcing/add_outsourcing_screen.dart';
import 'package:finance/providers/transaction_provider.dart';
import 'package:finance/widgets/month_picker.dart'; // Reuse
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OutsourcingScreen extends StatelessWidget {
  const OutsourcingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bảng Lương Thợ')), // Updated Title
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddOutsourcingScreen()));
        },
        label: const Text('Ghi Công'), // Updated Label
        icon: const Icon(Icons.group_add),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          final payroll = provider.getMonthlyPayroll();
          final logs = provider.outsourcingLogs;
          // Calculate total for displaying
          final totalMonthLabor = provider.totalLaborCost;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MonthPicker(
                  selectedDate: provider.selectedMonth,
                  onDateChanged: (val) => provider.updateMonth(val),
                ),
              ),
              Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
                 child: Text(
                   'Tổng Chi Phí Tháng: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(totalMonthLabor)}',
                   style: const TextStyle(fontSize: 18, color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                 ),
              ),
              const Divider(height: 30),
              Expanded(
                child: payroll.isEmpty
                    ? const Center(child: Text('Không có dữ liệu lương tháng này.'))
                    : ListView.builder(
                        itemCount: payroll.length,
                        itemBuilder: (context, index) {
                          final worker = payroll.keys.elementAt(index);
                          final totalPay = payroll[worker]!;
                          // Find tasks details (optional, strict payroll usually just needs total)
                          final taskCount = logs.where((l) => l.workerName == worker).length;

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(worker[0]),
                              ),
                              title: Text(worker, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('$taskCount đầu việc đã làm'),
                              trailing: Text(
                                NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(totalPay),
                                style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
