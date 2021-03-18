import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/repository/ServerRepository.dart';
import 'package:template/server/ServerProvider.dart';
import 'package:template/model/Vehicle.dart';
import 'package:template/view/ManagerSectionVehicles.dart';

import 'AddPage.dart';
class ManageSection extends StatefulWidget {
  State<StatefulWidget> createState() => _ManageSection();
  ServerRepository serverRepository = ServerRepository();
}

class _ManageSection extends State<ManageSection>{
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

  Future<List<String>> _getData() async {
    return await ServerProvider.server.fetchTypes();
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<String> roomsList = snapshot.data;
    return ListView.separated(
      itemCount: roomsList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
        title: Text(roomsList[index]),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ManagerSectionVehicles(repo: widget.serverRepository, type: roomsList[index],)));
        },
      );},

      separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 10.0); },
    );
  }

  Widget Item({String type}){
    return Container(
      color: Colors.grey,
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text("Type: " + type),
              SizedBox(width: 5),
            ],
          ),
        ],
      ),
    );
  }

}
