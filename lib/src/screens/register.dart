import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vacpass_app/src/route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './Services/CustomTextField.dart';
import './Services/userclass.dart';
import '../route.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() =>  _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

 TextEditingController _email = TextEditingController();
 TextEditingController _password = TextEditingController();
 TextEditingController _confirmpassword = TextEditingController();
 TextEditingController _firstName = TextEditingController();
 TextEditingController _lastName = TextEditingController();
 TextEditingController _address = TextEditingController();
 TextEditingController _mbrand = TextEditingController();
 TextEditingController _brandName = TextEditingController();
 TextEditingController _brandNumber = TextEditingController();
 TextEditingController _placeVacined = TextEditingController();
 TextEditingController _physicianName = TextEditingController();
 TextEditingController _licenseNumber = TextEditingController();

 final TextInputType keytext = TextInputType.text;
 final TextInputType keyPass = TextInputType.text;
 bool obs = true;

 DateTime _lastRTPCR,_dateVacined;
 TextEditingController _dateController = TextEditingController();
 TextEditingController _dateVController = TextEditingController();

 String _lastnamelabel = 'Last name';
 String _firstnamelabel = 'Firstname';
 String _addresslabel = 'Address';
 String _mbrandlabel = 'Manufacurer name';
 String _brandnamelabel = 'Brand Name';
 String _brandnumberlabel = 'Brand No';
 String _placevaccinedlabel = 'Place of Vaccination';
 String _physiciannamelabel = 'Physician Name';
 String _licensenumberlabel = 'License Number';
 String _emaillabel = 'Email address';
 String _passwordlabel = 'Password';

 CollectionReference users = FirebaseFirestore.instance.collection('users');

  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();


  String convertDate(DateTime _datevaccined){
    return _datevaccined.month.toString() +'/'+ _datevaccined.day.toString() + '/' + _datevaccined.year.toString();
  }
Widget buildDateVaccined() {
  return 
    TextFormField(
      controller: _dateVController,
      keyboardType: TextInputType.datetime,
      style: TextStyle(
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 14),
        prefixIcon: Icon(Icons.today),
        focusColor: Colors.green[700],
        hintText: 'Date of Vaccination',
        hintStyle: TextStyle(
          color: Colors.black38
        ),
      ),
      onTap: () {
          showDatePicker(
            context: context, 
            initialDate: DateTime.now(), 
            firstDate: DateTime(2020), 
            lastDate: DateTime.now()
          ).then((value) =>
              setState(() {
              _dateVacined = value;
              _dateVController..text = convertDate(_dateVacined) ;
              if(_dateVController.text.isNotEmpty) setState(() { });
              if(_dateVController.text.isEmpty) setState(() { });
            })
          );
      },
      validator: (String value) {
          if (value.isEmpty) return 'Date of Vaccination is Required';
          if(value.toString() == DateTime.now().toString()) return 'Vaccination  date is the day you vacinated';
          return null;
      },
  );
}

Widget buildlastRTPCR() {
  return 
    TextFormField(
      controller: _dateController,
      keyboardType: TextInputType.datetime,
      style: TextStyle(
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 14),
        prefixIcon: Icon(Icons.today),
        hintText: 'Last RT-PCR',
        hintStyle: TextStyle(
          color: Colors.black38
        ),
      ),
      onTap: () {
        showDatePicker(
          context: context, 
          initialDate: DateTime.now(), 
          firstDate: DateTime(2020), 
          lastDate: DateTime.now()
        ).then((value) =>
            setState(() {
            _lastRTPCR = value;
            _dateController..text = convertDate(_lastRTPCR) ;
            if(_dateController.text.isNotEmpty) setState(() { });
          })
        );
      },
      validator: (String value) {
        if (value.isEmpty) return 'Date of Last RT-PCR is Required';
        return null;
      }
  );
}


Widget buildconfirmpassword() {
  return 
    TextFormField(
      obscureText: obs,
      controller: _confirmpassword,
      style: TextStyle(
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 14),
        prefixIcon: Icon(Icons.lock),
        hintText: 'Confirm Password',
        hintStyle: TextStyle(
          color: Colors.black38
        ),
        suffixIcon: IconButton(
          onPressed:  (){setState(() {obs = ! obs; });},
          icon: obs ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
        ) ,
      ),
      validator: (String value) {
        if (value.isEmpty) return 'Password is Required';
        if(_password.text!= _confirmpassword.text){
          _password.clear();
          _confirmpassword.clear();
          return 'Confirmation password and password didn\'t match';
        }
        else return null;
    },
  );
}

             

