
import 'package:assignment_test/model/product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_PRODUCT = "product";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_LAUNCHEDAT = "launchedAt";
  static const String COLUMN_LAUNCHSITE = "launchSite";
  static const String COLUMN_POPULARITY = "popularity";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'productDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating product table");

        await database.execute(
          "CREATE TABLE $TABLE_PRODUCT ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_NAME TEXT,"
          "$COLUMN_LAUNCHEDAT TEXT,"
          "$COLUMN_LAUNCHSITE TEXT,"
          "$COLUMN_POPULARITY TEXT"
          ")",
        );
      },
    );
  }

  Future<List<Product>> getProducts() async {
    final db = await database;

    var products = await db
        .query(TABLE_PRODUCT, columns: [COLUMN_ID, COLUMN_NAME, COLUMN_LAUNCHEDAT, COLUMN_LAUNCHSITE,COLUMN_POPULARITY]);

    List<Product> productList = List<Product>();

    products.forEach((currentProduct) {
      Product product = Product.fromMap(currentProduct);

      productList.add(product);
    });

    return productList;
  }

  Future<Product> insert(Product product) async {
    final db = await database;
    product.id = await db.insert(TABLE_PRODUCT, product.toMap());
    return product;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_PRODUCT,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Product product) async {
    final db = await database;

    return await db.update(
      TABLE_PRODUCT,
      product.toMap(),
      where: "id = ?",
      whereArgs: [product.id],
    );
  }
}