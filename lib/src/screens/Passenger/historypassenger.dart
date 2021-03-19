
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:intl/intl.dart';
// import 'package:intl/intl_browser.dart';


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
      stream: users.snapshots(),
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
                  title: Text('History', style: TextStyle(color: Colors.pinkAccent,fontSize: 28),), 
                  automaticallyImplyLeading: false, 
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
              body: Column(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return Card(
                    child: new ListTile(
                      title: new Text(convertDate(document.data()['Date'])),
                      subtitle: new Text(document.data()['Address']),
                    ),
                  );
                }).toList(),
              ),
            ),
        );
      },
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
