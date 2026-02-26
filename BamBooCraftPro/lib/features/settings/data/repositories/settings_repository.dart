import 'package:uuid/uuid.dart';
import '../../../../core/database/database_helper.dart';

class SettingsRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  // --- UNITS ---
  Future<List<String>> getUnits() async {
    final db = await _dbHelper.database;
    final result = await db.query('units');
    return result.map((e) => e['name'] as String).toList();
  }

  Future<void> addUnit(String name) async {
    final db = await _dbHelper.database;
    await db.insert('units', {
      'id': _uuid.v4(),
      'name': name,
    });
  }

  Future<void> deleteUnit(String name) async {
     final db = await _dbHelper.database;
     await db.delete('units', where: 'name = ?', whereArgs: [name]);
  }

  // --- PRODUCT PARTS ---
  Future<List<Map<String, dynamic>>> getProductParts(String productId) async {
    final db = await _dbHelper.database;
    return await db.query('product_parts', where: 'product_id = ?', whereArgs: [productId]);
  }

  Future<void> addProductPart(String productId, String name) async {
    final db = await _dbHelper.database;
    await db.insert('product_parts', {
      'id': _uuid.v4(),
      'product_id': productId,
      'name': name,
    });
  }
  
  Future<void> deleteProductPart(String id) async {
    final db = await _dbHelper.database;
    await db.delete('product_parts', where: 'id = ?', whereArgs: [id]);
  }
}
