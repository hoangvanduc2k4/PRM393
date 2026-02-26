import 'package:flutter/material.dart';
import '../../data/repositories/financial_repository.dart';
import '../../../workers/data/models/outsourcing_order_model.dart';

class FinancialProvider with ChangeNotifier {
  final FinancialRepository _repository = FinancialRepository();
  
  Map<String, double> _monthlyStats = {'revenue': 0, 'expense': 0, 'profit': 0};
  Map<String, int> _inventoryAnalysis = {};
  List<OutsourcingOrderModel> _unpaidOrders = [];

  Map<String, double> get monthlyStats => _monthlyStats;
  Map<String, int> get inventoryAnalysis => _inventoryAnalysis;
  List<OutsourcingOrderModel> get unpaidOrders => _unpaidOrders;

  Future<void> loadDashboardData() async {
    _monthlyStats = await _repository.getMonthlyStats();
    _inventoryAnalysis = await _repository.getInventoryAnalysis();
    notifyListeners();
  }

  Future<void> loadUnpaidWork(String workerId) async {
    _unpaidOrders = await _repository.getUnpaidWork(workerId);
    notifyListeners();
  }

  Future<void> payWorker(String workerId, double amount, List<String> orderIds) async {
    await _repository.payWorker(workerId: workerId, amount: amount, orderIds: orderIds);
    await loadDashboardData(); // Refresh financials
    await loadUnpaidWork(workerId); // Refresh list
  }
  
  Future<void> recordSale(double amount, String desc) async {
    await _repository.recordSale(amount, desc);
    await loadDashboardData();
  }
}
