import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:template/view/ManageSection.dart';
import 'package:template/view/DriverSection.dart';
import 'package:template/view/RegistrationSection.dart';
import 'package:template/view/ReportsSection.dart';

void main() => runApp(MaterialApp(
  title: "Cab App",
  home: MyApp(),
));

class MyApp extends StatefulWidget{
  State<StatefulWidget> createState() => _MyApp();
}
class _MyApp extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text("Registration Section"),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationSection()));
              },
            ),
            ElevatedButton(
              child: Text("Manage Section"),
              onPressed: () async {
                setState(() {

                });
                var connectivityResult = await (Connectivity().checkConnectivity());
                if (connectivityResult == ConnectivityResult.wifi){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ManageSection()));
                }else{
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Check internet connection')));
                }
                },
            ),
            ElevatedButton(
              child: Text("Reports Section"),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsSection()));
              },
            ),
            ElevatedButton(
              child: Text("Driver Section"),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => DriverSection()));
              },
            ),
          ],
        ),
      ),
    );
  }
}