import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/reporting_repository.dart';
import '../../../workers/presentation/providers/worker_provider.dart';
import 'package:intl/intl.dart';

class ReportingScreen extends StatelessWidget {
  const ReportingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reporting & Backup'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.picture_as_pdf), text: 'Salary Slips'),
              Tab(icon: Icon(Icons.table_chart), text: 'Finance & Backup'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SalaryReportTab(),
            FinancialBackupTab(),
          ],
        ),
      ),
    );
  }
}

class SalaryReportTab extends StatefulWidget {
  const SalaryReportTab({super.key});

  @override
  State<SalaryReportTab> createState() => _SalaryReportTabState();
}

class _SalaryReportTabState extends State<SalaryReportTab> {
  String? _selectedWorkerId;
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final workerProvider = Provider.of<WorkerProvider>(context);
    final reportRepo = ReportingRepository();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButton<String>(
            isExpanded: true,
            hint: const Text('Select Worker'),
            value: _selectedWorkerId,
            items: workerProvider.workers.map((w) {
              return DropdownMenuItem(value: w.id, child: Text(w.name));
            }).toList(),
            onChanged: (val) => setState(() => _selectedWorkerId = val),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('Month: '),
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedMonth,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _selectedMonth = picked);
                },
                child: Text(DateFormat('MM/yyyy').format(_selectedMonth)),
              ),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('Generate Salary Slip PDF'),
            onPressed: _selectedWorkerId == null ? null : () async {
               // Get simplified list of orders for this month/worker logic
               // For MVP, we pass *all* recent orders or mimic logic.
               // Ideally we fetch from repo.
               // Let's assume we fetch *completed unpaid or paid* orders for this month. 
               // Repo logic needed?
               // Let's use `getWorkerOrders` from provider and filter by date.
               await workerProvider.getWorkerOrders(_selectedWorkerId!);
               // Actually, `getWorkerOrders` logic in provider might need update to return list.
               // But `workerProvider` has `_workerOrders` map? No, implementation was weak on caching.
               // Let's just fetch direct.
               
               // Quick hack: Use `ReportingRepository` to fetch data if needed or just pass dummy for demo?
               // Real implementation: Fetch orders for worker.
               // We will use `workerProvider` existing method which returns Future<List>.
               final orders = await workerProvider.getWorkerOrders(_selectedWorkerId!);
               final filtered = orders.where((o) => 
                  o.assignedDate.month == _selectedMonth.month && o.assignedDate.year == _selectedMonth.year
               ).toList();
               
               final worker = workerProvider.workers.firstWhere((w) => w.id == _selectedWorkerId);
               
               await reportRepo.generateSalarySlip(worker: worker, orders: filtered, month: _selectedMonth);
            },
          )
        ],
      ),
    );
  }
}

class FinancialBackupTab extends StatelessWidget {
  const FinancialBackupTab({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ReportingRepository();
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.file_download),
            label: const Text('Export Monthly Stats to Excel'),
            onPressed: () async {
               await repo.generateRevenueReport();
            },
          ),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 40),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              icon: const Icon(Icons.backup),
              label: const Text('Backup Database'),
              onPressed: () async {
                 await repo.backupDatabase();
              }
          )
        ],
      ),
    );
  }
}
