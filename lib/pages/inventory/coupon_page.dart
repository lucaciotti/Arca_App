import 'dart:async';
import 'package:tuple/tuple.dart';
import 'package:arca_flutter_app/confRoutes/application.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:arca_flutter_app/helpers/barcodeScan.dart';

class CouponPage extends StatefulWidget {

  @override
  CouponPageState createState() => new CouponPageState();
}

class CouponPageState extends State<CouponPage> {
  // final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  
  BarcodeScan _barcodeScan = new BarcodeScan();
  int currentStep = 0;
  String couponCode = "";
  String codArt = "";
  String codLot = "";
  bool isLotto = true;
  List<String> umList = <String>['', 'PZ','CF','SC'];
  String codmag = "";
  String esercizio = "";
  double qta = 0.0;  
  String umChoosen='';
  double fatt=0.0;
  int selectedUM=0;
  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
  String _color = '';
  
  @override
  Widget build(BuildContext context) {

    List<Step> invSteps = [
      new Step(
          title: new Text("Cod. Coupon"),
          subtitle: new Text("Inserire Codice Cartellino"),
          content: new TextField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.code),
                        hintText: 'Enter the Code',
                        labelText: 'Codice',
                      ),
                      controller:  new TextEditingController.fromValue(new TextEditingValue(text: couponCode,selection: new TextSelection.collapsed(offset: couponCode.length))),//new TextEditingController(text: this.couponCode),
                      onChanged: (String value) => this.couponCode = value,
                    ),
          state:  currentStep >= 0 ? StepState.complete : StepState.disabled,
          isActive: currentStep >= 0),
      new Step(
          title: new Text("Cod. Articolo"),
          subtitle: new Text("Inserire Codice Articolo"),
          content: new Column( children: <Widget>[
            new TextField(
              decoration: const InputDecoration(
                icon: const Icon(FontAwesomeIcons.box),
                hintText: 'Enter the Code',
                labelText: 'Codice Articolo',
              ),
              controller:  new TextEditingController.fromValue(new TextEditingValue(text: codArt,selection: new TextSelection.collapsed(offset: codArt.length))),//new TextEditingController(text: this.couponCode),
              onChanged: (String value) => this.codArt = value,
            ),
            this.isLotto ? new TextField(
              decoration: const InputDecoration(
                icon: const Icon(FontAwesomeIcons.idBadge),
                hintText: 'Enter the Lot',
                labelText: 'Cod.Lotto',
              ),
              controller:  new TextEditingController.fromValue(new TextEditingValue(text: codLot,selection: new TextSelection.collapsed(offset: codLot.length))),//new TextEditingController(text: this.couponCode),
              onChanged: (String value) => this.codLot = value,
            ) : new Padding( padding: EdgeInsets.all(0.0),) ,
          ]),
          state:  currentStep > 1 ? StepState.complete : StepState.disabled,
          isActive: currentStep >= 1),
      new Step(
          title: new Text("Qta & UM"),
          subtitle: new Text("Quantity & UnMisura"),
          content: new Row( children: <Widget>[
            new DropdownButton(
                hint: new Text("Select a UM"),
                value: umChoosen,
                isDense: true,
                onChanged: (newValue) {
                  setState(() {
                    // unmisura = newValue;
                  });
                },
                items: umList.map((item) {
                    return new DropdownMenuItem(
                      value: item,
                      child: new Text(
                        item,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                }).toList(),
              ),
            new TextField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Enter quantities',
                labelText: 'Quantity',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
            )
          ]),
          state:  currentStep > 2 ? StepState.complete : StepState.disabled,
          isActive: currentStep >= 2),
    ];

    Widget body = new Container(
          child: new Stepper(
            currentStep: this.currentStep,
            steps: invSteps,
            type: StepperType.vertical,
            onStepTapped: (step) {
              setState(() {
                currentStep = step;
              });
              print("onStepTapped : " + step.toString());
            },
            onStepCancel: () {
              setState(() {
                if (currentStep > 0) {
                  currentStep = currentStep - 1;
                } else {
                  currentStep = 0;
                }
              });
              print("onStepCancel : " + currentStep.toString());
            },
            onStepContinue: () {
              setState(() {
                if (currentStep < invSteps.length - 1) {
                  currentStep = currentStep + 1;
                } else {
                  currentStep = 0;
                }
              });
              print("onStepContinue : " + currentStep.toString());
            },
          )
        );

    return new Scaffold(
      // Appbar
      appBar: new AppBar(
        // Title
        title: new Text("Simple Material App"),
      ),
      // Body
      body: body,
      bottomNavigationBar: new BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                // color: Colors.white,
                onPressed: () {
                  Application.router.navigateTo(context, '/home', transition: TransitionType.inFromRight, replace: true);
                  //  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
            ],
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: const Icon(FontAwesomeIcons.barcode),
          onPressed: () {
            this.barcodeScanning();
          },
        ),
    );
  }

  Future barcodeScanning() async {
    String res = await this._barcodeScan.scan();
    if (res.startsWith('error:')) {
      // this._showDialog('Scan Error', res.substring(6));
    } else {
      setState(() {
        switch(this.currentStep) { 
          case 0: { 
            //Barcode Coupon  
            this.couponCode = res;
          } 
          break; 
          
          case 1: { 
            //Barcode Art.
            this.codArt = res;
          } 
          break; 

          case 2: { 
              //statements; 
          } 
          break; 
        }
        // this.barcodeSeach(res);
      });
    }
  }

  
}