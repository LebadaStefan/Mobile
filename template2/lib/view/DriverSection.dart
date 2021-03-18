import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/repository/ServerRepository.dart';
import 'package:template/server/ServerProvider.dart';
import 'package:template/model/Vehicle.dart';
import 'package:template/view/DriverVehicles.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'AddPage.dart';
class DriverSection extends StatefulWidget {
  State<StatefulWidget> createState() => _RegistrationSection();
  ServerRepository serverRepository = ServerRepository();
}

class _RegistrationSection extends State<DriverSection>{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController logController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getLog();
  }
  getLog() async {
    final SharedPreferences prefs = await _prefs;
    String name = (prefs.getString("driver") ?? "");
    logController.text = name;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver Section"),
        centerTitle: true,
      ),
      body: Center(
        child: new Column(
          children: <Widget>[
            new Container(
                child: RaisedButton(
                    onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: Text('Login'),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          controller: logController,
                                          decoration: InputDecoration(
                                            labelText: 'New driver',
                                            icon: Icon(Icons.account_box),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  RaisedButton(
                                      child: Text("Save"),
                                      onPressed: () async {
                                        final SharedPreferences prefs = await _prefs;
                                        prefs.setString("driver", logController.text);
                                        print(prefs.getString("driver"));
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DriverVehicles(repo: widget.serverRepository, driver: logController.text)));
                                      }),
                                  RaisedButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              );
                            });
                    },
                    child: Text("Log"))),
          ],
        ),
      )
    );
  }
}
