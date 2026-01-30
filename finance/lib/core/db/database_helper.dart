import 'package:finance/models/material_item.dart';
import 'package:finance/models/product_item.dart';
import 'package:finance/models/production_log.dart';
import 'package:finance/models/transaction_record.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finance_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Materials Table
    await db.execute('''
      CREATE TABLE materials(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        unit TEXT,
        quantity INTEGER,
        avg_cost REAL
      )
    ''');

    // Products Table
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        unit TEXT,
        quantity INTEGER,
        description TEXT,
        selling_price REAL
      )
    ''');

    // Transactions Table
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        item_id INTEGER,
        item_type TEXT,
        quantity INTEGER,
        price REAL,
        partner_name TEXT,
        date TEXT
      )
    ''');

    // Production Logs Table
    await db.execute('''
      CREATE TABLE production_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER,
        quantity_produced INTEGER,
        date TEXT,
        note TEXT
      )
    ''');
  }

  // Material CRUD
  Future<int> insertMaterial(MaterialItem material) async {
    final db = await database;
    return await db.insert('materials', material.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MaterialItem>> getMaterials() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('materials');
    return List.generate(maps.length, (i) => MaterialItem.fromMap(maps[i]));
  }

  Future<int> updateMaterial(MaterialItem material) async {
    final db = await database;
    return await db.update(
      'materials',
      material.toMap(),
      where: 'id = ?',
      whereArgs: [material.id],
    );
  }

  // Product CRUD
  Future<int> insertProduct(ProductItem product) async {
    final db = await database;
    return await db.insert('products', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ProductItem>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => ProductItem.fromMap(maps[i]));
  }

  Future<int> updateProduct(ProductItem product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Transaction CRUD
  Future<int> insertTransaction(TransactionRecord transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TransactionRecord>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => TransactionRecord.fromMap(maps[i]));
  }

  // Production Log CRUD
  Future<int> insertProductionLog(ProductionLog log) async {
    final db = await database;
    return await db.insert('production_logs', log.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ProductionLog>> getProductionLogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('production_logs', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => ProductionLog.fromMap(maps[i]));
  }
}
