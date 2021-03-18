import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:template/model/Vehicle.dart';
class DatabaseProvider{
  static const String COLUMN_ID = "id";
  static const String COLUMN_LICENSE = "license";
  static const String COLUMN_STATUS = "status";
  static const String COLUMN_SEATS = "seats";
  static const String COLUMN_DRIVER = "driver";
  static const String COLUMN_COLOR = "color";
  static const String COLUMN_CARGO = "cargo";
  static const String TABLE_VEHICLES = "vehicles";
  static const String TABLE_VEHICLES_OFFLINE = "vehiclesOffline";
  
  DatabaseProvider._();
  
  static final db = DatabaseProvider._();
  static final dbOffline = DatabaseProvider._();

  Database _database;
  Database _databaseOffline;

  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await createDatabase();
    return _database;
  }

  Future<Database> get databaseOffline async {
    if(_databaseOffline != null) return _databaseOffline;

    _databaseOffline = await createDatabase();
    return _databaseOffline;
  }

  Future<Database> createDatabase() async{
    String dbPath = await getDatabasesPath();

    return await openDatabase(join(dbPath, 'vehicles.db'), version: 1,
        onCreate: (Database database, int version) async{
          print("Creating vehicles table");

          await database.execute("CREATE TABLE $TABLE_VEHICLES ("
              "$COLUMN_ID INTEGER PRIMARY KEY,"
              "$COLUMN_LICENSE TEXT,"
              "$COLUMN_STATUS TEXT,"
              "$COLUMN_SEATS INTEGER,"
              "$COLUMN_DRIVER TEXT,"
              "$COLUMN_COLOR TEXT,"
              "$COLUMN_CARGO INTEGER"
              ")");
        });
  }

  Future<Database> createDatabaseOffline() async{
    String dbPath = await getDatabasesPath();

    return await openDatabase(join(dbPath, 'vehiclesOffline.db'), version: 1,
        onCreate: (Database database, int version) async{
          print("Creating vehicles table");

          await database.execute("CREATE TABLE $TABLE_VEHICLES ("
              "$COLUMN_ID INTEGER PRIMARY KEY,"
              "$COLUMN_LICENSE TEXT,"
              "$COLUMN_STATUS TEXT,"
              "$COLUMN_SEATS INTEGER,"
              "$COLUMN_DRIVER TEXT,"
              "$COLUMN_COLOR TEXT,"
              "$COLUMN_CARGO INTEGER"
              ")");
        });
  }

  Future<List<Vehicle>> getVehicle() async {
    final db = await database;
    var products = await db.query(TABLE_VEHICLES,
        columns: [COLUMN_ID, COLUMN_LICENSE, COLUMN_STATUS, COLUMN_SEATS, COLUMN_DRIVER, COLUMN_COLOR, COLUMN_CARGO]);
    List<Vehicle> vehiclesList = List<Vehicle>();
    products.forEach((currentVehicle){
      Vehicle vehicle = Vehicle.fromMap(currentVehicle);
      vehiclesList.add(vehicle);
    });
    return vehiclesList;
  }

  Future<List<Vehicle>> getVehicleOffline() async {
    final db = await databaseOffline;
    var vehicles = await db.query(TABLE_VEHICLES_OFFLINE,
        columns: [COLUMN_ID, COLUMN_LICENSE, COLUMN_STATUS, COLUMN_SEATS, COLUMN_DRIVER, COLUMN_COLOR, COLUMN_CARGO]);
    List<Vehicle> vehiclesList = List<Vehicle>();
    vehicles.forEach((currentVehicle){
      Vehicle vehicle = Vehicle.fromMap(currentVehicle);
      vehiclesList.add(vehicle);
    });
    return vehiclesList;
  }

  Future<Vehicle> insert (Vehicle vehicle) async{
    final db = await database;
    vehicle.id = await db.insert(TABLE_VEHICLES, vehicle.toMap());
    return vehicle;
  }

  Future<Vehicle> insertOffline (Vehicle vehicle) async{
    final db = await databaseOffline;
    vehicle.id = await db.insert(TABLE_VEHICLES_OFFLINE, vehicle.toMap());
    return vehicle;
  }

  Future<bool> remove(int id) async{
    final db = await database;
    int result = await db.delete(TABLE_VEHICLES, where: "id = ?", whereArgs: [id]);
    return result == 1;
  }

  Future<bool> update(int id, String license, String status, int seats, String driver, String color, int cargo) async {
    final db = await database;
    Vehicle vehicle = new Vehicle(
        id: id, license: license, status: status, seats: seats, driver: driver, color: color, cargo: cargo);
    int result = await db.update(TABLE_VEHICLES, vehicle.toMap(), where: "id = ?", whereArgs: [id]);
    return result == 1;
  }

  Future<int> deleteAll() async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $TABLE_VEHICLES');
    return result;
  }

  Future<int> deleteAllOffline() async {
    var db = await this.databaseOffline;
    int result = await db.rawDelete('DELETE FROM $TABLE_VEHICLES_OFFLINE');
    return result;
  }
  
}