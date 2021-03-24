

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vacpass_app/src/route.dart';





class PassengerSettings extends StatefulWidget{
  @override 
  SettingsView createState() => SettingsView();
 
}

class SettingsView extends State<PassengerSettings>{
 Map data;
 final db = FirebaseFirestore.instance;
 final auth = FirebaseAuth.instance;
 
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, 
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: 
          SafeArea(
            child: Container(
              alignment: Alignment.center,
              // padding: EdgeInsets.only(left: 16, top: 25, right: 16),
              height: MediaQuery.of(context).size.height,
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Expanded(
                       flex: 4,
                       child: SizedBox(
                        child: Carousel(
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          dotBgColor: Colors.transparent,
                          indicatorBgPadding: 5.0,
                          dotColor: Colors.pink,
                          dotVerticalPadding: 5.0,
                          dotPosition: DotPosition.bottomRight,
                          images: [
                             InkWell(
                              child: Image.asset('Images/ads.png', fit: BoxFit.cover)
                             ),
                              InkWell(
                              child: Image.asset('Images/download.jpg', fit: BoxFit.cover)
                             ),
                             InkWell(
                              child: Image.asset('Images/vacine.jpg', fit: BoxFit.cover)
                             )
                          ],
                        )
                    ),
                     ),
                     Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Setting',style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 24,fontWeight: FontWeight.w600),)),
                          ],
                        ),
                      )
                     ),
                     Expanded(
                        flex: 1,
                       child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                         child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.pinkAccent,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Account",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 18,fontWeight: FontWeight.w400),),
                            ),
                          ],
                          ),
                       ),
                     ),
                      Expanded(
                        flex: 1,
                        child: 
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.authPassengerPass), 
                                  child: Text( 'Change Password', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey[600],fontSize: 16),)),
                                )
                              ],
                            ),
                        ),
                      ),
                      Expanded(
                         flex: 1,
                          child: 
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                              children: [
                                Icon(
                                  Icons.help,
                                  color: Colors.pinkAccent,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Help",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 18,fontWeight: FontWeight.w400),),),
                              ],
                        ),
                            ),
                       ),
                      Expanded(
                        flex: 1,
                        child: 
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () => showPrivacyAndSecurity(),
                                  child: Text( "Privacy and Security", style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey[600],fontSize: 16),)),
                                )
                              ],
                            ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: 
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () => showAboutUs(), 
                                  child: Text( "About us", style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey[600],fontSize: 16),)),
                                )
                              ],
                            ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                      SizedBox(
                                      width:  MediaQuery.of(context).size.width/1.5,
                                      height: 40,
                                      child: 
                                      // ignore: deprecated_member_use
                                      RaisedButton(
                                        color: Colors.pinkAccent,
                                        onPressed: (){
                                          auth.signOut();
                                          Navigator.of(context).popAndPushNamed(AppRoutes.authLogin);
                                        },
                                        child: Text('Sign out', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 18),)),
                                      ),
                                    )
                                ]
                              )
                          ),
                      )
                    ],
              ),
              ),
            ),
          );
  } 

  showPrivacyAndSecurity(){
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context){
      return Dialog(
        child: Container(
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height/1.2,
          width: MediaQuery.of(context).size.width/1.1,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [ 
                  IconButton(icon: Icon(Icons.close), onPressed: Navigator.of(context).pop ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children:[
                  Text('PRIVACY AND SECURITY',style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 18,fontWeight: FontWeight.w600),)), 
                  Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Icon(Icons.security,color: Colors.pink[300]),
                    )
                ]
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0,right: 20.0),
                child: Divider(color: Colors.grey[800],),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'We are a group of developers who \n'
                          'created the vaxipass app to assist \n',
                          style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey[600],fontSize: 13),),textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  showAboutUs(){
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context){
      return Dialog(
        child: Container(
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height/1.2,
          width: MediaQuery.of(context).size.width/1.1,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [ 
                  IconButton(icon: Icon(Icons.close), onPressed: Navigator.of(context).pop ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children:[
                  Text('ABOUT US',style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 18,fontWeight: FontWeight.w600),)), 
                  Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Icon(Icons.info,color: Colors.pink[300]),
                    )
                ]
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0,right: 20.0),
                child: Divider(color: Colors.grey[800],),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'We are a group of developers who \n'
                          'created the vaxipass app to assist \n'
                          'cities in monitoring and protecting\n'
                          'their citizens health. \n'
                          '\n'
                          'Our product is designed to deter \n'
                          'people from entering a city without being vaccinated.\n'
                        ,style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey[600],fontSize: 13),),textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}