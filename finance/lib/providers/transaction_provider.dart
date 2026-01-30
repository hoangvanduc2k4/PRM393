import 'package:finance/core/db/database_helper.dart';
import 'package:finance/models/outsourcing_log.dart';
import 'package:finance/models/production_log.dart';
import 'package:finance/models/transaction_record.dart';
import 'package:finance/providers/inventory_provider.dart';
import 'package:flutter/foundation.dart';

class TransactionProvider with ChangeNotifier {
  // final DatabaseHelper _dbHelper = DatabaseHelper();
  final InventoryProvider inventoryProvider;

  TransactionProvider(this.inventoryProvider) {
    _initMockData();
  }

  List<TransactionRecord> _transactions = [];
  List<ProductionLog> _productionLogs = [];
  List<OutsourcingLog> _outsourcingLogs = [];

  DateTime _selectedMonth = DateTime.now();
  DateTime get selectedMonth => _selectedMonth;

  void updateMonth(DateTime month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void _initMockData() {
    DateTime now = DateTime.now();
    _transactions = [
      TransactionRecord(id: 1, type: 'IMPORT', itemId: 1, itemType: 'MATERIAL', quantity: 5, price: 2300000, partnerName: 'Anh Ba Hưng (Sơn La)', date: now.subtract(const Duration(days: 2))),
      TransactionRecord(id: 2, type: 'IMPORT', itemId: 2, itemType: 'MATERIAL', quantity: 3, price: 1750000, partnerName: 'Chị Tư (Hòa Bình)', date: now.subtract(const Duration(days: 5))),
      TransactionRecord(id: 11, type: 'IMPORT', itemId: 1, itemType: 'MATERIAL', quantity: 20, price: 2200000, partnerName: 'Anh Ba Hưng (Sơn La)', date: now.subtract(const Duration(days: 35))),
      TransactionRecord(id: 3, type: 'EXPORT', itemId: 1, itemType: 'PRODUCT', quantity: 2, price: 16000000, partnerName: 'Resort Flamingo', date: now.subtract(const Duration(days: 1))),
      TransactionRecord(id: 4, type: 'EXPORT', itemId: 2, itemType: 'PRODUCT', quantity: 1, price: 21000000, partnerName: 'Khu du lịch Bản Đôn', date: now.subtract(const Duration(days: 8))),
      TransactionRecord(id: 12, type: 'EXPORT', itemId: 2, itemType: 'PRODUCT', quantity: 5, price: 20000000, partnerName: 'Khu du lịch Bản Đôn', date: now.subtract(const Duration(days: 40))),
    ];

    _productionLogs = [
      ProductionLog(id: 1, productId: 1, quantityProduced: 2, date: now.subtract(const Duration(days: 6)), note: 'Hoàn thiện 2 ngựa đặt trước'),
      ProductionLog(id: 2, productId: 3, quantityProduced: 5, date: now.subtract(const Duration(days: 5)), note: 'Đơn hàng Hổ đi Singapore'),
    ];

    _outsourcingLogs = [
      OutsourcingLog(id: 1, workerName: 'Cô Năm', taskName: 'Đan thân Ngựa', quantity: 2, pricePerUnit: 500000, totalCost: 1000000, date: now.subtract(const Duration(days: 3))),
      OutsourcingLog(id: 2, workerName: 'Chú Bảy', taskName: 'Làm khung tre Voi', quantity: 1, pricePerUnit: 800000, totalCost: 800000, date: now.subtract(const Duration(days: 4))),
      OutsourcingLog(id: 3, workerName: 'Cô Năm', taskName: 'Đan vảy Rồng', quantity: 10, pricePerUnit: 50000, totalCost: 500000, date: now.subtract(const Duration(days: 32))),
      OutsourcingLog(id: 4, workerName: 'Chú Bảy', taskName: 'Làm khung Rồng', quantity: 2, pricePerUnit: 1500000, totalCost: 3000000, date: now.subtract(const Duration(days: 33))),
    ];
  }

  // Getters with Filter
  List<TransactionRecord> get transactions {
    return _transactions.where((t) => _isSameMonth(t.date)).toList();
  }
  
  List<ProductionLog> get productionLogs {
    return _productionLogs.where((l) => _isSameMonth(l.date)).toList();
  }
  
  List<OutsourcingLog> get outsourcingLogs {
    return _outsourcingLogs.where((l) => _isSameMonth(l.date)).toList();
  }
  
  bool _isSameMonth(DateTime date) {
    return date.year == _selectedMonth.year && date.month == _selectedMonth.month;
  }

  // Stats
  double get totalRevenue => transactions.where((t) => t.type == 'EXPORT').fold(0.0, (sum, t) => sum + (t.quantity * t.price));
  double get totalImportExpense => transactions.where((t) => t.type == 'IMPORT').fold(0.0, (sum, t) => sum + (t.quantity * t.price));
  double get totalLaborCost => outsourcingLogs.fold(0.0, (sum, log) => sum + log.totalCost);
  double get totalProfit => totalRevenue - (totalImportExpense + totalLaborCost);

  Map<String, double> getMonthlyPayroll() {
    final Map<String, double> payroll = {};
    for (var log in outsourcingLogs) {
      if (!payroll.containsKey(log.workerName)) {
        payroll[log.workerName] = 0.0;
      }
      payroll[log.workerName] = payroll[log.workerName]! + log.totalCost;
    }
    return payroll;
  }

  // Missing Methods Restored
  Future<void> loadData() async {
    notifyListeners();
  }

  Future<void> importMaterial(TransactionRecord transaction) async {
    _transactions.insert(0, transaction);
    await inventoryProvider.adjustMaterialQuantity(transaction.itemId, transaction.quantity.toDouble());
    await loadData();
  }

  Future<void> exportProduct(TransactionRecord transaction) async {
    _transactions.insert(0, transaction);
    await inventoryProvider.adjustProductQuantity(transaction.itemId, -transaction.quantity);
    await loadData();
  }

  Future<void> produceProduct(ProductionLog log) async {
    _productionLogs.insert(0, log);
    await inventoryProvider.adjustProductQuantity(log.productId, log.quantityProduced);
    await loadData();
  }

  Future<void> addOutsourcingLog(OutsourcingLog log) async {
    _outsourcingLogs.insert(0, log);
    
    // Deduct Material if used
    if (log.materialId != null && log.materialUsedAmount != null && log.materialUsedAmount! > 0) {
      await inventoryProvider.adjustMaterialQuantity(log.materialId!, -log.materialUsedAmount!);
      // Note: We might want to record a material usage transaction implicitly, 
      // but for now keeping it simple as just inventory deduction.
    }
    
    notifyListeners();
  }
}
