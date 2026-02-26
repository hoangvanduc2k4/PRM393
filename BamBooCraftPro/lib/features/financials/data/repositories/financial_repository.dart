import '../../../../core/database/database_helper.dart';
import '../../../workers/data/models/outsourcing_order_model.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/data/models/product_bom_model.dart';
import '../../../materials/data/models/material_model.dart';
import 'package:uuid/uuid.dart';

class FinancialRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  // Get Monthly Stats: Revenue, Expense, Profit
  Future<Map<String, double>> getMonthlyStats() async {
    final db = await _dbHelper.database;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1).toIso8601String();
    
    // Revenue (Type = 'Sale' or 'Revenue')
    final revenueResult = await db.rawQuery(
      "SELECT SUM(amount) as total FROM transactions WHERE type = 'Revenue' OR type = 'Sale' AND date >= ?",
      [startOfMonth]
    );
    double revenue = (revenueResult.first['total'] as num?)?.toDouble() ?? 0.0;

    // Expense (Type = 'Import', 'Salary', 'Expense')
    final expenseResult = await db.rawQuery(
      "SELECT SUM(amount) as total FROM transactions WHERE (type = 'Import' OR type = 'Salary' OR type = 'Expense') AND date >= ?",
      [startOfMonth]
    );
    double expense = (expenseResult.first['total'] as num?)?.toDouble() ?? 0.0;

    return {
      'revenue': revenue,
      'expense': expense,
      'profit': revenue - expense,
    };
  }

  // Get Unpaid Completed Orders for a Worker
  Future<List<OutsourcingOrderModel>> getUnpaidWork(String workerId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'outsourcing_orders',
      where: 'worker_id = ? AND status = ?',
      whereArgs: [workerId, 'Completed'], // Completed but not yet Paid (Paid status would be 'Paid')
    );
    return List.generate(maps.length, (i) => OutsourcingOrderModel.fromMap(maps[i]));
  }

  // Pay Worker
  Future<void> payWorker({
    required String workerId,
    required double amount,
    required List<String> orderIds,
  }) async {
    final db = await _dbHelper.database;
    final now = DateTime.now();

    await db.transaction((txn) async {
       // 1. Create Salary Transaction
       await txn.insert('transactions', {
         'id': _uuid.v4(),
         'type': 'Salary',
         'amount': amount,
         'date': now.toIso8601String(),
         'description': 'Salary Payment for Worker $workerId',
         'reference_id': workerId, // Linking to worker
       });

       // 2. Update Orders to 'Paid'
       for (var id in orderIds) {
         await txn.update(
           'outsourcing_orders',
           {'status': 'Paid'},
           where: 'id = ?',
           whereArgs: [id],
         );
       }
    });
  }
  
  // Record a Generic Sale (For Testing)
  Future<void> recordSale(double amount, String description) async {
      final db = await _dbHelper.database;
      await db.insert('transactions', {
         'id': _uuid.v4(),
         'type': 'Sale',
         'amount': amount,
         'date': DateTime.now().toIso8601String(),
         'description': description,
      });
  }

  // Inventory Analysis: How many products can we make?
  Future<Map<String, int>> getInventoryAnalysis() async {
    final db = await _dbHelper.database;
    
    // Get all Products
    final productsMaps = await db.query('products');
    final products = List.generate(productsMaps.length, (i) => ProductModel.fromMap(productsMaps[i]));

    // Get all Materials
    final materialMaps = await db.query('materials');
    final materials = List.generate(materialMaps.length, (i) => MaterialModel.fromMap(materialMaps[i]));
    final Map<String, double> materialStock = { for (var m in materials) m.id : m.quantityAvailable };

    Map<String, int> analysis = {};

    for (var p in products) {
       // Get BOM
       final bomMaps = await db.query('product_bom', where: 'product_id = ?', whereArgs: [p.id]);
       final boms = List.generate(bomMaps.length, (i) => ProductBomModel.fromMap(bomMaps[i]));
       
       if (boms.isEmpty) {
         analysis[p.name] = 0; // No BOM defined
         continue;
       }

       int maxPossible = 999999;
       
       for (var bom in boms) {
          final stock = materialStock[bom.materialId] ?? 0;
          if (bom.quantityRequired > 0) {
             int possible = (stock / bom.quantityRequired).floor();
             if (possible < maxPossible) maxPossible = possible;
          }
       }
       
       analysis[p.name] = maxPossible == 999999 ? 0 : maxPossible;
    }
    
    return analysis;
  }
}
