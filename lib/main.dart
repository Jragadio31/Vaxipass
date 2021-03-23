
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/route.dart';
import 'src/screens/login.dart';

 void main() async{ 
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MyApp());
 }
 
 // ignore: must_be_immutable
 class MyApp extends StatelessWidget{
   @override    
   Widget build(BuildContext context){
     return 
      MaterialApp(
        title: 'Vacpass',
        routes: AppRoutes.define(),
        theme: ThemeData(primaryColor: Colors.pinkAccent),
        home: LoginScreen(),
      );
   }
 }