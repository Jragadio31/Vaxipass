
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Services/firebaseservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:location/location.dart';
class History extends StatefulWidget{
  @override 
  HistoryView createState() => HistoryView();
}

class HistoryView extends State<History>{
  Map data;
 final db = FirebaseFirestore.instance;
 final auth = FirebaseAuth.instance;
 CollectionReference users = FirebaseFirestore.instance.collection('VacpassHistory');
  

  // List<Address> addr = [];
  // Address _addr;
  // String addr1 = "";
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("");
        }
        
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        return  Container(
          child: !snapshot.hasData? animate() :
            Scaffold(
              appBar: 
                AppBar(
                  title: Text('History', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 28),)), 
                  automaticallyImplyLeading: false, 
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
              body: ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  if(document.data()['Verifier_uid'] == auth.currentUser.uid)
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
 

Widget animate(){
  return SpinKitCircle( color: Colors.pinkAccent, size: 50,);
}

