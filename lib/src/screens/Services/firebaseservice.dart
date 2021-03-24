
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'userclass.dart';

class DatabaseService {
  DateTime backbuttonpressedTime;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance.collection('users');
  String role;
  UserData user;

  BuildContext context;

   void resetPassword( BuildContext context, _email){
    auth.sendPasswordResetEmail(email: _email);
  }
  
  void signOut(){
    auth.signOut();
    Navigator.of(context).pop();
  }

  DateTime convertDate(Timestamp time){
    Timestamp _dateofVaccination = time;
    return _dateofVaccination.toDate();
  }

  UserData getUserInformation(String uid){
    try{
      UserData userData;
      db
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) => {
        if(documentSnapshot.exists){
          userData = new 
          UserData(
            auth.currentUser.uid, 
            documentSnapshot.data()['F_name'], 
            documentSnapshot.data()['L_name'], 
            documentSnapshot.data()['Address'], 
            documentSnapshot.data()['M_Brand'], 
            documentSnapshot.data()['Brand_name'], 
            documentSnapshot.data()['Brand_number'], 
            documentSnapshot.data()['Date_of_Vaccination'], 
            documentSnapshot.data()['Placed_vacined'], 
            documentSnapshot.data()['Physician_name'], 
            documentSnapshot.data()['RT_PCR_Date'], 
            documentSnapshot.data()['License_no'],
          ),
          role = documentSnapshot.data()['role'],
        }
      });
      return userData;
    } on Exception{
      return null;
    }
  }
  
  getVerification(String brandnumber){
    return  
    FirebaseFirestore.
    instance.
    collection('users').
    where('Brand_number',isEqualTo: int.parse(brandnumber)).
    get();
  }

  getHistory(){
    return 
    FirebaseFirestore.
    instance.
    collection('VacpassHistory').
    orderBy('Date',descending: true).
    snapshots();
  }

  
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backbuttonpressedTime == null ||
      currentTime.difference(backbuttonpressedTime) > Duration(seconds: 2);
    if(backButton){
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
        msg: 'Double tap to exit the app',
        backgroundColor: Colors.grey,
        textColor: Colors.white
      );
      return false;
    }
    return true;
  }

  Future<DocumentSnapshot> getUserRole()async{
    try{
        return await db.
        doc(auth.currentUser.uid).
        get();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}