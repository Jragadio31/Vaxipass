
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../route.dart';
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
    Navigator.of(context).pop();
  }
  
  void signIn(BuildContext context, _email, _password,TextEditingController em,TextEditingController pa){
    this.context = context;

    try{
      auth.signInWithEmailAndPassword(email: _email, password: _password)
      .then((_) => {
          FirebaseFirestore
          .instance
          .collection('users')
          .doc(auth.currentUser.uid)
          .get()
          .then((snapshot) => {
              if(snapshot.exists){
                em.clear(), pa.clear(),
                if(snapshot.data()['role'] == 'verifier')
                  Navigator.of(context).pushNamed(AppRoutes.authVerifier)
                else
                  Navigator.of(context).pushNamed(AppRoutes.authPassenger),
              }else print('snapshot does not exist'),
            }),
      })
      .catchError((stackTrace){
        if("[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."==stackTrace.toString())
          print('User account doesnt exist.  ');
        if("[firebase_auth/wrong-password] The password is invalid or the user does not have a password."==stackTrace.toString())
          print('Password is incorrect');
      });
    }catch(e){
      print(e.toString());
    }
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