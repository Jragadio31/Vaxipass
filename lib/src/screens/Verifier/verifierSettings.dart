


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_pro/carousel_pro.dart';





class Settings extends StatefulWidget{
  @override 
  SettingsView createState() => SettingsView();
 
}

class SettingsView extends State<Settings>{
 Map data;
 final db = FirebaseFirestore.instance;
 final auth = FirebaseAuth.instance;
 
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: Text('Settings', style: TextStyle(color: Colors.pinkAccent,fontSize: 28),), 
          automaticallyImplyLeading: false, 
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: 
          SafeArea(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 16, top: 25, right: 16),
              height: MediaQuery.of(context).size.height,
              child: ListView(
                    children: [
                     SizedBox(
                      height: 200.0,
                      width: double.infinity,
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
                            onTap: (){
                              
                            },
                            child: Image.asset('Images/ads.png', fit: BoxFit.cover)
                           ),
                            InkWell(
                            onTap: (){
                              
                            },
                            child: Image.asset('Images/download.jpg', fit: BoxFit.cover)
                           ),
                           InkWell(
                            onTap: (){
                              
                            },
                            child: Image.asset('Images/vacine.jpg', fit: BoxFit.cover)
                           )
                        ],
                      )
                    ),
                    SizedBox(
                        height: 40,
                      ),
                     Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.pinkAccent,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Account",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                        ),
                      ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      
                      buildAccountOptionRow(context, "Change password"),
                      SizedBox(
                        height: 30,
                      ),
                       Row(
                      children: [
                        Icon(
                          Icons.help,
                          color: Colors.pinkAccent,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Help",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                        ),
                      ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      buildAccountOptionRow(context, "frequently asked question"),
                      buildAccountOptionRow(context, "Privacy and Security"),
                      buildAccountOptionRow(context, "About us"),
                      SizedBox(
                        height: 100,
                      ),
                       Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                    SizedBox(
                                    width:  MediaQuery.of(context).size.width/1.5,
                                    height: 40,
                                    child: 
                                    RaisedButton(
                                      color: Colors.pinkAccent,
                                      onPressed: (){
                                        
                                        auth.signOut();
                                        Navigator.of(context).pop();
                                        
                                      },
                                      child: Text('Sign out', style: TextStyle(color: Colors.white),),
                                    ),
                                  )
                              ]
                            )
                        )
                    ],
              ),
              ),
            ),
          );
  } 
  
   GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        if(title == "About us"){
           showDialog(context: context, builder: (context){
                return Dialog(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/2,
                    child:  Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      "Uru Company",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 40,
                                      ),
                                    ),
                                  ),
                            ),
                            SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      "URU Co. is a dev company composed of five passionate Zamboangeño developers whose vision for modernizing problem solution drives result. URU Co. is based in Asia’s Latin City, Zamboanga, Philippines.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                            ),
                        
                          ],),
                      ),
                  ),
              );
          });
        }

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}