import 'package:finance/providers/transaction_provider.dart';
import 'package:finance/screens/export/export_screen.dart';
import 'package:finance/screens/import/import_screen.dart';
import 'package:finance/screens/inventory/inventory_screen.dart';
import 'package:finance/screens/outsourcing/outsourcing_screen.dart';
import 'package:finance/screens/production/production_screen.dart';
import 'package:finance/widgets/month_picker.dart'; // NEW
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    DashboardHomeTab(),
    ImportScreen(),
    ProductionScreen(),
    OutsourcingScreen(),
    ExportScreen(),
    InventoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dash',
          ),
          NavigationDestination(
            icon: Icon(Icons.download_outlined),
            selectedIcon: Icon(Icons.download),
            label: 'Nhập',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined),
            selectedIcon: Icon(Icons.build),
            label: 'SX',
          ),
           NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Thợ',
          ),
          NavigationDestination(
            icon: Icon(Icons.upload_outlined),
            selectedIcon: Icon(Icons.upload),
            label: 'Xuất',
          ),
           NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Kho',
          ),
        ],
      ),
    );
  }
}

class DashboardHomeTab extends StatelessWidget {
  const DashboardHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tổng Quan VIP'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          final revenue = provider.totalRevenue;
          final expense = provider.totalImportExpense;
          final labor = provider.totalLaborCost;
          final profit = provider.totalProfit;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Centered
              children: [
                // Month Picker
                MonthPicker(
                  selectedDate: provider.selectedMonth, 
                  onDateChanged: (newDate) => provider.updateMonth(newDate),
                ),
                const SizedBox(height: 24),
                
                // MAIN CARDS
                Row(
                  children: [
                    Expanded(child: _SummaryCard(title: 'Doanh Thu', value: revenue, color: const Color(0xFF00E676), icon: Icons.attach_money)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(title: 'Nhập Tre', value: expense, color: Colors.orangeAccent, icon: Icons.shopping_cart),
                    ),
                    const SizedBox(width: 8), // Small gap
                    Expanded(
                      child: _SummaryCard(title: 'Gia Công', value: labor, color: Colors.purpleAccent, icon: Icons.groups),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                 Row(
                  children: [
                    Expanded(child: _SummaryCard(title: 'Lợi Nhuận', value: profit, color: profit >= 0 ? Colors.blueAccent : Colors.red, icon: Icons.bar_chart)),
                  ],
                ),

                const SizedBox(height: 32),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Hoạt Động Gần Đây', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                _RecentActivityList(provider: provider),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  NumberFormat.compactCurrency(locale: 'vi_VN', symbol: 'đ').format(value),
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentActivityList extends StatelessWidget {
  final TransactionProvider provider;

  const _RecentActivityList({required this.provider});

  @override
  Widget build(BuildContext context) {
    var recent = provider.transactions.take(5).toList();
    if (recent.isEmpty) return const Text('Chưa có hoạt động nào');

    return Column(
      children: recent.map((t) {
        final isImport = t.type == 'IMPORT';
        return Card(
          elevation: 0,
          color: const Color(0xFF1E1E1E),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              isImport ? Icons.arrow_downward : Icons.arrow_upward,
              color: isImport ? Colors.redAccent : Colors.greenAccent,
            ),
            title: Text(isImport ? 'Nhập hàng' : 'Xuất hàng'),
            subtitle: Text(DateFormat('dd/MM HH:mm').format(t.date)),
            trailing: Text(
              NumberFormat.compactCurrency(locale: 'vi_VN', symbol: 'đ').format(t.price * t.quantity),
              style: TextStyle(
                color: isImport ? Colors.redAccent : Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
