import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/financial_provider.dart';
import '../../../../core/utils/currency_formatter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<FinancialProvider>(context, listen: false).loadDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Dashboard')),
      body: Consumer<FinancialProvider>(
        builder: (context, provider, child) {
          final revenue = provider.monthlyStats['revenue'] ?? 0.0;
          final expense = provider.monthlyStats['expense'] ?? 0.0;
          final profit = provider.monthlyStats['profit'] ?? 0.0;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Financial Cards
                  Row(
                    children: [
                      _buildStatCard('Revenue', revenue, Colors.green),
                      const SizedBox(width: 8),
                      _buildStatCard('Expense', expense, Colors.red),
                      const SizedBox(width: 8),
                      _buildStatCard('Profit', profit, profit >= 0 ? Colors.blue : Colors.orange),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 2. Chart
                  const Text('Monthly Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                             sideTitles: SideTitles(
                               showTitles: true,
                               getTitlesWidget: (val, meta) {
                                  if (val == 0) return const Text('Rev');
                                  if (val == 1) return const Text('Exp');
                                  return const Text('');
                               }
                             )
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [
                            BarChartRodData(toY: revenue == 0 ? 1 : revenue, color: Colors.green, width: 30),
                          ]),
                          BarChartGroupData(x: 1, barRods: [
                             BarChartRodData(toY: expense == 0 ? 1 : expense, color: Colors.red, width: 30),
                          ]),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  
                  // 3. Inventory Analysis
                  const Text('Inventory Potential (Max Production)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  if (provider.inventoryAnalysis.isEmpty)
                    const Text('No products or materials defined.')
                  else
                    ...provider.inventoryAnalysis.entries.map((entry) {
                       return Card(
                         child: ListTile(
                           leading: const Icon(Icons.lightbulb, color: Colors.amber),
                           title: Text(entry.key),
                           subtitle: Text('Can produce: ${entry.value} units'),
                           trailing: entry.value == 0 ? const Icon(Icons.warning, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                         ),
                       );
                    }),
                    
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                        // Quick Action: Record Sale for Demo
                        _showRecordSaleDialog(context);
                    }, 
                    child: const Text('Record Manual Sale (Demo)')
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, double value, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                CurrencyFormatter.format(value),
                style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showRecordSaleDialog(BuildContext context) {
      final amountController = TextEditingController();
      showDialog(context: context, builder: (ctx) => AlertDialog(
          title: const Text('Record Sale'),
          content: TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
          actions: [
             TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
             TextButton(onPressed: () {
                 final amt = double.tryParse(amountController.text);
                 if (amt != null) {
                    Provider.of<FinancialProvider>(context, listen: false).recordSale(amt, 'Manual Sale');
                    if (context.mounted) Navigator.pop(ctx);
                 }
             }, child: const Text('Record'))
          ],
      ));
  }
}
