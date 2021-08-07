import 'dart:math';

import 'package:firebase_config/customDialogBox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import "package:cloud_firestore/cloud_firestore.dart";

final Product_VirtualSize_Matches = FirebaseFirestore.instance.collection("Product_VirtualSize_Matches");
final ProductsRef = FirebaseFirestore.instance.collection("Products");
final VirtualSizesRef = FirebaseFirestore.instance.collection("VirtualSizes");


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}


class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("ERROR"),
              ),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Home();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Scaffold(
            body: Center(
              child: Text("LOADING..."),
            ),
          );
        },
      ),
    );
  }
}

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<String>> getVirtualSize_Biceps(double bicepsValue, String matchName)async{
    List<String>  correspondingDocs = [];
    QuerySnapshot snapshot = await VirtualSizesRef.doc("Tshirt").collection("Biceps").get();


    for(DocumentSnapshot doc in snapshot.docs){
      if(doc.get(matchName)[0] <= bicepsValue && doc.get(matchName)[1] >= bicepsValue ){
        //this is the document that matches matchName interval.
        correspondingDocs.add(doc.id);
      }
    }
    return correspondingDocs;
  }

  Future<List<String>> getVirtualSize_Chest(double chestValue, String matchName)async{

    List<String>  correspondingDocs = [];
    QuerySnapshot snapshot = await VirtualSizesRef.doc("Tshirt").collection("Chest").get();


    for(DocumentSnapshot doc in snapshot.docs){
      if(doc.get(matchName)[0] <= chestValue && doc.get(matchName)[1] >= chestValue ){
        correspondingDocs.add(doc.id);

      }
    }
    return correspondingDocs;
  }

  Future<List<String>> getVirtualSize_Shoulder(double shoulderValue, String matchName)async{

    List<String>  correspondingDocs = [];
    QuerySnapshot snapshot = await VirtualSizesRef.doc("Tshirt").collection("Shoulder").get();


    for(DocumentSnapshot doc in snapshot.docs){
      if(doc.get(matchName)[0] <= shoulderValue && doc.get(matchName)[1] >= shoulderValue ){
        correspondingDocs.add(doc.id);

      }
    }
    return correspondingDocs;
  }

  Future<List<String>> getVirtualSize_Length(double lengthValue, String matchName)async{

    List<String>  correspondingDocs = [];
    QuerySnapshot snapshot = await VirtualSizesRef.doc("Tshirt").collection("Length").get();


    for(DocumentSnapshot doc in snapshot.docs){
      if(doc.get(matchName)[0] <= lengthValue && doc.get(matchName)[1] >= lengthValue ){
        correspondingDocs.add(doc.id);

      }
    }
    return correspondingDocs;
  }

  Future<List<String>> getVirtualSize_Neck(double neckValue, String matchName)async{    ///NECK NM HAS DIFFERENT RULES

    List<String>  correspondingDocs = [];
    QuerySnapshot snapshot = await VirtualSizesRef.doc("Tshirt").collection("Neck").get();

    for(DocumentSnapshot doc in snapshot.docs){
      if(doc.get(matchName)[0] <= neckValue && doc.get(matchName)[1] >= neckValue ){
        correspondingDocs.add(doc.id);

      }
    }
    return correspondingDocs;
  }

  Future<List<String>> getVirtualSize_Waist(double waistValue, String matchName)async{

    List<String>  correspondingDocs = [];
    QuerySnapshot snapshot = await VirtualSizesRef.doc("Tshirt").collection("Waist").get();


    for(DocumentSnapshot doc in snapshot.docs){
      if(doc.get(matchName)[0] <= waistValue && doc.get(matchName)[1] >= waistValue ){
        correspondingDocs.add(doc.id);

      }
    }
    return correspondingDocs;
  }

  Future<void> snapshotReferenceUpdate({List<String> Variable_VirtualSize_MatchNameList, String CollectionName, String VirtualSize_IntervalName, String tshirtID}) async {
    //
    for(String matchName in Variable_VirtualSize_MatchNameList){
      if(matchName != null){
        // final bicepsSnapshot = await Product_VirtualSize_Matches.doc("Tshirt").collection(CollectionName).doc(matchName).get();
        // await bicepsSnapshot.reference.update({VirtualSize_IntervalName: FieldValue.arrayUnion([tshirtID])});
      }
      else{
        print("----------------------------------------------------------  " + tshirtID +  " " + CollectionName + " NULL!");
      }
    }
  }

  Future<void> MATCH_TSHIRT(DocumentSnapshot tshirtDoc)async {
    int flex = tshirtDoc.get("flex");
    Map<String, dynamic> measureData = tshirtDoc.get("measureData");
    String tshirtID = tshirtDoc.id;

    double biceps = double.parse(measureData["arm"])*2;
    double chest = double.parse(measureData["chest"]);
    double shoulder = double.parse(measureData["shoulder"]);
    double length = double.parse(measureData["length"]);

    double neck_x = double.parse(measureData["neck_x"]);
    double neck_y = double.parse(measureData["neck_y"]);

    double neck = (neck_x+neck_y)*pi/2;
    double waist = double.parse(measureData["waist"]);
    double sleeve = double.parse(measureData["sleeve"]);

    if(flex==2){
      length += 1;
      chest+= 3;
      waist += 3;
      biceps+= 1;
    }
    else if(flex == 3){
      length += 1.5;
      chest+= 5;
      waist += 5;
      biceps+= 2;
    }

    //VALUES
    print( biceps);
    print( chest);
    print( shoulder);
    print( length);
    print( neck);
    print( waist);
    print( sleeve);




    List<String> Biceps_VirtualSize_FM = await getVirtualSize_Biceps(biceps,"FM") ;
    print("Biceps_VirtualSize_FM:  " + Biceps_VirtualSize_FM.toString());
    List<String> Biceps_VirtualSize_PM = await getVirtualSize_Biceps(biceps,"PM") ;
    print("Biceps_VirtualSize_PM:  " + Biceps_VirtualSize_PM.toString());
    List<String> Biceps_VirtualSize_LM = await getVirtualSize_Biceps(biceps,"LM") ;
    print("Biceps_VirtualSize_LM:  " + Biceps_VirtualSize_LM.toString());
    List<String> Biceps_VirtualSize_XLM = await getVirtualSize_Biceps(biceps,"XLM") ;
    print("Biceps_VirtualSize_XLM:  " + Biceps_VirtualSize_XLM.toString());

    List<String> Chest_VirtualSize_FM = await getVirtualSize_Chest(chest,"FM") ;
    print("Chest_VirtualSize_FM:  " + Chest_VirtualSize_FM.toString());
    List<String> Chest_VirtualSize_PM = await getVirtualSize_Chest(chest,"PM") ;
    print("Chest_VirtualSize_PM:  " + Chest_VirtualSize_PM.toString());
    List<String> Chest_VirtualSize_LM = await getVirtualSize_Chest(chest,"LM") ;
    print("Chest_VirtualSize_LM:  " + Chest_VirtualSize_LM.toString());
    List<String> Chest_VirtualSize_XLM = await getVirtualSize_Chest(chest,"XLM") ;
    print("Chest_VirtualSize_XLM:  " + Chest_VirtualSize_XLM.toString());

    List<String> Length_VirtualSize_AH = await getVirtualSize_Length(length,"AH") ;
    print("Length_VirtualSize_AH:  " + Length_VirtualSize_AH.toString());
    List<String> Length_VirtualSize_H = await getVirtualSize_Length(length,"H") ;
    print("Length_VirtualSize_H:  " + Length_VirtualSize_H.toString());
    List<String> Length_VirtualSize_PM = await getVirtualSize_Length(length,"PM") ;
    print("Length_VirtualSize_PM:  " + Length_VirtualSize_PM.toString());
    List<String> Length_VirtualSize_LM = await getVirtualSize_Length(length,"LM") ;
    print("Length_VirtualSize_LM:  " + Length_VirtualSize_LM.toString());
    List<String> Length_VirtualSize_XLM = await getVirtualSize_Length(length,"XLM") ;
    print("Length_VirtualSize_XLM:  " + Length_VirtualSize_XLM.toString());


    List<String> Shoulder_VirtualSize_XUM = await getVirtualSize_Shoulder(shoulder,"XUM");
    print("Shoulder_VirtualSize_XUM:  " + Shoulder_VirtualSize_XUM.toString());
    List<String> Shoulder_VirtualSize_UM = await getVirtualSize_Shoulder(shoulder,"UM");
    print("Shoulder_VirtualSize_UM:  " + Shoulder_VirtualSize_UM.toString());
    List<String> Shoulder_VirtualSize_PM = await getVirtualSize_Shoulder(shoulder,"PM");
    print("Shoulder_VirtualSize_PM:  " + Shoulder_VirtualSize_PM.toString());
    List<String> Shoulder_VirtualSize_LM = await getVirtualSize_Shoulder(shoulder,"LM");
    print("Shoulder_VirtualSize_LM:  " + Shoulder_VirtualSize_LM.toString());
    List<String> Shoulder_VirtualSize_XLM = await getVirtualSize_Shoulder(shoulder,"XLM");
    print("Shoulder_VirtualSize_XLM:  " + Shoulder_VirtualSize_XLM.toString());


    List<String> Waist_VirtualSize_FM = await getVirtualSize_Waist(waist,"FM") ;
    print("Waist_VirtualSize_FM:  " + Waist_VirtualSize_FM.toString());
    List<String> Waist_VirtualSize_PM = await getVirtualSize_Waist(waist,"PM") ;
    print("Waist_VirtualSize_PM:  " + Waist_VirtualSize_PM.toString());
    List<String> Waist_VirtualSize_LM = await getVirtualSize_Waist(waist,"LM") ;
    print("Waist_VirtualSize_LM:  " + Waist_VirtualSize_LM.toString());
    List<String> Waist_VirtualSize_XLM = await getVirtualSize_Waist(waist,"XLM") ;
    print("Waist_VirtualSize_XLM:  " + Waist_VirtualSize_XLM.toString());


    List<String> Neck_VirtualSize_FM = await getVirtualSize_Neck(neck,"FM") ;
    print("Neck_VirtualSize_FM:  " + Neck_VirtualSize_FM.toString());
    List<String> Neck_VirtualSize_PM = await getVirtualSize_Neck(neck,"PM") ;
    print("Neck_VirtualSize_PM:  " + Neck_VirtualSize_PM.toString());
    List<String> Neck_VirtualSize_LM = await getVirtualSize_Neck(neck,"LM") ;
    print("Neck_VirtualSize_LM:  " + Neck_VirtualSize_LM.toString());
    List<String> Neck_VirtualSize_XLM = await getVirtualSize_Neck(neck,"XLM") ;
    print("Neck_VirtualSize_XLM:  " + Neck_VirtualSize_XLM.toString());
    List<String> Neck_VirtualSize_NM = await getVirtualSize_Neck(neck,"NM") ;
    print("Neck_VirtualSize_NM:  " + Neck_VirtualSize_NM.toString());
    //************************************************************************** BICEPS **************************************************************************
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Biceps_VirtualSize_FM,
      CollectionName:                 "Biceps",
      VirtualSize_IntervalName:       "FM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Biceps_VirtualSize_PM,
      CollectionName:                 "Biceps",
      VirtualSize_IntervalName:       "PM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Biceps_VirtualSize_LM,
      CollectionName:                 "Biceps",
      VirtualSize_IntervalName:       "LM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Biceps_VirtualSize_XLM,
      CollectionName:                 "Biceps",
      VirtualSize_IntervalName:       "XLM",
      tshirtID:                       tshirtID,
    );



    //************************************************************************** CHEST **************************************************************************
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Chest_VirtualSize_FM,
      CollectionName:                 "Chest",
      VirtualSize_IntervalName:       "FM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Chest_VirtualSize_PM,
      CollectionName:                 "Chest",
      VirtualSize_IntervalName:       "PM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Chest_VirtualSize_LM,
      CollectionName:                 "Chest",
      VirtualSize_IntervalName:       "LM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Chest_VirtualSize_XLM,
      CollectionName:                 "Chest",
      VirtualSize_IntervalName:       "XLM",
      tshirtID:                       tshirtID,
    );



    //************************************************************************** LENGTH **************************************************************************
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Length_VirtualSize_AH,
      CollectionName:                 "Length",
      VirtualSize_IntervalName:       "AH",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Length_VirtualSize_H,
      CollectionName:                 "Length",
      VirtualSize_IntervalName:       "H",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Length_VirtualSize_PM,
      CollectionName:                 "Length",
      VirtualSize_IntervalName:       "PM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Length_VirtualSize_LM,
      CollectionName:                 "Length",
      VirtualSize_IntervalName:       "LM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Length_VirtualSize_XLM,
      CollectionName:                 "Length",
      VirtualSize_IntervalName:       "XLM",
      tshirtID:                       tshirtID,
    );



    //************************************************************************** SHOULDER **************************************************************************
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Shoulder_VirtualSize_XUM,
      CollectionName:                 "Shoulder",
      VirtualSize_IntervalName:       "XUM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Shoulder_VirtualSize_UM,
      CollectionName:                 "Shoulder",
      VirtualSize_IntervalName:       "UM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Shoulder_VirtualSize_PM,
      CollectionName:                 "Shoulder",
      VirtualSize_IntervalName:       "PM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Shoulder_VirtualSize_LM,
      CollectionName:                 "Shoulder",
      VirtualSize_IntervalName:       "LM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Shoulder_VirtualSize_XLM,
      CollectionName:                 "Shoulder",
      VirtualSize_IntervalName:       "XLM",
      tshirtID:                       tshirtID,
    );



    //************************************************************************** WAIST **************************************************************************
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Waist_VirtualSize_FM,
      CollectionName:                 "Waist",
      VirtualSize_IntervalName:       "FM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Waist_VirtualSize_PM,
      CollectionName:                 "Waist",
      VirtualSize_IntervalName:       "PM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Waist_VirtualSize_LM,
      CollectionName:                 "Waist",
      VirtualSize_IntervalName:       "LM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Waist_VirtualSize_XLM,
      CollectionName:                 "Waist",
      VirtualSize_IntervalName:       "XLM",
      tshirtID:                       tshirtID,
    );


    //************************************************************************** NECK **************************************************************************
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Neck_VirtualSize_FM,
      CollectionName:                 "Neck",
      VirtualSize_IntervalName:       "FM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Neck_VirtualSize_PM,
      CollectionName:                 "Neck",
      VirtualSize_IntervalName:       "PM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Neck_VirtualSize_LM,
      CollectionName:                 "Neck",
      VirtualSize_IntervalName:       "LM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Neck_VirtualSize_XLM,
      CollectionName:                 "Neck",
      VirtualSize_IntervalName:       "XLM",
      tshirtID:                       tshirtID,
    );
    await snapshotReferenceUpdate(
      Variable_VirtualSize_MatchNameList: Neck_VirtualSize_NM,
      CollectionName:                 "Neck",
      VirtualSize_IntervalName:       "NM",
      tshirtID:                       tshirtID,
    );

  }

  Future<void> handle()async{
     //final QuerySnapshot tshirtsSnapshot = await ProductsRef.doc("tshirt").collection("TshirtProducts").get();

    // DocumentSnapshot tshirt19Snapshot = await ProductsRef.doc("tshirt").collection("TshirtProducts").doc("tshirt_3").get();
    // await MATCH_TSHIRT(tshirt19Snapshot);

    // for(var tshirtDoc in tshirtsSnapshot.docs){
    //   await getVirtualSizes(tshirtDoc);
    //   print("**************************************************** DONE!   " + tshirtDoc.id);
    //   print("  ");
    // }
    //

    //await copyVirtualSizesTable();
    //getTshirts();



  print("OVER!");
  }

  Future<int> getLargestID()async{
    final querySnapshot = await ProductsRef.doc("tshirt").collection("TshirtProducts").get();
    int max = 0;
    for(var doc in querySnapshot.docs){
      int position = doc.id.indexOf("_");
      if( int.parse(doc.id.substring(position+1)) >= max)
        max = int.parse(doc.id.substring(position+1));
    }

    setState(() {
      largest = max;
    });
    return max;
  }

  Future<void> addProduct()async {
    int largest = await  getLargestID();
    String myTshirtID = "tshirt_" +  (largest+1).toString();

    await ProductsRef.doc("tshirt").collection("TshirtProducts").doc(myTshirtID).set(TshirtDocData);
    DocumentSnapshot docSnap = await ProductsRef.doc("tshirt").collection("TshirtProducts").doc(myTshirtID).get();
    await MATCH_TSHIRT(docSnap);

  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String,dynamic> TshirtDocData = {};
  Map<String,String> measureData = {};
  int largest;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DB CONFIG"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ElevatedButton(
                child: Text("GET MAX TSHIRT ID: "),
                onPressed: () async{
                  await getLargestID();
                },
              ),
              Text(
                largest == null ? "000" : largest.toString(),
              ),
              SizedBox(height: 16.0,),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.deepPurple[200],
                    filled: true,
                    labelText: "Company",
                    labelStyle: TextStyle(
                        color: Colors.black
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),

                  ),
                  keyboardType: TextInputType.text,

                  validator: (value) {
                    if(value.isEmpty) {
                      return " ";
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    TshirtDocData["Company"] = value;
                  },
                ),
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              SizedBox(height: 16.0,),
              Container(
                child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.deepPurple[200],
                  filled: true,
                  labelText: "Price",
                  labelStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),

                ),
                keyboardType: TextInputType.number,

                validator: (value) {
                  if(value.isEmpty) {
                    return " ";
                  }
                  return null;
                },
                onSaved: (String value) {
                  TshirtDocData["Price"] = double.parse(value);
                },
              ),
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              SizedBox(height: 16.0,),
              Container(
                child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.deepPurple[200],
                  filled: true,
                  labelText: "Size",
                  labelStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),

                ),
                keyboardType: TextInputType.text,

                validator: (value) {
                  if(value.isEmpty) {
                    return " ";
                  }
                  return null;
                },
                onSaved: (String value) {
                  TshirtDocData["Size"] = value;
                },
              ),
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              SizedBox(height: 16.0,),
              Container(
                child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.deepPurple[200],
                  filled: true,
                  labelText: "flex",
                  labelStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),

                ),
                keyboardType: TextInputType.number,

                validator: (value) {
                  if(value.isEmpty) {
                    return " ";
                  }
                  return null;
                },
                onSaved: (String value) {
                  TshirtDocData["flex"] = int.parse(value);
                },
              ),
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              SizedBox(height: 16.0,),
              Container(
                child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.deepPurple[200],
                  filled: true,
                  labelText: "arm",
                  labelStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),

                ),
                keyboardType: TextInputType.text,

                validator: (value) {
                  if(value.isEmpty) {
                    return " ";
                  }
                  return null;
                },
                onSaved: (String value) {
                  measureData["arm"] = value;
                },
              ),
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              SizedBox(height: 16.0,),
              Container(
                child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.deepPurple[200],
                  filled: true,
                  labelText: "chest",
                  labelStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),

                ),
                keyboardType: TextInputType.number,

                validator: (value) {
                  if(value.isEmpty) {
                    return " ";
                  }
                  return null;
                },
                onSaved: (String value) {
                  measureData["chest"] = value;
                },
              ),
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              SizedBox(height: 16.0,),
              Container(
                child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.deepPurple[200],
                  filled: true,
                  labelText: "length",
                  labelStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),

                ),
                keyboardType: TextInputType.number,

                validator: (value) {
                  if(value.isEmpty) {
                    return " ";
                  }
                  return null;
                },
                onSaved: (String value) {
                  measureData["length"] = value;
                },
              ),
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              SizedBox(height: 16.0,),
              Container(
                child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.deepPurple[200],
                  filled: true,
                  labelText: "neck_x",
                  labelStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),

                ),
                keyboardType: TextInputType.number,

                validator: (value) {
                  if(value.isEmpty) {
                    return " ";
                  }
                  return null;
                },
                onSaved: (String value) {
                  measureData["neck_x"] = value;
                },
              ),
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              SizedBox(height: 16.0,),
              Container(
                child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.deepPurple[200],
                  filled: true,
                  labelText: "neck_y",
                  labelStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),

                ),
                keyboardType: TextInputType.number,

                validator: (value) {
                  if(value.isEmpty) {
                    return " ";
                  }
                  return null;
                },
                onSaved: (String value) {
                  measureData["neck_y"] = value;
                },
              ),
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              SizedBox(height: 16.0,),
              Container(
                child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.deepPurple[200],
                  filled: true,
                  labelText: "shoulder",
                  labelStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),

                ),
                keyboardType: TextInputType.number,

                validator: (value) {
                  if(value.isEmpty) {
                    return " ";
                  }
                  return null;
                },
                onSaved: (String value) {
                  measureData["shoulder"] = value;
                },
              ),
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              SizedBox(height: 16.0,),
              Container(
                child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.deepPurple[200],
                  filled: true,
                  labelText: "sleeve",
                  labelStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),

                ),
                keyboardType: TextInputType.number,

                validator: (value) {
                  if(value.isEmpty) {
                    return " ";
                  }
                  return null;
                },
                onSaved: (String value) {
                  measureData["sleeve"] = value;
                },
              ),
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              SizedBox(height: 16.0,),
              Container(
                child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.deepPurple[200],
                  filled: true,
                  labelText: "waist",
                  labelStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),

                ),
                keyboardType: TextInputType.number,

                validator: (value) {
                  if(value.isEmpty) {
                    return " ";
                  }
                  return null;
                },
                onSaved: (String value) {
                  measureData["waist"] = value;
                },
              ),
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              SizedBox(height: 16.0,),
              Container(
                child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.deepPurple[200],
                  filled: true,
                  labelText: "mediaUrl",
                  labelStyle: TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),

                ),
                keyboardType: TextInputType.text,

                validator: (value) {
                  if(value.isEmpty) {
                    return " ";
                  }
                  return null;
                },
                onSaved: (String value) {
                  TshirtDocData["mediaUrl"] = value;
                },
              ),
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
              ),
              SizedBox(height: 16.0,),

              ElevatedButton(
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    _formKey.currentState.save();
                    TshirtDocData["measureData"] = measureData;

                    showDialog(context: context,
                        barrierDismissible: false,
                        builder: (BuildContext dialogContext){
                          return CustomDialogBox(
                            title: "ADDING TSHIRT...",
                            descriptions: "This process will end in seconds.",
                          );
                        }
                    );

                    await addProduct();

                    Navigator.pop(context);

                  }
                  },
                child: Text("ADD TSHIRT"),
              ),
              SizedBox(height: 16.0,),

            ],
          ),
        )
      ),
    );
  }
}
