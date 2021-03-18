import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:template/model/Driver.dart';
import 'package:template/model/Vehicle.dart';
import 'package:template/server/ServerProvider.dart';
class ServerRepository{
  List<Vehicle> roomsList;

  ServerRepository(){
    this.roomsList = List<Vehicle>();
    this.init();
  }

  void init() async{
    this.roomsList = await ServerProvider.server.fetchAll();
  }

  Vehicle getVehicle(int id){
    return this.roomsList.firstWhere((vehicle) => vehicle.id ==id);
  }

  void removeVehicle(int id) async{
    this.roomsList.removeWhere((product) => product.id == id);
    await ServerProvider.server.deleteVehicle(id);
  }

  void addVehicle(String license, String status, int seats, String driver, String color, int cargo) async{
    Vehicle vehicle = Vehicle(license: license, status: status, seats: seats, driver: driver, color: color, cargo: cargo);
    await ServerProvider.server.postVehicle(vehicle);
  }

  int size(){
    return roomsList.length;
  }

  List<Vehicle> orderedBySeats(List<Vehicle> rooms){
    for(int i=0; i<rooms.length - 1; i++){
      for(int j=i + 1; j<rooms.length; j++){
        if(rooms[i].seats < rooms[j].seats){
          Vehicle aux = rooms[i];
          rooms[i] = rooms[j];
          rooms[j] = aux;
        }
      }
    }
    List<Vehicle> top10 = new List<Vehicle>();
    for(int i = 0; i< 10; i++){
      top10.add(rooms[i]);
    }
    return top10;
  }

  bool IsDriverIn(String driver, List<Driver> ls){
    if(ls.isEmpty){
      return false;
    }
    for(int i=0;i <ls.length ;i++){
      if(ls[i].name == driver){
        return true;
      }
    }
    return false;
  }
  List<Driver> orderedByNumberOfVehicles(List<Vehicle> rooms){
    List<Driver> driverList = new List<Driver>();
    for(int i = 0; i<rooms.length; i++){
      if(!this.IsDriverIn(rooms[i].driver, driverList)){
        driverList.add(Driver(name: roomsList[i].driver, numberOFVehicles: 1));
      }
      else{
        int pos = driverList.indexWhere((element) => element.name == rooms[i].driver);
        driverList[pos].numberOFVehicles += 1;
      }
    }

    driverList.sort((b, a) => a.numberOFVehicles.compareTo(b.numberOFVehicles));

    List<Driver> top10 = new List<Driver>();
    int max= 10;
    if(max > driverList.length){
      max = driverList.length;
    }
    for(int i = 0; i< max; i++){
      top10.add(driverList[i]);
    }
    return top10;
  }

  List<Vehicle> orderedByCargo(List<Vehicle> rooms){
    for(int i=0; i<rooms.length - 1; i++){
      for(int j=i + 1; j<rooms.length; j++){
        if(rooms[i].cargo < rooms[j].cargo){
          Vehicle aux = rooms[i];
          rooms[i] = rooms[j];
          rooms[j] = aux;
        }
      }
    }
    List<Vehicle> top5 = new List<Vehicle>();
    for(int i = 0; i< 5; i++){
      top5.add(rooms[i]);
    }
    return top5;
  }
}