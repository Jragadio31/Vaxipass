

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Services/firebaseservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:minimize_app/minimize_app.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vacpass_app/src/screens/Services/ValidatorFunction.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class Verifier extends StatefulWidget{
  @override
  VerifierHomeScreen createState() => VerifierHomeScreen();
}

class VerifierHomeScreen extends State<Verifier> {

 final auth = FirebaseAuth.instance;
 final db = FirebaseFirestore.instance;
 Map data,dat;
 final TextEditingController brandNumber = new TextEditingController();
 final TextInputType keyType = TextInputType.number;

 String uid;
 Position pos;
 Address addr;

  Future<Address> coordinatesToAddress(Coordinates coordinates) async{
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }
  
Future<void> searchVaccineNumber()async{

  showDialog(context: context, builder: (context){
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / 3,
        child: Center(
          child: Column( 
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Enter Vaccine number',style: TextStyle(color: Colors.pinkAccent,fontSize: 24)),
                textCustom('Brand number', 'brandnumber', brandNumber),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ignore: deprecated_member_use
                    RaisedButton(
                      color: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      onPressed: (){
                        brandNumber.clear();
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel',style: TextStyle(color: Colors.white),),
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      color: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      onPressed: (){
                        searchVacc();
                        Navigator.of(context).pop();
                      },
                      child: Text('SEARCH',style: TextStyle(color: Colors.white),),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  });
}

 Widget textCustom(String labels, String action,TextEditingController controller){
    return 
      Padding(
        padding: const EdgeInsets.all(1),
        child: 
          Container(
            padding: EdgeInsets.only(left:20,right:20),
            child: TextFormField(
              controller: controller,
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize:16,),),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: labels,
                hintStyle: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey,fontSize:16),),
                suffixIcon: Icon(Icons.format_list_numbered),
              ),
              validator: (String value){ return ValidatorFunction(action).validate(value);},
              onChanged: (value){
              },
            ),
          ),
      );
  }

Future<void> searchVacc() async {

  pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  GeoPoint point = GeoPoint(pos.latitude,pos.longitude);
  Coordinates coordinates = new Coordinates(pos.latitude,pos.longitude);
  coordinatesToAddress(coordinates).then((value) => { addr = value });

  setState(() {
  try{          
    DatabaseService().
    getVerification(brandNumber.text).
    then((doc) =>  {
      doc.docs.forEach((DocumentSnapshot document) { showDialog(context: context, builder: (context){
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: 
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                alignment: Alignment.center,
                child:Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(document['M_Brand'],style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),),),
                              Text('Manufacturer',style: TextStyle(color: Colors.grey,fontSize: 14),),
                            ]
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(document['Brand_name'],style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),),),
                              Text('Brand Name',style: TextStyle(color: Colors.grey,fontSize: 14),),
                            ]
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(document['Brand_number'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),),),
                              Text('Brand no.',style: TextStyle(color: Colors.grey,fontSize: 14),),
                            ]
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(document['Physician_name'],style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),),),
                              Text('Physician Name',style: TextStyle(color: Colors.grey,fontSize: 14),),
                            ]
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(document['License_no'],style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),),),
                              Text('License no.',style: TextStyle(color: Colors.grey,fontSize: 14),),
                            ]
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                          confirmedPass(),
                          // ignore: deprecated_member_use
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            onPressed: (){
                                try{
                                  db
                                  .collection('VacpassHistory')
                                  .add({
                                    'Passenger_uid': document.id,
                                    'Verifier_uid': auth.currentUser.uid,
                                    'Date': DateTime.now(),
                                    'Location': point,
                                    'Address': addr.addressLine,
                                  });
                                } on Exception {
                                  print('failed');
                                }
                                Navigator.of(context).pop(); 
                            },
                            color: Colors.green[700],
                            child: Text('Close',style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 16),),),
                          )
                        ],
                      ),
                    ),
              ),
          );
        });
      }),
    // ignore: return_of_invalid_type_from_catch_error
    }).catchError((onError) => print(onError.toString()+'happen'));
  } on Exception catch(e){
    print(e.toString());
  }
  });
}
//END OF SEARCH BY BRAND NUMBER.

