import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/database/DatabaseProvider.dart';
import 'package:template/repository/DbRepository.dart';
import 'package:template/repository/ServerRepository.dart';
import 'package:template/server/ServerProvider.dart';
import 'package:template/model/Vehicle.dart';

import 'AddPage.dart';
class RegistrationSection extends StatefulWidget {
  State<StatefulWidget> createState() => _RegistrationSection();
  ServerRepository serverRepository = ServerRepository();
  DbRepository databaseRepository = DbRepository();
}

class _RegistrationSection extends State<RegistrationSection>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              if(snapshot.hasError)
                return new Text('Error :${snapshot.error}');
              else
                return Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                    createListView(context, snapshot)
                  ],
                );
          }
        }
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Registration Section"),
      ),
      body: futureBuilder,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            CupertinoPageRoute<Vehicle>(
              fullscreenDialog: false,
              builder: (BuildContext context) => AddPage(repo: widget.serverRepository, action: false),
            ),
          );
          if(result != null){
              Vehicle vehicle = result;
              var connectivityResult = await (Connectivity().checkConnectivity());
              if (connectivityResult == ConnectivityResult.wifi) {
                widget.serverRepository.addVehicle(
                    vehicle.license, vehicle.status, vehicle.seats, vehicle.driver,
                    vehicle.color, vehicle.cargo);
              }else {
                widget.databaseRepository.addProductOffline(
                    vehicle.license, vehicle.status, vehicle.seats, vehicle.driver,
                    vehicle.color, vehicle.cargo);

                widget.databaseRepository.addProduct(
                    vehicle.license, vehicle.status, vehicle.seats, vehicle.driver,
                    vehicle.color, vehicle.cargo);
              }
            setState(() {
            });
          }
        },
        child: Icon(Icons.add_box_outlined),
        backgroundColor: Colors.black54,
      ),
    );
  }

  Future<List<Vehicle>> _getData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi){
      List<Vehicle> offline = await DatabaseProvider.dbOffline.getVehicle();
      if(offline.isNotEmpty){
        for(Vehicle vehicle in offline){
          widget.serverRepository.addVehicle(vehicle.license, vehicle.status, vehicle.seats, vehicle.driver, vehicle.color, vehicle.cargo);
        }
        DatabaseProvider.dbOffline.deleteAllOffline();
      }
      List<Vehicle> rep = await ServerProvider.server.fetchAll();
      widget.databaseRepository.repopulate(rep);
      return rep;
    }
    return await DatabaseProvider.db.getVehicle();
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Vehicle> roomsList = snapshot.data;
    return ListView.separated(
      itemCount: roomsList.length,
      itemBuilder: (BuildContext context, int index) =>
          Item(
              id: roomsList[index].id,
              license: roomsList[index].license,
              status: roomsList[index].status,
              seats: roomsList[index].seats,
              driver: roomsList[index].driver,
              color: roomsList[index].color,
              cargo: roomsList[index].cargo),
      separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 10.0); },
    );
  }

  Widget Item({int id, String license, String status, int seats, String driver, String color, int cargo}){
    return Container(
      color: Colors.grey,
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text("License: " + license),
                SizedBox(width: 5),
                Text("Status: " + status),
              ],
            ),
            Row(
              children: [
                Text("Seats: " + seats.toString()),
                SizedBox(width: 5),
                Text("Driver: " + driver),
              ],
            ),
            Row(
              children: [
                Text("Color: " + color),
                SizedBox(width: 5),
                Text("Cargo: " + cargo.toString()),
              ],
            ),
            Row(
              children: [
                TextButton(
                  child: Text("Edit", style: new TextStyle(
                      fontSize: 20
                  ),),
                  onPressed: () async {
                  },
                ),
                TextButton(
                  child: Text("Delete", style: new TextStyle(
                      fontSize: 20
                  ),),
                  onPressed: () {
                  },
                )
              ],
            )
          ],
        ),
    );
  }

}