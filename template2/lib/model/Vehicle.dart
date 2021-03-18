import 'package:template/database//DatabaseProvider.dart';
class Vehicle{
  int id;
  String license;
  String status;
  int seats;
  String driver;
  String color;
  int cargo;

  Vehicle({this.id, this.license, this.status, this.seats, this.driver, this.color, this.cargo});

  factory Vehicle.fromJson(Map<String, dynamic> json){
    return Vehicle(id: json['id'], license: json['license'], status: json['status'], seats: json['seats'], driver: json['driver'], color: json['color'], cargo: json['cargo']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_LICENSE: license,
      DatabaseProvider.COLUMN_STATUS: status,
      DatabaseProvider.COLUMN_SEATS: seats,
      DatabaseProvider.COLUMN_DRIVER: driver,
      DatabaseProvider.COLUMN_COLOR: color,
      DatabaseProvider.COLUMN_CARGO: cargo
    };

    if(id != null){
      map[DatabaseProvider.COLUMN_ID] = id;
    }
    return map;
  }

  Vehicle.fromMap(Map<String, dynamic> map){
    id = map[DatabaseProvider.COLUMN_ID];
    license = map[DatabaseProvider.COLUMN_LICENSE];
    status = map[DatabaseProvider.COLUMN_STATUS];
    seats = map[DatabaseProvider.COLUMN_SEATS];
    driver = map[DatabaseProvider.COLUMN_DRIVER];
    color = map[DatabaseProvider.COLUMN_COLOR];
    cargo = map[DatabaseProvider.COLUMN_CARGO];
  }

}