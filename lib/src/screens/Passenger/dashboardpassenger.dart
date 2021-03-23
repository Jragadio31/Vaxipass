
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';


class Dashboard extends StatefulWidget{
  @override 
  DashboardScreen createState() => DashboardScreen();
}

class DashboardScreen extends State<Dashboard> {
 final auth = FirebaseAuth.instance;
 final db = FirebaseFirestore.instance;
 Map data;

  String convertDate(String dateVaccined){
    var exactDate = dateVaccined.split('/');
    return exactMonth(int.parse(exactDate[0])) +' '+ exactDate[1].toString() + ' ' + exactDate[2].toString();
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
          return Container(
            child: FutureBuilder<DocumentSnapshot> (
              future: db.collection('users').doc(auth.currentUser.uid).get(),
              builder: (context, snapshot){  
                if(snapshot.hasData) {
                  data = snapshot.data.data();
                }

                return Container(
                  child: !snapshot.hasData? animate() : Scaffold(
                    appBar: 
                      AppBar(
                        title: Text('Dashboard', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 28),)), 
                        automaticallyImplyLeading: false, 
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                    body: SafeArea(
                      child: LayoutBuilder(
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
                                      
                                      backgroundImage: AssetImage('Images/user.png'),
                                      radius: 70,
                                    ),
                                  ],
                                ),
                                SizedBox(height:40),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(data['F_name']+' '+data['L_name'],style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),)),
                                    Text('Name ',style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey,fontSize: 13),)),
                                  ],
                                ),
                                SizedBox(height:20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(convertDate(data['Date_of_Vaccination']) ,style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),)),
                                    Text('Date Vaccined ',style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey,fontSize: 13),),),
                                  ]
                                ),
                                SizedBox(height:20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(data['Placed_vacined'],style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),)),
                                    Text('Place Vaccined ',style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey,fontSize: 13),),),
                                  ]
                                ),
                                SizedBox(height:20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text( data['Brand_number'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 20),)),
                                    Text('Vaccine ID',style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey,fontSize: 13),),),
                                  ]
                                ),   
                                SizedBox(height:70),
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
                      ),
                    )
                  ),
                );
              },
            ), 
          );
        }
}

Widget animate(){
    return SpinKitFadingCircle( color: Colors.pinkAccent,size: 50,);
}


  