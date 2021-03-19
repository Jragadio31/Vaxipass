import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../route.dart';

class UserData{
  final db = FirebaseFirestore.instance.collection('users');

  final String dataDivider = '.';
  String uid;
  String firstname;
  String lastname;
  String address;
  String manufacturer;
  String brandname;
  int brandnumber;
  String datevaccined;
  String placevaccined;
  String physicianname;
  String rtpcrdate;
  String licenseno;
  bool status;
  
  UserData(
    this.uid,
    this.firstname,
    this.lastname,
    this.address,
    this.manufacturer,
    this.brandname,
    this.brandnumber,
    this.datevaccined,
    this.placevaccined,
    this.physicianname,
    this.rtpcrdate,
    this.licenseno
  );

  String getUID(){
    return this.uid;
  }

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

  String getDateVaccined(){
    return this.datevaccined;
  }
  
  String getDateRTPCR(){
    return this.rtpcrdate;
  }

  void setFirstname(String firstname){
    this.firstname = firstname;
  }
  
  void setLastname(String lastname){
    this.lastname = lastname;
  }

  void setAddress(String address){
    this.address = address;
  }

  void setManufacturer(String manufacturer){
    this.manufacturer = manufacturer;
  }

  void setBrandname(String brandname){
    this.brandname = brandname;
  }

  void setBrandnumber(int brandNumber){
    this.brandnumber = brandNumber;
  }

  void setDateVaccined(DateTime datevaccined){
    this.datevaccined = datevaccined.toString();
  }

  void setPlaceVaccined(String placevaccined){
    this.placevaccined = placevaccined;
  }

  void setPhysician(String physicianname){
    this.physicianname = physicianname;
  }

  void setDateRTPCR(DateTime rtpcrdate){
    this.rtpcrdate = rtpcrdate.toString();
  }
  
  void setLicenseNo(String licenseno){
    this.licenseno = licenseno;
  }

  DateTime convertToDate(Timestamp time){
    Timestamp _date = time;
    return _date.toDate();
  }

  String convertDatetoString(DateTime _dateType){
    return _dateType.month.toString() +'/'+ _dateType.day.toString() + '/' + _dateType.year.toString();
  }

  bool updateInformationData(){
    try{
      db
      .doc(uid)
      .update({
        'F_name': this.firstname,
        'L_name': this.lastname,
        'Address': this.address,
        'M_Brand': this.manufacturer,
        'Brand_name': this.brandname,
        'Brand_number': this.brandnumber,
        'Date_of_Vaccination': this.datevaccined,
        'Placed_vacined:': this.placevaccined,
        'Physician_name': this.physicianname,
        'RT_PCR_Date': this.rtpcrdate,
        'Licence_no': this.licenseno,
      });
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
        'L_name': this.lastname,
        'F_name': this.firstname,
        'Address': this.address,
        'M_Brand': this.manufacturer,
        'Brand_name': this.brandname,
        'Brand_number': this.brandnumber,
        'Date_of_Vaccination': this.datevaccined,
        'Placed_vacined': this.placevaccined,
        'Physician_name': this.physicianname,
        'RT_PCR_Date': this.rtpcrdate,
        'License_no':this.licenseno,
        'role': 'passenger',
        'Status': true,
      }).then((value) =>
        Navigator.of(context).pushNamed(AppRoutes.authPassenger),
      );

    return processStatus;
  }
}