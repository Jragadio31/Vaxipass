import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../route.dart';

class UserData{
  final db = FirebaseFirestore.instance.collection('users');

  final String dataDivider = '.';
  String _uid;
  String _firstname;
  String _lastname;
  String _address;
  String _manufacturer;
  String _brandname;
  int _brandnumber;
  String _datevaccined;
  String _placevaccined;
  String _physicianname;
  String _rtpcrdate;
  String _licenseno;
  bool _status;

  
  String get uid => _uid;
  String get firstname => _firstname;
  String get lastname => _lastname;
  String get address => _address;
  String get manufacturer => _manufacturer;
  String get brandname => _brandname;
  int get brandnumber => _brandnumber;
  String get datavaccined => _datevaccined;
  String get placevaccined => _placevaccined;
  String get physicianname => _physicianname;
  String get rtpcrdata => _rtpcrdate;
  String get licenseno => _licenseno;
  bool get status => _status;

  
  set uidF(String uid) => _uid = uid;
  set firstnameF(String fname) => _firstname = fname;
  set lastnameF(String lname) => _lastname = lname;
  set addressF(String addr) => _address = addr;
  set manufacturerF(String manuf) => _manufacturer = manuf;
  set brandnameF(String bname) => _brandname = bname;
  set brandnumberF(int bnum) => _brandnumber = bnum;
  set datavaccinedF(String datevac) => _datevaccined = datevac;
  set placevaccinedF(String placevac) => _placevaccined = placevac;
  set physiciannameF(String physician) => _physicianname = physician;
  set rtpcrdataF(String rtp) => _rtpcrdate = rtp;
  set licensenoF(String lic) => _licenseno = lic;
  set statusF(bool stat) => _status = stat;


  UserData(
    this._uid,
    this._firstname,
    this._lastname,
    this._address,
    this._manufacturer,
    this._brandname,
    this._brandnumber,
    this._datevaccined,
    this._placevaccined,
    this._physicianname,
    this._rtpcrdate,
    this._licenseno
  );


  String getNameByFormat(String nameFormat){
    if(nameFormat == 'F-L') return this.firstname + this.lastname;
    return this.lastname + this.firstname;
  }

  String getQRData(){
    String qrData = 
      this.uid + this.dataDivider + 
      this.manufacturer + this.dataDivider +
      this.brandname + this.dataDivider +
      this.brandnumber.toString() + this.dataDivider +
      this.physicianname + this.dataDivider +
      this.licenseno + this.dataDivider +
      this.status.toString()
    ;
    return qrData;
  }


  DateTime convertToDate(Timestamp time){
    Timestamp _date = time;
    return _date.toDate();
  }

  String convertDatetoString(DateTime _dateType){
    return _dateType.month.toString() +'/'+ _dateType.day.toString() + '/' + _dateType.year.toString();
  }

  bool updateInformationData(BuildContext context){
    try{
      print('happen');
      db
      .doc(uid)
      .update({
        'F_name': this._firstname,
        'L_name': this._lastname,
        'Address': this._address,
        'M_Brand': this._manufacturer,
        'Brand_name': this._brandname,
        'Brand_number': this._brandnumber,
        'Date_of_Vaccination': this._datevaccined,
        'Placed_vacined': this._placevaccined,
        'Physician_name': this._physicianname,
        'RT_PCR_Date': this._rtpcrdate,
        'License_no': this._licenseno,
      }).catchError((e){print(e.toString());});
      return true;
    } on Exception {
      return false;
    }
  }

  bool addPassengerInfo(BuildContext context) {
    bool processStatus = false;

    db
    .doc(this.uid)
    .set({
        'L_name': this._lastname,
        'F_name': this._firstname,
        'Address': this._address,
        'M_Brand': this._manufacturer,
        'Brand_name': this._brandname,
        'Brand_number': this._brandnumber,
        'Date_of_Vaccination': this._datevaccined,
        'Placed_vacined': this._placevaccined,
        'Physician_name': this._physicianname,
        'RT_PCR_Date': this._rtpcrdate,
        'License_no':this._licenseno,
        'role': 'passenger',
        'Status': true,
      }).then((value) =>{
          Navigator.of(context).pop(),
          Navigator.of(context).pushNamed(AppRoutes.authPassenger),
        }
      );

    return processStatus;
  }
}