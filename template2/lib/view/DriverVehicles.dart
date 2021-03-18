import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/repository/ServerRepository.dart';
import 'package:template/server/ServerProvider.dart';
import 'package:template/model/Vehicle.dart';

import 'AddPage.dart';
class DriverVehicles extends StatefulWidget {
  String driver;
  ServerRepository repo;
  State<StatefulWidget> createState() => _DriverVehicles();
  DriverVehicles({this.repo, this.driver});
}

class _DriverVehicles extends State<DriverVehicles>{
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
        title: Text("Driver Vehicles"),
      ),
      body: futureBuilder,
    );
  }

  Future<List<Vehicle>> _getData() async {
    return await ServerProvider.server.fetchMy(widget.driver);
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
    return InkWell(
      child: Container(
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
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,
                title: Text('Vehicle Details'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Text("Id: " + id.toString()),
                        SizedBox(width: 5),
                        Text("License: " + license),
                        SizedBox(width: 5),
                        Text("Status: " + status),
                        SizedBox(width: 5),
                        Text("Status: " + status),
                        SizedBox(width: 5),
                        Text("Seats: " + seats.toString()),
                        SizedBox(width: 5),
                        Text("Driver: " + driver),
                        SizedBox(width: 5),
                        Text("Cargo: " + cargo.toString()),
                      ],
                    ),
                  ),
                ),
                actions: [
                  RaisedButton(
                      child: Text("Close"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              );
            });
      },
    );

  }

}