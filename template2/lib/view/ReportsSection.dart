import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/model/Driver.dart';
import 'package:template/repository/ServerRepository.dart';
import 'package:template/server/ServerProvider.dart';
import 'package:template/model/Vehicle.dart';
import 'package:template/view/ManagerSectionVehicles.dart';

import 'AddPage.dart';
class ReportsSection extends StatefulWidget {
  State<StatefulWidget> createState() => _ReportsSection();
  ServerRepository serverRepository = ServerRepository();
}

class _ReportsSection extends State<ReportsSection>{
  String currentChoice = "Order by seats";
  List<String> choices = ["Order by seats", "Order by number of vehicles", "Order by cargo"];
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
        title: Text("Reports Section"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: refresh,
              itemBuilder: (BuildContext context){
                return choices.map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]
      ),
      body: futureBuilder,
    );
  }

  void refresh(String choice){
    currentChoice = choice;
    setState(() {

    });
  }
  Future<List<Vehicle>> _getData() async {
    return await ServerProvider.server.fetchAll();
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Vehicle> roomsList = snapshot.data;
    if(currentChoice == choices[0]){
      roomsList = widget.serverRepository.orderedBySeats(roomsList);
      return ListView.separated(
        itemCount: roomsList.length,
        itemBuilder: (BuildContext context, int index) => Item(
            license: roomsList[index].license,
            status: roomsList[index].status,
            seats: roomsList[index].seats,
            driver: roomsList[index].driver),
        separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 10.0); },
      );
    }else if(currentChoice == choices[1]){
      List<Driver> driverList = widget.serverRepository.orderedByNumberOfVehicles(roomsList);
      return ListView.separated(
        itemCount: driverList.length,
        itemBuilder: (BuildContext context, int index) => Item1(
            driver: driverList[index].name,
            numberOfVehicles: driverList[index].numberOFVehicles),
        separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 10.0); },
      );
    }else if(currentChoice == choices[2]){
      roomsList = widget.serverRepository.orderedByCargo(roomsList);
      return ListView.separated(
        itemCount: roomsList.length,
        itemBuilder: (BuildContext context, int index) => Item2(
            license: roomsList[index].license,
            capacity: roomsList[index].cargo),
        separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 10.0); },
      );
    }
  }

  Widget Item({String license, String status, int seats, String driver}){
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
        ],
      ),
    );
  }

  Widget Item1({String driver, int numberOfVehicles}){
    return Container(
      color: Colors.grey,
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text("Driver: " + driver),
              SizedBox(width: 5),
              Text("Number of vehicles: " + numberOfVehicles.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget Item2({String license, int capacity}){
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
              Text("Capacity: " + capacity.toString()),
            ],
          ),
        ],
      ),
    );
  }

}
