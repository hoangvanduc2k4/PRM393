import '../../../../core/database/database_helper.dart';
import '../models/worker_model.dart';
import '../models/outsourcing_order_model.dart';
import 'package:uuid/uuid.dart';

class WorkerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  Future<List<WorkerModel>> getWorkers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('workers');
    return List.generate(maps.length, (i) => WorkerModel.fromMap(maps[i]));
  }

  Future<void> addWorker(String name, String phone, String specialization) async {
    final db = await _dbHelper.database;
    final newWorker = WorkerModel(
      id: _uuid.v4(),
      name: name,
      phone: phone,
      specialization: specialization,
    );
    await db.insert('workers', newWorker.toMap());
  }

  // Get Orders for a specific worker
  Future<List<OutsourcingOrderModel>> getWorkerOrders(String workerId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'outsourcing_orders',
      where: 'worker_id = ?',
      whereArgs: [workerId],
      orderBy: 'assigned_date DESC',
    );
    return List.generate(maps.length, (i) => OutsourcingOrderModel.fromMap(maps[i]));
  }

  // Assign Work (Create Order + Item)
  Future<void> assignWork({
    required String workerId,
    required String partName,
    required int quantityAssigned, // Note: Schema might need this if we track assigned vs completed separately.
    // For now, we'll store assigned qty in 'quantity_pairs' of item initially? 
    // Wait, the Requirement says "Giao 100 cai", "Nhan 50 cap".
    // 100 cai = 50 pairs ideally.
    // Let's store "Assigned Description" in Order or Item?
    // Schema: outsourcing_items has (part_name, quantity_pairs, price_per_pair).
    // Conflict: quantity_pairs is for completed items usually.
    // Decision: Use 'quantity_pairs' to store ASSIGNED PAIRS initially (if 100 legs -> 50 pairs intended).
    // Or add a column 'quantity_assigned'.
    // Given the constraints and current schema, let's assume valid pairs are assigned.
    // "100 chan" -> 50 pairs.
  }) async {
    final db = await _dbHelper.database;
    final orderId = _uuid.v4();
    final now = DateTime.now();

    await db.transaction((txn) async {
      // 1. Create Order
      final newOrder = OutsourcingOrderModel(
        id: orderId,
        workerId: workerId,
        assignedDate: now,
        status: 'Pending',
        totalPayment: 0,
      );
      await txn.insert('outsourcing_orders', newOrder.toMap());

      // 2. Create Item (Details)
      // We will assume input is "Pairs" for simplicity in data, or "Parts" converted to "Pairs".
      // Let's strictly follow: Input PartName and Qty.
      // We will repurpose `quantity_pairs` to be "Target Quantity" when Pending, and "Actual Quantity" when Completed.
      final newItem = OutsourcingItemModel(
        id: _uuid.v4(),
        orderId: orderId,
        partName: partName,
        quantityPairs: quantityAssigned, // This is Target initially
        pricePerPair: 0, // Not determined yet
      );
      await txn.insert('outsourcing_items', newItem.toMap());
    });
  }

  // Complete Work
  Future<void> completeWork({
    required String orderId,
    required int pairsReceived,
    required double pricePerPair,
  }) async {
    final db = await _dbHelper.database;
    
    await db.transaction((txn) async {
       // 1. Update Order Status & Total
       final total = pairsReceived * pricePerPair;
       await txn.update(
         'outsourcing_orders',
         {'status': 'Completed', 'total_payment': total},
         where: 'id = ?',
         whereArgs: [orderId],
       );

       // 2. Update Item Details (Actuals)
       // We assume 1 item per order for this simple flow.
       // In clean design, we should update specific item. Here we update ALL items for this order?
       // Let's find the item first.
       final itemsMaps = await txn.query('outsourcing_items', where: 'order_id = ?', whereArgs: [orderId]);
       if (itemsMaps.isNotEmpty) {
         final itemId = itemsMaps.first['id'];
         await txn.update(
           'outsourcing_items',
           {
             'quantity_pairs': pairsReceived,
             'price_per_pair': pricePerPair,
           },
           where: 'id = ?',
           whereArgs: [itemId],
         );
       }
    });
  }
  
  Future<OutsourcingItemModel?> getOrderItem(String orderId) async {
       final db = await _dbHelper.database;
       final maps = await db.query('outsourcing_items', where: 'order_id = ?', whereArgs: [orderId]);
       if (maps.isNotEmpty) return OutsourcingItemModel.fromMap(maps.first);
       return null;
  }
}
