import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/material_model.dart';
import '../models/material_import_model.dart';
import 'package:uuid/uuid.dart';

class MaterialRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  Future<List<MaterialModel>> getMaterials() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('materials');
    return List.generate(maps.length, (i) => MaterialModel.fromMap(maps[i]));
  }

  Future<void> addMaterial(String name, String unit) async {
    final db = await _dbHelper.database;
    final newMaterial = MaterialModel(
      id: _uuid.v4(),
      name: name,
      unit: unit,
      quantityAvailable: 0,
      lastUpdated: DateTime.now(),
    );
    await db.insert('materials', newMaterial.toMap());
  }

  Future<void> updateMaterial(MaterialModel material) async {
    final db = await _dbHelper.database;
    await db.update(
      'materials',
      material.toMap(),
      where: 'id = ?',
      whereArgs: [material.id],
    );
  }

  // FIFO Import Logic
  Future<void> importMaterial({
    required String materialId,
    required double quantity,
    required double price,
    String? source,
  }) async {
    final db = await _dbHelper.database;
    final importId = _uuid.v4();
    final now = DateTime.now();

    // 1. Create Import Record
    final newImport = MaterialImportModel(
      id: importId,
      materialId: materialId,
      source: source,
      importDate: now,
      unitPrice: price,
      quantity: quantity,
      quantityRemaining: quantity, // Intially full
      totalCost: quantity * price,
    );

    // 2. Update Total Stock
    // Get current material to update stock
    final materialMaps = await db.query(
      'materials',
      where: 'id = ?',
      whereArgs: [materialId],
    );

    if (materialMaps.isNotEmpty) {
      final material = MaterialModel.fromMap(materialMaps.first);
      final updatedMaterial = MaterialModel(
        id: material.id,
        name: material.name,
        unit: material.unit,
        quantityAvailable: material.quantityAvailable + quantity,
        lastUpdated: now,
      );

      await db.transaction((txn) async {
        await txn.insert('material_imports', newImport.toMap());
        await txn.update(
          'materials',
          updatedMaterial.toMap(),
          where: 'id = ?',
          whereArgs: [materialId],
        );
                 // Log Transaction (Expense)
        await txn.insert('transactions', {
          'id': _uuid.v4(),
          'type': 'Import',
          'amount': quantity * price,
          'date': now.toIso8601String(),
          'description': 'Import ${material.name} from $source',
          'reference_id': importId,
        });
      });
    }
  }

  // FIFO Deduction Logic
  Future<void> deductStock({
    required String materialId,
    required double quantityToDeduct,
    required String reason,
    Transaction? txn,
  }) async {
    final db = await _dbHelper.database;

    Future<void> logic(Transaction t) async {
       double remainingToDeduct = quantityToDeduct;

      // 1. Get batches with remaining quantity > 0, ordered by date ASC (FIFO)
      final List<Map<String, dynamic>> batches = await t.query(
        'material_imports',
        where: 'material_id = ? AND quantity_remaining > 0',
        whereArgs: [materialId],
        orderBy: 'import_date ASC',
      );

      for (var batchMap in batches) {
        if (remainingToDeduct <= 0) break;

        final batch = MaterialImportModel.fromMap(batchMap);
        double deductFromBatch = 0;

        if (batch.quantityRemaining >= remainingToDeduct) {
          deductFromBatch = remainingToDeduct;
          remainingToDeduct = 0;
        } else {
          deductFromBatch = batch.quantityRemaining;
          remainingToDeduct -= batch.quantityRemaining;
        }

        // Update Batch
        await t.update(
          'material_imports',
          {'quantity_remaining': batch.quantityRemaining - deductFromBatch},
          where: 'id = ?',
          whereArgs: [batch.id],
        );
      }

      if (remainingToDeduct > 0) {
        throw Exception('Not enough stock for material $materialId. Missing $remainingToDeduct');
      }

      // 2. Update Total Stock
      final materialMaps = await t.query(
        'materials',
        where: 'id = ?',
        whereArgs: [materialId],
      );
      
      if (materialMaps.isNotEmpty) {
        final material = MaterialModel.fromMap(materialMaps.first);
         // Log usage? Or just update.
         // Reason is not currently stored in material_transactions but could be later.
         
         await t.update(
          'materials',
          {'quantity_available': material.quantityAvailable - quantityToDeduct, 'last_updated': DateTime.now().toIso8601String()},
          where: 'id = ?',
          whereArgs: [materialId],
        );
      }
    }

    if (txn != null) {
      await logic(txn);
    } else {
      await db.transaction((t) async {
        await logic(t);
      });
    }
  }
}