Future<void> scan() async{
     await checkPermission();
  try{
      String barcode = await scanner.scan();
      pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      GeoPoint point = GeoPoint(pos.latitude,pos.longitude);
      Coordinates coordinates = new Coordinates(pos.latitude,pos.longitude);
      coordinatesToAddress(coordinates).then((value) => { addr = value });
      
      setState(() {
        var code = barcode.split('.');
        uid = code[0];
        print(code[6]);
          showDialog(context: context, builder: (context){
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 3,
                  child:  Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(code[1],style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),),),
                              Text('Manufacturer',style: TextStyle(color: Colors.grey,fontSize: 14),),
                            ]
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(code[2],style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),),),
                              Text('Brand Name',style: TextStyle(color: Colors.grey,fontSize: 14),),
                            ]
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(code[3].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),),),
                              Text('Brand no.',style: TextStyle(color: Colors.grey,fontSize: 14),),
                            ]
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(code[4],style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),),),
                              Text('Physician Name',style: TextStyle(color: Colors.grey,fontSize: 14),),
                            ]
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(code[5],style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),),),
                              Text('License no.',style: TextStyle(color: Colors.grey,fontSize: 14),),
                            ]
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                          confirmedPass(),
                          // ignore: deprecated_member_use
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            onPressed: (){
                                try{
                                  db
                                  .collection('VacpassHistory')
                                  .add({
                                    'Passenger_uid': code[0],
                                    'Verifier_uid': auth.currentUser.uid,
                                    'Date': DateTime.now(),
                                    'Location': point,
                                    'Address': addr.addressLine,
                                  });
                                } on Exception {
                                  print('failed');
                                }
                                code = null; 
                                Navigator.of(context).pop(); 
                            },
                            color: Colors.green[700],
                            child: Text('Close'),
                          )
                        ],
                      ),
                    ),
                ),
            );
          });
      });
  } on PlatformException catch(e){
    print(e.message+'message');
  }
}

  Future<void> checkPermission() async{
    if(await Permission.camera.status.isDenied){
      if(await Permission.camera.request().isDenied){
        exitApp();
      }
    }
    if(await Permission.location.status.isDenied){
      if(await Permission.location.request().isDenied){
        exitApp();
      }
    }
    if(await Permission.location.serviceStatus.isDisabled){
      return print('Please connect to internet');
    }
  }

  void exitApp(){
    if(Platform.isAndroid) SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    if(Platform.isIOS) MinimizeApp.minimizeApp();
  }

  Widget confirmedPass(){
    return 
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Confirm ',style: TextStyle(color: Colors.green[700],fontSize: 18),),
          Icon(Icons.check_circle, color: Colors.green[700],),
        ]
      );
  }

  @override
  Widget build(BuildContext context) {
     return Container(
       child: FutureBuilder<DocumentSnapshot> (
         future: db.collection('users').doc(auth.currentUser.uid).get(),
         builder: (context, snapshot){  
          if(!snapshot.hasData){
            Timer(Duration(seconds: 2),()=> print('reload'));
          }
          
          if(snapshot.hasData) {
            data = snapshot.data.data();
            print('has data');
          }

          return Container(
            child: !snapshot.hasData? animate() : SafeArea(
              child: Scaffold(
                appBar: 
                  AppBar(
                    title: Text('Dashboard', style: TextStyle(color: Colors.pinkAccent,fontSize: 28),), 
                    automaticallyImplyLeading: false, 
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                body: LayoutBuilder(
                  builder: (context, constrainst){
                    return Container(
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(color: Colors.white),
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height/4),
                              CircleAvatar(
                                backgroundImage: AssetImage('Images/dasha.png'),
                                radius: 70,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Text(data['F_name'] +' '+ data['L_name'], style: TextStyle(fontSize: 22),),
                            ],
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height:MediaQuery.of(context).size.height * 0.01),
                                Material(
                                  color: Colors.transparent,
                                  child:  Image.asset('Images/scan.png', width:250, height: MediaQuery.of(context).size.height/4),
                                ),
                                SizedBox(height:MediaQuery.of(context).size.height * 0.01),
                                SizedBox(
                                  width:MediaQuery.of(context).size.width/1.5,
                                  height:40,
                                  child: 
                                    // ignore: deprecated_member_use
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                      ),
                                      color: Colors.pinkAccent,
                                      onPressed: scan,
                                      child: Text('SCAN QR CODE',style: TextStyle(color: Colors.white),),
                                    ),
                                ),
                                SizedBox(height:MediaQuery.of(context).size.height * 0.02),
                                SizedBox(
                                  width:MediaQuery.of(context).size.width/1.5,
                                  height:40,
                                  child: 
                                    // ignore: deprecated_member_use
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                      ),
                                      color: Colors.pinkAccent,
                                      onPressed: searchVaccineNumber,
                                      child: Text('SEARCH VACCINE NO.',style: TextStyle(color: Colors.white),),
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ),
                    ); 
                  },  
                )
              ),
            ),
          );
         },
       ), 
     );
  }
}

// ignore: missing_return
Widget animate(){
  @override 
  // ignore: unused_element
  Widget build(BuildContext context){
    Timer(Duration(seconds: 2),()=> print('reloads'));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SpinKitCircle(
        color: Colors.pinkAccent,
        size: 50,
      ),
    );
  }
}
