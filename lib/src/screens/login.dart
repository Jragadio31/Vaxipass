
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Services/ValidatorFunction.dart';
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

 final TextInputType keyPass = TextInputType.emailAddress;
 final TextEditingController _password = TextEditingController();
  bool obs = true;
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
  return 
    // ignore: deprecated_member_use
    FlatButton(
      child: Text( 'Forget Password?', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey,fontSize: 16),)),
      onPressed: () => Navigator.of(context).popAndPushNamed(AppRoutes.authForgetPassword),
      hoverColor: Colors.red ,
    );
}

Widget buildLoginBtn(){
  return 
    // ignore: deprecated_member_use
    RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        ),
        color: Colors.pinkAccent,
        child: Text(
          'Login', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),)
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
                          Navigator.of(context).popAndPushNamed(AppRoutes.authVerifier)
                        else
                          Navigator.of(context).popAndPushNamed(AppRoutes.authPassenger),
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
  return 
    // ignore: deprecated_member_use
    RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      color: Colors.green[700],
      child: Text('Create New Vaxipass Account', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),)),
      onPressed: (){ Navigator.of(context).popAndPushNamed(AppRoutes.authRegister); }
    );
}

  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(automaticallyImplyLeading: false, backgroundColor: Colors.transparent, elevation: 0, toolbarHeight: 0,),
      body: 
        Builder(builder: (context){
          return SafeArea(
            child: Container(
              height: size.height,
              decoration: BoxDecoration(color: Colors.white),
              alignment: Alignment.topCenter,
              child: Column(
                children:<Widget>[
                  showAlert(),
                  SizedBox(height:size.height * 0.02),
                  Image.asset('Images/logo.png',height: size.height * 0.16,),
                  SizedBox(height:size.height * 0.02),
                  Text('Vaxipass', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 30),) ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30,right: 30,top: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            TextFormField(
                              controller: _email,
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 14),
                                prefixIcon: Icon(Icons.email),
                                hintText: 'Email Address',
                                hintStyle: TextStyle(
                                  color: Colors.black38
                                )
                              ),
                              validator: (value) {
                                return ValidatorFunction('email').validate(value);
                              },
                            ),
                          SizedBox(height: size.height * 0.03 ),
                            TextFormField(
                              obscureText: obs,
                              controller: _password,
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 14),
                                prefixIcon: Icon(Icons.lock),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Colors.black38
                                ),
                                suffixIcon: IconButton(
                                  onPressed:  (){setState(() {obs = ! obs; });},
                                  icon: obs ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
                                ) ,
                              ),
                              validator: (value) {
                                return ValidatorFunction('password').validate(value);
                              },
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: SizedBox(
                              width: size.width,
                              height: 40,
                              child: buildLoginBtn(),
                            ),
                          ),
                          // ignore: deprecated_member_use
                          buildForgetPassword(),
                          buildSignUpBtn(),
                        ],
                      ),
                    )
                  ),
                ]
              ),
            )
          );
        }),
    );
  }
}