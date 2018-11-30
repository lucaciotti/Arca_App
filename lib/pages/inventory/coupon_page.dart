import 'dart:async';
import 'package:arca_flutter_app/models/coupon.dart';
import 'package:tuple/tuple.dart';
import 'package:arca_flutter_app/confRoutes/application.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:arca_flutter_app/helpers/barcodeScan.dart';

import 'package:arca_flutter_app/controllers/inventController.dart';
import 'package:arca_flutter_app/controllers/maganaController.dart';
import 'package:arca_flutter_app/controllers/articleController.dart';

class CouponPage extends StatefulWidget {

  @override
  CouponPageState createState() => new CouponPageState();
}

class CouponPageState extends State<CouponPage> {
  // final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  InventController _invController = new InventController();
  MaganaController _magController = new MaganaController();
  ArticleController _artController = new ArticleController();

  BarcodeScan _barcodeScan = new BarcodeScan();

  int currentStep = 0;
  int totalStep = 0;
  String couponCode = "";
  String codArt = "";
  String codLot = "";
  bool isLotto = false;
  List<Tuple2<String, double>> umList = [new Tuple2('', 0.0)];
  String codmag = "";
  String esercizio = "";
  num couponNum = 0;
  double qta = 0.0;  
  double qtaDef = 0.0;  
  String umPrincipale='';
  String umChoosen='';
  double fattChoosen=0.0;
  bool isWarn = false;
  bool isReadOnly = false;
  
