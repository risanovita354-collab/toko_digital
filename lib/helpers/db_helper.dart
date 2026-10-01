import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'tumbler_store.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabel master_products
        await db.execute('''
          CREATE TABLE master_products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL,
            image_path TEXT
          )
        ''');

        // Tabel local_cart (dengan kolom image_path)
        await db.execute('''
          CREATE TABLE local_cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id INTEGER,
            name TEXT,
            price REAL,
            quantity INTEGER,
            image_path TEXT
          )
        ''');

        // Populate Data Awal Produk Tumbler
        await db.insert('master_products', {
          'name': 'Tumbler Stainless Classic',
          'price': 85000.0,
          'image_path': 'assets/images/tumbler 1.png'
        });
        await db.insert('master_products', {
          'name': 'Tumbler Sport Edition',
          'price': 95000.0,
          'image_path': 'assets/images/tumbler 2.png'
        });
        await db.insert('master_products', {
          'name': 'Tumbler Vacuum Insulated',
          'price': 120000.0,
          'image_path': 'assets/images/tumbler 3.png'
        });
        await db.insert('master_products', {
          'name': 'Tumbler Minimalist Eco',
          'price': 75000.0,
          'image_path': 'assets/images/tumbler 4.png'
        });
        await db.insert('master_products', {
          'name': 'Tumbler Thermos Premium',
          'price': 150000.0,
          'image_path': 'assets/images/tumbler 5.png'
        });
        await db.insert('master_products', {
          'name': 'Tumbler Glass Straw',
          'price': 65000.0,
          'image_path': 'assets/images/tumbler 6.png'
        });
      },
    );
  }

  static Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('master_products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  static Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('local_cart');
    return List.generate(maps.length, (i) => CartItem.fromMap(maps[i]));
  }

  static Future<void> insertCartItem(CartItem item) async {
    final db = await database;
    await db.insert(
      'local_cart',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateCartQuantity(int id, int quantity) async {
    final db = await database;
    await db.update(
      'local_cart',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteCartItem(int id) async {
    final db = await database;
    await db.delete(
      'local_cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}