import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/repository/ServerRepository.dart';
import 'package:template/server/ServerProvider.dart';
import 'package:template/model/Vehicle.dart';

import 'AddPage.dart';
class ManagerSectionVehicles extends StatefulWidget {
  String type;
  ServerRepository repo;
  State<StatefulWidget> createState() => _ManagerSectionVehicles();
  ManagerSectionVehicles({this.repo, this.type});
}

class _ManagerSectionVehicles extends State<ManagerSectionVehicles>{
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
        title: Text("Manager Section"),
      ),
      body: futureBuilder,
    );
  }

  Future<List<Vehicle>> _getData() async {
    return await ServerProvider.server.fetchVehiclesType(widget.type);
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
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Are you sure you want to delete $license"),
                          actions: [
                            FlatButton(
                              child: Text("Confirm"),
                              onPressed: () {
                                setState(() {
                                  widget.repo.removeVehicle(id);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      }
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }

}
