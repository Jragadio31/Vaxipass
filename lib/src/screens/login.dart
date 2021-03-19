
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vacpass_app/src/screens/CustomTextField.dart';
import './FirebaseService.dart';
import '../route.dart';
import 'package:fluttertoast/fluttertoast.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  DateTime backbuttonpressedTime;

 final TextInputType keyEmail = TextInputType.emailAddress;
 final TextEditingController _email = TextEditingController();

 final TextInputType keyPass = TextInputType.text;
 TextEditingController _password = TextEditingController();

Widget buildForgetPassword(){
  return Container(
    alignment: Alignment.centerRight,
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
           DatabaseService().signIn(context,_email.text,_password.text,_email ,_password);

              // showDialog(context: context, builder: (context){
              //         return Dialog(
              //           child: Container(
              //             width: MediaQuery.of(context).size.width / 1.5,
              //             height: MediaQuery.of(context).size.height / 3,
              //             child:  Center(
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: <Widget>[
              //                       Text(err)
              //                   ],),
              //               ),
              //           ),
              //       );
              //   });
          }
        },
    )
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
    return  Scaffold(
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
                        Colors.pink,
                        Colors.purple[300],
                        Colors.purpleAccent,
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
                            CustomTextField(this._email, this.keyEmail, 'Email Address', 'email', false),
                            SizedBox(height: 20),
                            CustomTextField(this._password, this.keyPass, 'Password', 'password', true),
                            buildForgetPassword(),
                            buildLoginBtn(),
                            buildSignUpBtn(),  
                            
                        ],
                        )
                     )
                    ],
                  )
                  )
                )
              ],
            )
          )
        )
      );
  }
  }
 