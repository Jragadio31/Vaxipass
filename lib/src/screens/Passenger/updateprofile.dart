
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../Services/userclass.dart';

import '../../route.dart';
import '../Services/ValidatorFunction.dart';

class Update extends StatefulWidget{
  final Map data;
  Update(this.data);

  @override 
  UpdateScreen createState() => UpdateScreen();
}

class UpdateScreen extends State<Update>{
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  final _storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

 TextEditingController _firstName = TextEditingController();
 TextEditingController _lastName = TextEditingController();
 TextEditingController _address = TextEditingController();
 TextEditingController _mbrand = TextEditingController();
 TextEditingController _brandName = TextEditingController();
 TextEditingController _brandNumber = TextEditingController();
 TextEditingController _placeVacined = TextEditingController();
 TextEditingController _physicianName = TextEditingController();
 TextEditingController _licenseNumber = TextEditingController();
 TextEditingController _dateVacc = TextEditingController();
 TextEditingController _dateRT = TextEditingController();
 final TextInputType keytext = TextInputType.text;



  String convertDate(DateTime _datevaccined){
    return _datevaccined.month.toString() +'/'+ _datevaccined.day.toString() + '/' + _datevaccined.year.toString();
  }
  
  @override 
  Widget build(BuildContext context){
    getValue();
    return Scaffold(
      appBar: 
        AppBar(
          title: Text('Edit Profile', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 28),)), 
          automaticallyImplyLeading: false, 
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context,constrainst){
            return GestureDetector(
              onTap: (){ FocusScope.of(context).unfocus();},
              child: Form(
                key: _formKey,
                child: 
                  ListView(
                    children: [
                      SizedBox(height: 160, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [imageProfile()],),),
                      Container(
                        height: MediaQuery.of(context).size.height/1.6,
                        child: ListView(
                          children: [
                            textCustom('First name','firstname',_firstName),
                            SizedBox(height: 10),
                            textCustom('Last name','lastname',_lastName),
                            SizedBox(height: 10),
                            textCustom('Address','address',_address),
                            SizedBox(height: 10),
                            textCustom('Manufacturer','manufacturer',_mbrand),
                            SizedBox(height: 10),
                            textCustom('Brand name','brandname',_brandName),
                            SizedBox(height: 10),
                            textCustom('Brand number','brandnumber',_brandNumber),
                            SizedBox(height: 10),
                            customDate('Date of Vaccination', _dateVacc),
                            SizedBox(height: 10),
                            textCustom('Place of Vaccination','placevaccined',_placeVacined),
                            SizedBox(height: 10),
                            textCustom('Physician name','physician',_physicianName),
                            SizedBox(height: 10),
                            textCustom('License number','licensenumber',_licenseNumber),
                            SizedBox(height: 10),
                            customDate('Last RT PCR Date', _dateRT),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 120,
                            child: 
                              ElevatedButton(
                                style:
                                  ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                ),
                                onPressed: (){ Navigator.of(context).pop();}, 
                                child: 
                                  Text('Cancel',style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 13),),)
                                ),
                          ),

                          SizedBox(
                            width: 120,
                            child:ElevatedButton(
                                style:
                                  ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent),
                                  ),
                                onPressed: (){
                                  if(_formKey.currentState.validate()){
                                    try{
                                      UserData user = 
                                      UserData(
                                        auth.currentUser.uid, 
                                        _firstName.text, 
                                        _lastName.text, 
                                        _address.text, 
                                        _mbrand.text,
                                        _brandName.text, 
                                        int.parse(_brandNumber.text),
                                        _dateVacc.text, 
                                        _placeVacined.text, 
                                        _physicianName.text, 
                                        _dateRT.text, 
                                        _licenseNumber.text
                                        );
                                        if(user.updateInformationData(context)){
                                          Navigator.of(context).pop();
                                          Navigator.of(context).popAndPushNamed(AppRoutes.authPassenger);
                                        }
                                    }catch(e){
                                      print(_brandNumber.text);
                                    }
                                  }
                                  else{
                                    print('object');
                                  }
                                }, 
                                child: 
                                  Text('Submit',style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 13),),)
                              ),
                          ),
                        ],
                      )
                    ],
                  ),
              ),
            );
          },
        ),
      ),
    );
  }
    Icon iconStyle(String action){
    if(action == 'email') return Icon(Icons.email);
    if(action == 'password') return Icon(Icons.lock);
    if(action == 'lastname') return Icon(Icons.person);
    if(action == 'firstname') return Icon(Icons.person);
    if(action == 'address') return Icon(Icons.location_city);
    if(action == 'brandname') return Icon(Icons.branding_watermark);
    if(action == 'brandnumber') return Icon(Icons.format_list_numbered);
    if(action == 'physician') return Icon(Icons.local_hospital);
    if(action == 'placevaccined') return Icon(Icons.add_location);
    if(action == 'licensenumber') return Icon(Icons.credit_card);
    if(action == 'manufacturer') return Icon(Icons.business);
    return null;
  }

  void getValue(){
    setState(() {
      _firstName..text = widget.data['F_name'];
      _lastName..text = widget.data['L_name'];
      _address..text = widget.data['Address'];
      _mbrand..text = widget.data['M_Brand'];
      _brandName..text = widget.data['Brand_name'];
      _brandNumber..text = widget.data['Brand_number'].toString();
      _placeVacined..text = widget.data['Placed_vacined'];
      _physicianName..text = widget.data['Physician_name'];
      _dateVacc..text = widget.data['Date_of_Vaccination'];
      _dateRT..text = widget.data['RT_PCR_Date'];
      _licenseNumber..text = widget.data['License_no'];
    });
  }
  Widget textCustom(String labels, String action,TextEditingController controller){
    return 
      Padding(
        padding: const EdgeInsets.all(1),
        child: 
          Container(
            padding: EdgeInsets.only(left:20,right:20),
            child: TextFormField(
              controller: controller,
              style: GoogleFonts.poppins(textStyle: TextStyle(fontSize:16,),),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: labels,
                hintStyle: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey,fontSize:16),),
                suffixIcon: iconStyle(action),
              ),
              validator: (String value){ return ValidatorFunction(action).validate(value);},
              onChanged: (value){
              },
            ),
          ),
      );
  }

  Widget customDate(String labels, TextEditingController controller){
    return 
      Container(
        padding: EdgeInsets.only(left:20,right:20),
        child: TextFormField(
          controller: controller,
          style: GoogleFonts.poppins(textStyle: TextStyle(fontSize:16,),),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labels,
            hintStyle: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey,fontSize:16),),
            suffixIcon: Icon(Icons.calendar_today_sharp),
          ),
          onTap:(){
                  showDatePicker(
                    context: context, 
                    initialDate: DateTime.now(), 
                    firstDate: DateTime(2020), 
                    lastDate: DateTime.now()
                  ).then((value) =>
                      controller..text = convertDate(value),
                  );
              },

          validator: (String value){
                if (value.isEmpty) return 'Physician/Nurse Name is Required';
                if(value.length < 2) return 'Physician name should contain atleast 2 letter';
                return null;
          },
        ),
      );
  }

  Widget imageProfile(){
    return Stack(
      children: <Widget>[
        CircleAvatar( 
          radius: 75,
          backgroundImage: _imageFile == null?
          AssetImage('Images/dasha.png'):
          FileImage(File(_imageFile.path)),
        ),
        Positioned(bottom: 20, 
          right: 20,
          child: InkWell(
            onTap: (){
                showModalBottomSheet(context: context, builder: ((builder) => bottomSheet()));
            },
            child: Icon(Icons.camera_alt,
            color: Colors.white,
            size: 28.0,
            ),
          ),
        )          
      ]
    );
  }

  Widget bottomSheet(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal:  20, vertical:  20),
      height: 100,
      width: MediaQuery.of(context).size.width,
        child: Column(children: <Widget>[
          Text('Choose Profile Pic', style: TextStyle(
              fontSize: 20.0
          ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                // ignore: deprecated_member_use
                FlatButton.icon(onPressed: (){takePhoto(ImageSource.camera);}, icon: Icon(Icons.camera), label: Text('Upload Image')),
                // ignore: deprecated_member_use
                FlatButton.icon(onPressed: (){takePhoto(ImageSource.gallery);}, icon: Icon(Icons.image), label: Text('Open Gallery')),
                
            ]
          ),
        ]
        ),
    );
  }

  void takePhoto(ImageSource source) async{
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });

    if (pickedFile != null){
        //Upload to Firebase
        await _storage.ref()
        .child('imageFolder/imageName' )
        .putFile(File(pickedFile.path));

      } else {
        print('No Path Received');
      }
  }
}