import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

 DateTime _lastRTPCR,_dateVacined;
 TextEditingController _dateController = TextEditingController();
 TextEditingController _dateVController = TextEditingController();

 String _lastnamelabel = 'Last name';
 String _firstnamelabel = 'Firstname';
 String _addresslabel = 'Address';
 String _mbrandlabel = 'Manufacurer name';
 String _brandnamelabel = 'Brand Name';
 String _brandnumberlabel = 'Brand No';
 String _datevaccinedlabel = 'Date Vaccined';
 String _placevaccinedlabel = 'Place of Vaccination';
 String _physiciannamelabel = 'Physician Name';
 String _licensenumberlabel = 'License Number';
 String _lastrtpcrlabel = 'Last RTPCR';
 String _emaillabel = 'Email address';
 String _passwordlabel = 'Password';
 String _confirmpasswordlabel = 'Confirm password';

 CollectionReference users = FirebaseFirestore.instance.collection('users');

  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool obs = true;


  String convertDate(DateTime _datevaccined){
    return _datevaccined.month.toString() +'/'+ _datevaccined.day.toString() + '/' + _datevaccined.year.toString();
  }
Widget buildDateVaccined() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0,2),
                      )
                    ]
                  ),
                  height: 60,
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    controller: _dateVController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 14),
                      prefixIcon: Icon(
                        Icons.date_range,
                        color: Colors.purple[300]
                      ),
                      hintText: this._datevaccinedlabel,
                      hintStyle: TextStyle(
                        color: Colors.black38
                      )
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
                            if(_dateVController.text.isNotEmpty) setState(() {_datevaccinedlabel = 'Date of Vaccination'; });
                            if(_dateVController.text.isEmpty) setState(() {_datevaccinedlabel = ''; });
                          })
                        );
                    },
                    validator: (String value) {
                        if (value.isEmpty) return 'Date of Vaccination is Required';
                        if(value.toString() == DateTime.now().toString()) return 'Vaccination  date is the day you vacinated';
                        return null;
                    },
                  )
                ),
      ],
    );
}

Widget buildlastRTPCR() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: 
        <Widget>[
          SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0,2),
                )
              ]
            ),
            height: 60,
            child: TextFormField(
              keyboardType: TextInputType.datetime,
              style: TextStyle(
                color: Colors.black87,
              ),
              controller: _dateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.date_range_sharp,
                  color: Colors.purple[300]
                ),
                hintText: this._lastrtpcrlabel,
                hintStyle: TextStyle(
                  color: Colors.black38
                )
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
                      if(_dateController.text.isNotEmpty) setState(() {_lastrtpcrlabel = 'Last RT PCR Date'; });
                    })
                  );
              },
              validator: (String value) {
                if (value.isEmpty) return 'Date of Last RT-PCR is Required';
                return null;
              },
            )
          ),
      ],
    );
}


Widget buildconfirmpassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0,2),
              )
            ]
          ),
          height: 60,
          child: TextFormField(
            obscureText: obs,
            controller: _confirmpassword,
            style: TextStyle(
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.purple[300]
              ),
              hintText: this._confirmpasswordlabel,
              hintStyle: TextStyle(
                color: Colors.black38
              ),
              suffixIcon: IconButton(
                onPressed:  (){setState(() {obs = !obs; });},
                icon: obs ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
              ),
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
          ),
        ),
      ],
    );
}


Widget buildSignInBtn(){
  return Container(
    padding: EdgeInsets.symmetric( vertical: 20),
    width: double.infinity,
    child: 
      // ignore: deprecated_member_use
      RaisedButton(
        padding: EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        color: Colors.white,
        child: Text(
          'Sign In',
          style: TextStyle(
            color: Colors.pinkAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        onPressed: (){
          if (_formKey.currentState.validate()) {
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
    )
  );
}

Widget buildCancelBtn(){
  return Container(
    width: double.infinity,
    child: 
      // ignore: deprecated_member_use
      RaisedButton(
        padding: EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        color: Colors.white,
        child: Text(
          'Cancel',
          style: TextStyle(
            color: Colors.pinkAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        onPressed: (){
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(AppRoutes.authLogin);
        },
    )
  );
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
                title: Text('Registration'),
                backgroundColor: Colors.pinkAccent,
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
                    vertical: 30,
                  ),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          SizedBox(height: 7),
                          CustomTextField(this._firstName, this.keytext, this._firstnamelabel, 'firstname', false),
                          SizedBox(height: 7),
                          CustomTextField(this._lastName, this.keytext, this._lastnamelabel, 'lastname', false),
                          SizedBox(height: 7),
                          CustomTextField(this._address, this.keytext, this._addresslabel, 'address', false),
                          SizedBox(height: 7),
                          CustomTextField(this._mbrand, this.keytext, this._mbrandlabel, 'manufacturer', false),
                          SizedBox(height: 7),
                          CustomTextField(this._brandName, this.keytext, this._brandnamelabel, 'brandname', false),
                          SizedBox(height: 7),
                          CustomTextField(this._brandNumber, this.keytext, this._brandnumberlabel, 'brandnumber', false),
                          SizedBox(height: 7),
                          buildDateVaccined(),
                          SizedBox(height: 7),
                          CustomTextField(this._placeVacined, this.keytext, this._placevaccinedlabel, 'placevaccined', false),
                          SizedBox(height: 7),
                          CustomTextField(this._physicianName, this.keytext, this._physiciannamelabel, 'physician', false),
                          SizedBox(height: 7),
                          CustomTextField(this._licenseNumber, this.keytext, this._licensenumberlabel, 'licensenumber', false),
                          SizedBox(height: 7),
                          buildlastRTPCR(),
                          SizedBox(height: 7),
                          CustomTextField(this._email, this.keytext, this._emaillabel, 'email', false),
                          SizedBox(height: 7),
                          CustomTextField(this._password, this.keyPass, this._passwordlabel, 'password', true),
                          SizedBox(height: 7),
                          buildconfirmpassword(),
                          buildSignInBtn(),
                          buildCancelBtn()
                      ],
                      )
                   ),
                  
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