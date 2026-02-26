import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bamboo_craft_pro.db');
    return _database!;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE material_imports ADD COLUMN quantity_remaining REAL DEFAULT 0');
      // Initialize quantity_remaining to quantity for existing records
      await db.execute('UPDATE material_imports SET quantity_remaining = quantity');
    }
    if (oldVersion < 3) {
      // Version 3: Product Parts & Units
      await db.execute('''
        CREATE TABLE product_parts (
          id TEXT PRIMARY KEY,
          product_id TEXT NOT NULL,
          name TEXT NOT NULL,
          description TEXT,
          FOREIGN KEY (product_id) REFERENCES products (id)
        )
      ''');

      await db.execute('''
        CREATE TABLE units (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL
        )
      ''');
      
      // Seed default units
      await db.insert('units', {'id': '1', 'name': 'Cái'});
      await db.insert('units', {'id': '2', 'name': 'Cặp'});
      await db.insert('units', {'id': '3', 'name': 'Bộ'});
      await db.insert('units', {'id': '4', 'name': 'Kg'});
      await db.insert('units', {'id': '5', 'name': 'Tấn'});
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3, // Increment version
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Inventory
    await db.execute('''
      CREATE TABLE materials (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        unit TEXT NOT NULL,
        quantity_available REAL NOT NULL,
        last_updated TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE material_imports (
        id TEXT PRIMARY KEY,
        material_id TEXT NOT NULL,
        source TEXT,
        import_date TEXT NOT NULL,
        unit_price REAL NOT NULL,
        quantity REAL NOT NULL,
        quantity_remaining REAL NOT NULL,
        total_cost REAL NOT NULL,
        FOREIGN KEY (material_id) REFERENCES materials (id)
      )
    ''');

    // 2. Production & BOM
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        selling_price REAL NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE product_bom (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        material_id TEXT NOT NULL,
        quantity_required REAL NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products (id),
        FOREIGN KEY (material_id) REFERENCES materials (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE production_logs (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        quantity_produced INTEGER NOT NULL,
        production_date TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');


    // 3. Workers & Outsourcing
    await db.execute('''
      CREATE TABLE workers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT,
        specialization TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE outsourcing_orders (
        id TEXT PRIMARY KEY,
        worker_id TEXT NOT NULL,
        assigned_date TEXT NOT NULL,
        status TEXT NOT NULL,
        total_payment REAL NOT NULL,
        FOREIGN KEY (worker_id) REFERENCES workers (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE outsourcing_items (
        id TEXT PRIMARY KEY,
        order_id TEXT NOT NULL,
        part_name TEXT NOT NULL,
        quantity_pairs INTEGER NOT NULL,
        price_per_pair REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES outsourcing_orders (id)
      )
    ''');

    // 4. Financials
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        description TEXT,
        reference_id TEXT
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
