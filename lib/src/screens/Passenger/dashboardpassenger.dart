
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_flutter/qr_flutter.dart';


class Dashboard extends StatefulWidget{
  @override 
  DashboardScreen createState() => DashboardScreen();
}

class DashboardScreen extends State<Dashboard> {
 final auth = FirebaseAuth.instance;
 final db = FirebaseFirestore.instance;
 Map data;


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
                  child: !snapshot.hasData? animate() : Scaffold(
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
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height:20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height:150),
                                  CircleAvatar(
                                    backgroundImage: AssetImage('Images/dasha.png'),
                                    radius: 70,
                                  ),
                                ],
                              ),
                              SizedBox(height:40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width:60),
                                  Text('Name: ',style: TextStyle(color: Colors.grey[600], fontSize: 20),),
                                  Text(data['F_name']+' '+data['L_name'],style: TextStyle( fontSize: 20)),
                                ],
                              ),
                              SizedBox(height:20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width:60),
                                  Text('Date Vaccined: ',style: TextStyle(color: Colors.grey[600], fontSize: 20),),
                                  Text(data['Date_of_Vaccination'],style: TextStyle( fontSize: 20)),
                                ]
                              ),
                              SizedBox(height:20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width:60),
                                  Text('Placed Vaccined: ',style: TextStyle(color: Colors.grey[600], fontSize: 20),),
                                  Text(data['Placed_vacined'],style: TextStyle( fontSize: 20)),
                                ]
                              ),
                              SizedBox(height:20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width:60),
                                  Text('Vaccine ID: ',style: TextStyle(color: Colors.grey[600], fontSize: 20),),
                                  Text( data['Brand_number'].toString(),style: TextStyle( fontSize: 20)),
                                ]
                              ),   
                              SizedBox(height:120),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FloatingActionButton(
                                  onPressed: () {
                                    showDialog(context: context, builder: (context){
                                          return Dialog(
                                            child: Container(
                                              width: MediaQuery.of(context).size.width / 1.5,
                                              height: MediaQuery.of(context).size.height / 3,
                                              child:  Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                        QrImage(
                                                          data: auth.currentUser.uid+"."+data['M_Brand']+"."+data['Brand_name']+"."+data['Brand_number'].toString()+"."+data['Physician_name']+"."+data['License_no']+'.'+data['Status'].toString(),
                                                          size: 240,
                                                          backgroundColor: Colors.white,
                                                        ),
                                                    ],),
                                                ),
                                            ),
                                        );
                                    });
                                  },
                                  child: Icon(
                                    Icons.qr_code,
                                    color: Colors.pink,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                ],
                              ),
                            ],
                          ),
                        ); 
                      },  
                    )
                  ),
                );
              },
            ), 
          );
        }
}


Widget animate(){
  @override 
  Widget build(BuildContext context){
    Timer(Duration(seconds: 2),()=> Navigator.of(context).pop());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SpinKitCircle(
        color: Colors.pinkAccent,
        size: 50,
      ),
    );
  }
}


  