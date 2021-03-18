import 'package:template/model/Vehicle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class ServerProvider{
  final String url = "http://192.168.1.2:2021/";
  ServerProvider._();

  static final server = ServerProvider._();

  Future<List<Vehicle>> fetchAll() async {
    final response = await http.get(url + 'all');
    List<Vehicle> roomsList = List<Vehicle>();
    if(response.statusCode == 200){
      jsonDecode(response.body).forEach((element){
        Vehicle room = Vehicle.fromJson(element);
        roomsList.add(room);
      });
      return roomsList;
    }else{
      throw Exception('Failed to load data!');
    }
  }

  Future<List<Vehicle>> fetchVehiclesType(String type) async {
    final response = await http.get(url + 'vehicles/' + type);
    List<Vehicle> roomsList = List<Vehicle>();
    if(response.statusCode == 200){
      jsonDecode(response.body).forEach((element){
        Vehicle room = Vehicle.fromJson(element);
        roomsList.add(room);
      });
      return roomsList;
    }else{
      throw Exception('Failed to load data!');
    }
  }

  Future<List<Vehicle>> fetchMy(String type) async {
    final response = await http.get(url + 'driver/' + type);
    List<Vehicle> roomsList = List<Vehicle>();
    if(response.statusCode == 200){
      jsonDecode(response.body).forEach((element){
        Vehicle room = Vehicle.fromJson(element);
        roomsList.add(room);
      });
      return roomsList;
    }else{
      throw Exception('Failed to load data!');
    }
  }

  Future<List<String>> fetchTypes() async {
    final response = await http.get(url + 'colors');
    List<String> roomsList = List<String>();
    if(response.statusCode == 200){
      jsonDecode(response.body).forEach((element){
        roomsList.add(element);
      });
      return roomsList;
    }else{
      throw Exception('Failed to load data!');
    }
  }

  Future<bool> deleteVehicle(int id) async {
    final response = await http.delete(url + 'vehicle/' + id.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Something went wrong!');
    }
  }

  Future<Vehicle> postVehicle(Vehicle vehicle) async {
    final response = await http.post(url + 'vehicle',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'license': vehicle.license,
          'status': vehicle.status,
          'seats': vehicle.seats,
          'driver': vehicle.driver,
          'color': vehicle.color,
          'cargo': vehicle.cargo,
        }));
    if (response.statusCode == 200) {
      return Vehicle.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Something went wrong!');
    }
  }
}