Widget buildSignInBtn(){
  return 
    // ignore: deprecated_member_use
    RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        ),
        color: Colors.pinkAccent,
        child: Text(
          'Submit', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),)
        ),
        onPressed: (){if (
          _formKey.currentState.validate()) {
            try{
              auth.createUserWithEmailAndPassword(email: _email.text,password: _password.text).then((_){

                UserData user = new 
                UserData( 
                  auth.currentUser.uid, 
                  _firstName.text, 
                  _lastName.text, 
                  _address.text, 
                  _mbrand.text, 
                  _brandName.text, 
                  int.parse(_brandNumber.text), 
                  _dateVController.text , 
                  _placeVacined.text, 
                  _physicianName.text, 
                  _dateController.text, 
                  _licenseNumber.text
                  );
                  bool stat = user.addPassengerInfo(context);
                  
                  if(stat) {
                    _firstName.clear();
                    _lastName.clear();
                    _address.clear();
                    _mbrand.clear();
                    _brandName.clear();
                    _brandNumber.clear();
                    _dateVController.clear();
                    _placeVacined.clear();
                    _physicianName.clear(); 
                    _dateController.clear(); 
                    _licenseNumber.clear();
                  }
              });
            } on FirebaseAuthException catch(e){
              print(e.message);
            }
          }
        },
    );
}


          

Widget buildCancelBtn(){
  return 
      ElevatedButton(
         style: ElevatedButton.styleFrom(
            primary: Colors.grey[800],
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
      appBar: 
        AppBar(
          title: Text('Create My Vaxipass Account', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)),
          backgroundColor: Colors.pinkAccent,
          automaticallyImplyLeading: false,
        ),
      body: 
        Container(
        height: double.infinity,
        width: double.infinity,
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0,right: 24.0,bottom: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    CustomTextField(this._firstName, this.keytext, this._firstnamelabel, 'firstname', false),
                    SizedBox(height: size.height * 0.03 ),
                    CustomTextField(this._lastName, this.keytext, this._lastnamelabel, 'lastname', false),
                    SizedBox(height: size.height * 0.03 ),
                    CustomTextField(this._address, this.keytext, this._addresslabel, 'address', false),
                    SizedBox(height: size.height * 0.03 ),
                    CustomTextField(this._mbrand, this.keytext, this._mbrandlabel, 'manufacturer', false),
                    SizedBox(height: size.height * 0.03 ),
                    CustomTextField(this._brandName, this.keytext, this._brandnamelabel, 'brandname', false),
                    SizedBox(height: size.height * 0.03 ),
                    CustomTextField(this._brandNumber, this.keytext, this._brandnumberlabel, 'brandnumber', false),
                    SizedBox(height: size.height * 0.03 ),
                    buildDateVaccined(),
                    SizedBox(height: size.height * 0.03 ),
                    CustomTextField(this._placeVacined, this.keytext, this._placevaccinedlabel, 'placevaccined', false),
                    SizedBox(height: size.height * 0.03 ),
                    CustomTextField(this._physicianName, this.keytext, this._physiciannamelabel, 'physician', false),
                    SizedBox(height: size.height * 0.03 ),
                    CustomTextField(this._licenseNumber, this.keytext, this._licensenumberlabel, 'licensenumber', false),
                    SizedBox(height: size.height * 0.03 ),
                    buildlastRTPCR(),
                    SizedBox(height: size.height * 0.03 ),
                    CustomTextField(this._email, this.keytext, this._emaillabel, 'email', false),
                    SizedBox(height: size.height * 0.03 ),
                    CustomTextField(this._password, this.keyPass, this._passwordlabel, 'password', true),
                    SizedBox(height: size.height * 0.03 ),
                    buildconfirmpassword(),
                    SizedBox(height: size.height * 0.03 ),
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
                            child:buildSignInBtn(),
                          ),
                        ],
                      ),
                    ),
                ],
            ),
              ),
          ),
         ]
        )
      )
    );
  }
}