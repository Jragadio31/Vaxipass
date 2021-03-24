
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Services/CustomTextField.dart';
import 'Services/firebaseservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../route.dart';


class LoginScreen extends StatefulWidget {


  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  final auth = FirebaseAuth.instance;
 final TextInputType keyEmail = TextInputType.emailAddress;
 final TextEditingController _email = TextEditingController();
  final auth = FirebaseAuth.instance;
 final TextInputType keyPass = TextInputType.text;
 final TextEditingController _password = TextEditingController();

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
              .then((_) => {
                  FirebaseFirestore
                  .instance
                  .collection('users')
                  .doc(auth.currentUser.uid)
                  .get()
                  .then((snapshot) => {
                      if(snapshot.exists){
                        _email.clear(), _password.clear(),
                        if(snapshot.data()['role'] == 'verifier')
                          Navigator.of(context).pushNamed(AppRoutes.authVerifier)
                        else
                          Navigator.of(context).pushNamed(AppRoutes.authPassenger),
                      }else print('snapshot does not exist'),
                    }),
              })
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
      onWillPop: DatabaseService().onWillPop,
      child: Scaffold(
      appBar: 
        AppBar(
          automaticallyImplyLeading: false, 
          backgroundColor: Colors.pinkAccent,
          elevation: 0,
          toolbarHeight: 0,
        ),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                  ),
                  child:Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: 
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Material(
                                color: Colors.transparent,
                                child:  Image.asset('Images/vacpass-logo2.png', width:120, height: 120),
                              ),
                            ),
                        ),
                        Text('Vaxipass',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Expanded(
                          flex: 2,
                          child: Form(
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
                          ),
                        )
                      ],
                     ),
                  )
                ),
                showAlert(),
              ],
            )
          )
      ),
    );
  }
}