import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import './FirebaseService.dart';
import '../../route.dart';
import 'ValidatorFunction.dart';


class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}


class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final _formKey = GlobalKey<FormState>();
  

 final TextInputType keyEmail = TextInputType.emailAddress;
 final TextEditingController _email = TextEditingController();

 final TextInputType keyPass = TextInputType.text;
//  TextEditingController _password = TextEditingController();



Widget buildResetPasswordBtn(){
  return 
    // ignore: deprecated_member_use
    RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        ),
        color: Colors.pinkAccent,
        child: Text( 'Send request', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),)),
        onPressed: (){
          if (_formKey.currentState.validate()) {
            DatabaseService().resetPassword(context,_email.text);
            Navigator.of(context).popAndPushNamed(AppRoutes.authLogin);
          }
        },
    );
}

Widget buildCancelBtn(){
  return 
      ElevatedButton(
         style: ElevatedButton.styleFrom(
            primary: Colors.grey[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        child: Text( 'Cancel', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),)),
        onPressed: (){
          Navigator.of(context).popAndPushNamed(AppRoutes.authLogin);
        },
    );
}



  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white
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
                    Text('Password Recovery ?', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 28,fontWeight: FontWeight.w600),)),
                    Text('After you fill up the email text filed \n click Send Request and a link will be\n sent to your  email where you can\n reset your password.',style: TextStyle(color: Colors.grey[600],fontSize: 13),textAlign: TextAlign.center,),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          SizedBox(height: 50),
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
                          Padding(
                            padding: const EdgeInsets.only(top:20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * 0.4,
                                  height: 40,
                                  child:buildCancelBtn(),
                                ),
                                SizedBox(
                                  width: size.width * 0.4,
                                  height: 40,
                                  child:buildResetPasswordBtn(),
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}