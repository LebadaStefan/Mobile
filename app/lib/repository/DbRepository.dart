import 'package:template/database/DatabaseProvider.dart';
import 'package:template/model/Vehicle.dart';

class DbRepository{
  List<Vehicle> productList;
  List<Vehicle> productListOffline;
  Repository(){
    productList = new List<Vehicle>();
    productListOffline = new List<Vehicle>();
    this.init();
  }
  void init() async{
    this.productList = await DatabaseProvider.db.getVehicle();
    this.productList = await DatabaseProvider.dbOffline.getVehicleOffline();
    //this.productList = await ServerProvider.server.fetchProducts();
  }

  void addProduct(String license, String status, int seats, String driver, String color, int cargo) async {
    Vehicle vehicle = Vehicle(license: license, status: status, seats: seats, driver: driver, color: color, cargo: cargo);
    await DatabaseProvider.db.insert(vehicle);
    //await ServerProvider.server.postProduct(Vehicle);
  }

  void addProductOffline(String license, String status, int seats, String driver, String color, int cargo) async {
    Vehicle vehicle = Vehicle(license: license, status: status, seats: seats, driver: driver, color: color, cargo: cargo);
    await DatabaseProvider.dbOffline.insertOffline(vehicle);
    //await ServerProvider.server.postProduct(Vehicle);
  }

  void removeProduct(int id) async{
    this.productList.removeWhere((vehicle) => vehicle.id == id);
    await DatabaseProvider.db.remove(id);
    //await ServerProvider.server.deleteProduct(id);
  }

  void updateProduct(int id, String license, String status, int seats, String driver, String color, int cargo) async {
    await DatabaseProvider.db.update(id, license, status, seats, driver, color, cargo);
    //await ServerProvider.server.putProduct(Vehicle(id: id, license: newlicense, expirationDate: newExpirationDate, quantity: newQuantity, price: newPrice));
  }

  Vehicle getProduct(int id) {
    return this.productList.firstWhere((vehicle) => vehicle.id == id);
  }

  void deleteAll() async{
    await DatabaseProvider.db.deleteAll();
  }

  void deleteAllOffline() async{
    await DatabaseProvider.dbOffline.deleteAllOffline();
  }

  void repopulate(List<Vehicle> vehicles){
    this.deleteAll();
    for(Vehicle vehicle in vehicles){
      this.addProduct(vehicle.license, vehicle.status, vehicle.seats, vehicle.driver, vehicle.color, vehicle.cargo);
    }
  }
  int size(){
    return productList.length;
  }
}