  void _showDialog<T>(title, content, [route]) {
    // flutter defined function
    showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then<void>((T value) {
      if (route != null) {
        Application.router.navigateTo(context, route, transition: TransitionType.inFromBottom, replace: true);
      }
    });
  }


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
              keyboardType: TextInputType.text,
              controller:  new TextEditingController.fromValue(new TextEditingValue(text: codLot,selection: new TextSelection.collapsed(offset: codLot.length))),//new TextEditingController(text: this.couponCode),
              onChanged: (String value) => this.codLot = value,
            ) : new Padding( padding: EdgeInsets.all(0.0),) ,
          ]),
          state:  currentStep > 1 ? StepState.complete : StepState.disabled,
          isActive: currentStep >= 1),
      new Step(
          title: new Text("Qta & UM"),
          subtitle: new Text("Quantity & UnMisura"),
          content: new Column(
            children: <Widget>[
              new DropdownButton(
                  hint: new Text("Select a UM"),
                  value: umChoosen,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      umChoosen = newValue;
                      umList.forEach((item){
                        if(item.item1==newValue) fattChoosen=item.item2;
                      });
                    });
                  },
                  items: umList.map((item) {
                      return new DropdownMenuItem(
                        value: item.item1,
                        child: new Text(
                          item.item1,
                          style: new TextStyle(color: Colors.black),
                        ),
                      );
                  }).toList(),
                ),
              new TextField(
                decoration: const InputDecoration(
                  icon: const Icon(FontAwesomeIcons.calculator),
                  hintText: 'Enter quantities',
                  labelText: 'Quantity',
                ),
                // autofocus: true,
                keyboardType: TextInputType.number,
                controller:  new TextEditingController.fromValue(new TextEditingValue(text: this.qta.toString(),selection: new TextSelection.collapsed(offset: this.qta.toString().length))),
                onChanged: (value) => this.qta = double.parse(value),
                textAlign: TextAlign.right,
              ),
            ]
          ),
          state:  currentStep > 2 ? StepState.complete : StepState.disabled,
          isActive: currentStep >= 2),
      new Step(
          title: new Text("Recap"),
          subtitle: new Text("Final"),
          content: new Column( children: <Widget>[
            (this.isWarn) ? Row( children: <Widget>[ Icon(Icons.delete), Text('ATENNZIONE! Cartellino Segnalato Errato!', style: TextStyle(fontWeight: FontWeight.bold)) ],) : new Padding( padding: EdgeInsets.all(0.0),),
            new Table(
              border: TableBorder.all(width: 1.0, color: Colors.black),
                children: [
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('# Cartellino'),
                          new Text(this.couponNum.toString()),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Esercizio'),
                          new Text(this.esercizio),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Magazzino'),
                          new Text(this.codmag),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Cod. Articolo'),
                          new Text(this.codArt, style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Cod. Lotto'),
                          new Text(this.codLot, style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Quantità'),
                          (this.umChoosen!=this.umPrincipale) ?
                            new Text(this.qta.toString()+' '+this.umChoosen+' => '+this.qtaDef.toString()+' '+this.umPrincipale, style: TextStyle(fontWeight: FontWeight.bold)) : 
                            new Text(this.qta.toString()+' '+this.umChoosen, style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ])
                ],
              ),
            new Padding( padding: EdgeInsets.all(5.0),),
            (this.isReadOnly && !this.isWarn) ? new FlatButton(
                color: Colors.red[300],
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.delete), new Text('Segnala Cartellino Errato', style: TextStyle(fontWeight: FontWeight.bold),),],),
                onPressed: () { 
                  Future<dynamic> res = _invController.markCoupon(this.couponCode);
                  this.currentStep = 0;
                  this.goFutherStep();
                },
              ) : new Padding( padding: EdgeInsets.all(0.0),),
            (this.isReadOnly) ? new FlatButton(
                color: Colors.green[300],
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(FontAwesomeIcons.plus), new Text('Nuovo Cartellino', style: TextStyle(fontWeight: FontWeight.bold),),],),
                onPressed: () { 
                  Application.router.navigateTo(context, '/invCoupon', transition: TransitionType.inFromRight, replace: true);
                },
              ) : new Padding( padding: EdgeInsets.all(0.0),),
          ]),
          state:  currentStep > 3 ? StepState.complete : StepState.disabled,
          isActive: currentStep >= 3),
    ];
    this.totalStep = invSteps.length;

    Widget body = new Container(
          child: new Stepper(
            currentStep: this.currentStep,
            steps: invSteps,
            type: StepperType.vertical,
            onStepTapped: (step) {
              /* setState(() {
                currentStep = step;
              }); */
              print("onStepTapped : " + step.toString());
            },
            onStepCancel: () {
              if(!this.isReadOnly){
                setState(() {
                  if (currentStep > 0) {
                    currentStep = currentStep - 1;
                  } else {
                    currentStep = 0;
                  }
                });
              }
              print("onStepCancel : " + currentStep.toString());
            },
            onStepContinue: () {
              goFutherStep(forceGoOn: true);
              print("onStepContinue : " + currentStep.toString());
            },
          )
        );

    return new Scaffold(
      // Appbar
      appBar: new AppBar(
        // Title
        title: new Text("Procedura INVENTARIO"),
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
                  Application.router.navigateTo(context, '/home', transition: TransitionType.inFromRight, replace: true, clearStack: true);
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
    if(currentStep>1) {
      this._showDialog('Info', 'Nothing to Scan For...');
    } else {
      String res = await this._barcodeScan.scan();
      if (res.startsWith('error:')) {
        this._showDialog('Scan Error', res.substring(6));
      } else {
        setState(() {
          switch(this.currentStep) { 
            case 0: { 
              //Barcode Coupon  
              if(res.substring(0,2)=='24'){
                this.couponCode = res;
              } else {
                _showDialog('Error', 'Barcode Errato');
              }
            } 
            break; 
            
            case 1: { 
              //Barcode Art.
              if(isLotto) {
                this.codLot = res;
              } else {
                this.codArt = res;
              }
            } 
            break; 
          }
        });
        goFutherStep();
      }
    }
  }

  Future goFutherStep({bool forceGoOn=false}) async {
    bool goOn = false;
    switch(this.currentStep) { 
      case 0: { 
        if(this.couponCode.isNotEmpty){
          dynamic couponFetch = await _invController.fetchCoupon(this.couponCode);
          if (couponFetch==null || couponFetch.isEmpty) {
            String rMag = this.couponCode.substring(4,4+3);
            dynamic magFetch = await _magController.fetchRightMag(rMag);
            if (magFetch!=null && !magFetch.isEmpty) {
              this.codmag = magFetch[0].codice;
              this.esercizio = '20'+this.couponCode.substring(2,2+2);
              this.couponNum = int.parse(this.couponCode.substring(7,7+5));            
              // this._showDialog('Result', this.codmag+' '+this.esercizio+' '+this.couponNum.toString());
            }
          } else {
            Coupon readOnly = couponFetch[0];
            dynamic artResult = await _artController.fetchArticle(readOnly.codicearti);
            setState(() {
              this.codArt = readOnly.codicearti;
              this.codmag = readOnly.magazzino;
              this.codLot = readOnly.lotto;
              this.couponNum = int.parse(this.couponCode.substring(7,7+5));
              this.esercizio = readOnly.esercizio;
              this.qta = readOnly.quantita;
              this.umChoosen=artResult[0].unmisura;
              this.umPrincipale = artResult[0].unmisura;
              this.fattChoosen = 1.0;
              this.umList.clear();
              this.umList.add(new Tuple2('', 0.0));
              this.umList.add(new Tuple2(artResult[0].unmisura, 1.0));
              this.umList.add(new Tuple2(artResult[0].unmisura2, artResult[0].fatt2));
              this.umList.add(new Tuple2(artResult[0].unmisura3, artResult[0].fatt3));
              this.isLotto = artResult[0].isLotto;
              this.isWarn = readOnly.isWart;
              this.isReadOnly = true;
            });
          }
          goOn = true;
        }
      } 
      break; 
      
      case 1: { 
        if(this.isLotto && this.codLot.isNotEmpty && forceGoOn) goOn=true;
        if(!goOn){
          String res = await this._artController.searchScan(this.codArt);
          if (res == "error"){
            _showDialog("Empty Result", "No Article Found!");
          } else {
            dynamic artResult = await _artController.fetchArticle(res);
            setState(() {
              this.codArt = artResult[0].codice;
              this.umPrincipale = artResult[0].unmisura;
              this.umChoosen = artResult[0].unmisura;
              this.fattChoosen = 1.0;
              this.umList.clear();
              this.umList.add(new Tuple2('', 0.0));
              this.umList.add(new Tuple2(artResult[0].unmisura, 1.0));
              this.umList.add(new Tuple2(artResult[0].unmisura2, artResult[0].fatt2));
              this.umList.add(new Tuple2(artResult[0].unmisura3, artResult[0].fatt3));
              this.isLotto = artResult[0].isLotto;
              // this._showDialog('Result', this.umPrincipale+' '+this.fattChoosen.toString()+' '+this.isLotto.toString());
            });
            if(!this.isLotto) goOn = true;
          }
        }
      } 
      break; 

      case 2: { 
        if(this.fattChoosen<=0) return _showDialog('Attenzione', 'Selezionare Altra U.M. -> Errata.');
        if(this.qta<=0) return _showDialog('Attenzione', 'Quantità deve essere > di 0.');
        this.qtaDef = this.qta*this.fattChoosen;
        if(this.umChoosen.isNotEmpty && this.qta>0 ) goOn=true;
      } 
      break; 

      case 3: {
        if(!this.isReadOnly){ 
          Coupon coupon = new Coupon(this.couponCode, this.codArt, this.codmag, this.qtaDef, this.codLot, this.esercizio);
          List<Coupon> resCoupon = await _invController.insertCoupon(coupon);
          if(resCoupon.isNotEmpty) {
            _showDialog('OK', 'Cartellino Caricato', '/invCoupon');
            goOn=true;
          } else {
            _showDialog('Attenzione', 'Something Wrong');
          }
        } else {
          goOn = true;
        }
      } 
      break; 
    }

    // STEP +1
    if(goOn){
      setState(() {
        if (currentStep < this.totalStep - 1) {
          currentStep = currentStep + 1;
        } else {
          //Application.router.navigateTo(context, '/invCoupon', transition: TransitionType.inFromRight, replace: true);
          currentStep = 0;
        }
        if(this.isReadOnly) currentStep = 3;
      });
    }
  }
  
}