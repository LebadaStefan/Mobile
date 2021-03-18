import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/model/Vehicle.dart';
import 'package:template/repository/ServerRepository.dart';

class AddPage extends StatefulWidget{

  int index;
  bool action;
  ServerRepository repo;

  AddPage({this.index, this.repo, this.action});
  State<StatefulWidget> createState() => _AddPage();
}

class _AddPage extends State<AddPage>{

  TextEditingController _fieldController1 = TextEditingController();
  TextEditingController _fieldController2 = TextEditingController();
  TextEditingController _fieldController3 = TextEditingController();
  TextEditingController _fieldController4 = TextEditingController();
  TextEditingController _fieldController5 = TextEditingController();
  TextEditingController _fieldController6 = TextEditingController();
  FocusNode _productNameFocus;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Add Vehicle",style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _fieldController1..text = widget.index != null ? widget.repo.getVehicle(widget.index).license : "",
                focusNode: _productNameFocus,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  labelText: "Vehicle License",
                  labelStyle: TextStyle(color: Colors.black),focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),

                ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _fieldController2..text = widget.index != null ? widget.repo.getVehicle(widget.index).status : "",
                focusNode: _productNameFocus,
                decoration: InputDecoration(
                  labelText: "Status",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),

                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _fieldController3..text = widget.index != null ? widget.repo.getVehicle(widget.index).seats : "",
                focusNode: _productNameFocus,
                decoration: InputDecoration(
                  labelText: "Seats",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),

                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _fieldController4..text = widget.index != null ? widget.repo.getVehicle(widget.index).driver : "",
                focusNode: _productNameFocus,
                decoration: InputDecoration(
                  labelText: "Driver",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),

                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _fieldController5..text = widget.index != null ? widget.repo.getVehicle(widget.index).color : "",
                focusNode: _productNameFocus,
                decoration: InputDecoration(
                  labelText: "Color",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),

                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _fieldController6..text = widget.index != null ? widget.repo.getVehicle(widget.index).cargo : "",
                focusNode: _productNameFocus,
                decoration: InputDecoration(
                  labelText: "Cargo",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),

                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                minWidth: 100 ,
                color: Colors.grey,
                textColor: Colors.black,
                padding: EdgeInsets.all(16),
                onPressed: () {
                  Navigator.pop(context,save(repo: widget.repo,
                      action: widget.action));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Text("Save",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  goBack(BuildContext context) {
    Navigator.pop(context);
  }

  Vehicle save({ServerRepository repo, bool action, int index}) {
    Vehicle vehicle = Vehicle(
        license: _fieldController1.text,
        status: _fieldController2.text,
        seats: int.parse(_fieldController3.text),
        driver: _fieldController4.text,
        color: _fieldController5.text,
        cargo: int.parse(_fieldController6.text)
    );
    if(action == true)
      vehicle.id = widget.repo.getVehicle(widget.index).id;
    return vehicle;
  }

}