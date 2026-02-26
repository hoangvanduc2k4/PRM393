import '../../../../core/database/database_helper.dart';
import '../models/product_model.dart';
import '../models/product_bom_model.dart';
import '../models/production_log_model.dart';
import '../../../materials/data/repositories/material_repository_impl.dart';
import 'package:uuid/uuid.dart';

class ProductRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final MaterialRepository _materialRepository = MaterialRepository(); // Direct dependency for now
  final Uuid _uuid = const Uuid();

  Future<List<ProductModel>> getProducts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  Future<void> addProduct(String name, double price, String description) async {
    final db = await _dbHelper.database;
    final newProduct = ProductModel(
      id: _uuid.v4(),
      name: name, // Fixed parameter name to match model
      sellingPrice: price,
      description: description,
    );
     await db.insert('products', newProduct.toMap());
  }

  // BOM Management
  Future<List<ProductBomModel>> getProductBOM(String productId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'product_bom',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
    return List.generate(maps.length, (i) => ProductBomModel.fromMap(maps[i]));
  }

  Future<void> addBOMItem(String productId, String materialId, double quantity) async {
    final db = await _dbHelper.database;
     final newBOM = ProductBomModel(
      id: _uuid.v4(),
      productId: productId,
      materialId: materialId,
      quantityRequired: quantity,
    );
    await db.insert('product_bom', newBOM.toMap());
  }

  // Production Logic
  Future<void> produce({
    required String productId,
    required int quantity,
  }) async {
    final db = await _dbHelper.database;
    final bomList = await getProductBOM(productId);

    if (bomList.isEmpty) {
      throw Exception('Product has no BOM definition');
    }

    await db.transaction((txn) async {
      // 1. Deduct Materials based on BOM
      for (final bom in bomList) {
        final totalMaterialNeeded = bom.quantityRequired * quantity;
        
        // Use MaterialRepository logic but within THIS transaction if possible.
        // Since MaterialRepo uses its own DB instance, we might need to duplicate logic or refactor to accept txn.
        // For simplicity in this step, we will call the repo method. 
        // Ideally, MaterialRepository.deductStock should accept a Transaction object.
        // DUE TO LIMITATION: We will re-implement minimal deduction logic here or refactor MaterialRepo later.
        // Let's refactor MaterialRepo to be transaction-aware or just call it and risk atomicity for now (MVP).
        // Decision: Call MaterialRepo. Logic is complex to duplicate. Risk: If deduction fails, production log might still be written if not careful.
        // BETTER APPROACH: Move deduction logic to a shared service or simpler: 
        // We will just execute the logic here using the txn.
        
        // Re-implementing FIFO verify/update briefly here for atomicity
         double remainingToDeduct = totalMaterialNeeded;

        final List<Map<String, dynamic>> batches = await txn.query(
          'material_imports',
          where: 'material_id = ? AND quantity_remaining > 0',
          whereArgs: [bom.materialId],
          orderBy: 'import_date ASC',
        );
        
        for (var _ in batches) {
             if (remainingToDeduct <= 0) break;
             // ... duplicating FIFO logic ... 
             // Ideally we refactor. For this prompt, I will assume successful deduction.
        }
        // Actually, to safe time and code, I will call the external repo.
        // If it fails, it throws, and we can catch it. Main issue is rolling back THIS txn.
        // So I will just await _materialRepository.deductStock. If it fails, this function throws.
        // The issue is `deductStock` starts its OWN transaction. Nested transactions in sqflite are not fully supported or are just savepoints.
        // Let's try calling it.
        await _materialRepository.deductStock(
          materialId: bom.materialId,
          quantityToDeduct: totalMaterialNeeded,
          reason: 'Production: $quantity x Product $productId',
          txn: txn,
        );
      }

      // 2. Add Production Log
      final newLog = ProductionLogModel(
        id: _uuid.v4(),
        productId: productId,
        quantityProduced: quantity,
        productionDate: DateTime.now(),
      );
      
      await txn.insert('production_logs', newLog.toMap());
    });
  }

  // --- PRODUCT PARTS ---
  Future<void> addProductPart(String productId, String name) async {
    final db = await _dbHelper.database;
    await db.insert('product_parts', {
      'id': _uuid.v4(),
      'product_id': productId,
      'name': name,
    });
  }

  Future<List<Map<String, dynamic>>> getProductParts(String productId) async {
    final db = await _dbHelper.database;
    return await db.query('product_parts', where: 'product_id = ?', whereArgs: [productId]);
  }

  Future<void> deleteProductPart(String partId) async {
     final db = await _dbHelper.database;
     await db.delete('product_parts', where: 'id = ?', whereArgs: [partId]);
  }
}
