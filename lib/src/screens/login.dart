
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './Services/CustomTextField.dart';
import 'Services/firebaseservice.dart';
import '../route.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginScreen extends StatefulWidget {


  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

 final TextInputType keyEmail = TextInputType.emailAddress;
 final TextEditingController _email = TextEditingController();

 final TextInputType keyPass = TextInputType.text;
 final TextEditingController _password = TextEditingController();
 DateTime backbuttonpressedTime;

  String mesg;
  DatabaseService dataService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  @override 
  // ignore: override_on_non_overriding_member
  void iniState(){
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

Widget buildForgetPassword(){
  return Container(
    alignment: Alignment.centerRight,
    // ignore: deprecated_member_use
    child: FlatButton(
      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.authForgetPassword),
      padding: EdgeInsets.only(right: 0),
      child: Text(
        'Forget Password?',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        )
      )
      )
  );
}

Widget buildLoginBtn(){
  return Container(
    padding: EdgeInsets.symmetric( vertical: 25),
    width: double.infinity,
    child: 
      // ignore: deprecated_member_use
      RaisedButton(
        padding: EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        color: Colors.white,
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.pinkAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        onPressed: (){
          if (_formKey.currentState.validate()) {
            try{
              FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.text.trim(), password: _password.text.trim())
              .catchError((stackTrace){
                if("[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."==stackTrace.toString())
                  mesg = 'User doesnt exist';
                if("[firebase_auth/wrong-password] The password is invalid or the user does not have a password."==stackTrace.toString())
                  mesg = 'Password is incorrect';
                  setState(() {});
              });
            }on FirebaseAuthException catch(e){
              print(e.code+'hahaha');
            }
          }
        },
    )
  );
}

  Widget showAlert() {
    
    if ( mesg != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(
                mesg,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    mesg = null;
                    dataService.setMessage(null);
                  });
                }
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

Widget buildSignUpBtn(){
  return GestureDetector(
    onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.authRegister);
    },
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Don\'t have an account yet? ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),
          ),
          TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            )
        ]
      ),
    )
  );
}

  @override
 
  Widget build(BuildContext context){
    return WillPopScope(  
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: 
        AppBar(title: Text(''),backgroundColor: Colors.pinkAccent, elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.pinkAccent,
                        Colors.pinkAccent,
                        Colors.pinkAccent,
                        Colors.pinkAccent,
                      ]
                    )
                  ),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 120
                    ),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      
                      Material(
                        color: Colors.transparent,
                        child:  Image.asset('Images/vacpass-logo2.png', width:120, height: 120),
                      ),
                      Text('Vaxipass',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            SizedBox(height: 50),
                            CustomTextField(_email,keyEmail,'Email address', 'email', false),
                            SizedBox(height: 20),
                            CustomTextField(_password,keyPass,'Password', 'password', true),
                            buildForgetPassword(),
                            buildLoginBtn(),
                            buildSignUpBtn(),  
                        ],
                        )
                     )
                    ],
                  )
                  )
                ),
                showAlert(),
              ],
            )
          )
        )
      ),
    );
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

}
   