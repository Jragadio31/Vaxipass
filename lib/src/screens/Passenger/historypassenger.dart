
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Services/firebaseservice.dart';

class HistoryPassenger extends StatefulWidget{
  @override 
  HistoryView createState() => HistoryView();
}

class HistoryView extends State<HistoryPassenger>{
  Map data;
 final db = FirebaseFirestore.instance;
 final auth = FirebaseAuth.instance;
 CollectionReference users = FirebaseFirestore.instance.collection('VacpassHistory');

  String convertDate(Timestamp time){
    Timestamp _dateofVaccination = time;
    DateTime _datevaccined = _dateofVaccination.toDate();
    
    String exacttime = DateFormat.jm().format(_datevaccined);
    return exactMonth(_datevaccined.month) +' '+ _datevaccined.day.toString() + ' ' + _datevaccined.year.toString()+' '+exacttime;
  }
 
 String exactMonth(int month){
   String monthname;

   switch(month){
     case 1: monthname = 'January'; break;
     case 2: monthname = 'February'; break;
     case 3: monthname = 'March'; break;
     case 4: monthname = 'April'; break;
     case 5: monthname = 'May'; break;
     case 6: monthname = 'June'; break;
     case 7: monthname = 'July'; break;
     case 8: monthname = 'August'; break;
     case 9: monthname = 'September'; break;
     case 10: monthname = 'October'; break;
     case 11: monthname = 'November'; break;
     case 12: monthname = 'December'; break;
   }
   return monthname;
 }
 
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().getHistory(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("");
        }
        
        return  Container(
          height: MediaQuery.of(context).size.height,
          child: !snapshot.hasData? animate() :
            Scaffold(
              appBar: 
                AppBar(
                  title: Text('History', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 28),)), 
                  automaticallyImplyLeading: false, 
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
              body: Column(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  if(document.data()['Passenger_uid'] == auth.currentUser.uid)
                    return Card(
                      color: Colors.pinkAccent.shade200,
                      child: new ListTile(
                        title: new Text(convertDate(document.data()['Date']),style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 16),)),
                        subtitle: new Text(document.data()['Address'],style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey[300],fontSize: 14),)),
                      ),
                    );
                  else
                    return Container();
                }).toList(),
              ),
            ),
        );
      },
    );
  }

  
}

// ignore: missing_return
Widget animate(){
  @override 
  // ignore: unused_element
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
