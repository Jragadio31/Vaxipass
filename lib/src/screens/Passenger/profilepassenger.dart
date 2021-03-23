import 'dart:async';
import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vacpass_app/src/screens/Passenger/updateprofile.dart';

class Profile extends StatefulWidget{
  @override 
  ProfileView createState() => ProfileView();
}

class ProfileView extends State<Profile>{
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Map data;  

  @override
  Widget build(BuildContext context){
    return 
      Container(
        child: 
          FutureBuilder<DocumentSnapshot>( 
            future: users.doc(auth.currentUser.uid).get(),
            builder: (context, snapshot){
                
              if(!snapshot.hasData)
                  Timer(Duration(seconds: 2),() => print(''));
              
              if(snapshot.hasData) {
                  data = snapshot.data.data();
                  print('');
                }
              return Container(
                child: !snapshot.hasData ? animate() : Scaffold(
                  appBar: 
                    AppBar(
                      title: Text('Profile', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 28),)), 
                      automaticallyImplyLeading: false, 
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                  body: 
                    SafeArea( 
                      child: LayoutBuilder(
                        builder: (context, constrainst){ 
                          return ListView(
                            children: [
                              SizedBox(height: 160, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [imageProfile()],),),
                              Column(
                                children: [
                                  userInformation(data['F_name']+' '+data['L_name'],' Name'),
                                  userInformation(data['Address'], ' Address'),
                                  userInformation(data['M_Brand'], ' Manufacturer'),
                                  userInformation(data['Brand_name'], ' Brand name'),
                                  userInformation(data['Brand_number'].toString(), ' Brand number'),
                                  userInformation(convertDate(data['Date_of_Vaccination']), ' Date vaccined'),
                                  userInformation(data['Placed_vacined'], ' Place Vaccined'),
                                  userInformation(data['Physician_name'], ' Physician'),
                                  userInformation(data['License_no'], ' License no.'),
                                  userInformation(convertDate(data['RT_PCR_Date']), ' Last RT-PCR'),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center, 
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        height: 40,
                                        child:
                                          ElevatedButton(
                                            style:
                                              ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent),
                                            ),
                                            onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => Update(data)));}, 
                                            child: 
                                              Text('Update Profile',
                                                style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 13),),)
                                            ), 
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                ),
              );
            },
          ),
      );
  }

  String convertDate(String dateVaccined){
    var exactDate = dateVaccined.split('/');
    return exactMonth(int.parse(exactDate[0])) +' '+ exactDate[1].toString() + ' ' + exactDate[2].toString();
  }

 String exactMonth(int month){
   String monthname;

   switch(month){
     case 1: monthname = 'January'; break;
     case 2: monthname = 'February'; break;
     case 3: monthname = 'March'; break;
     case 4: monthname = 'April'; break;
     case 5: monthname = 'May'; break;
     case 6: monthname = 'June'; break;
     case 7: monthname = 'July'; break;
     case 8: monthname = 'August'; break;
     case 9: monthname = 'September'; break;
     case 10: monthname = 'October'; break;
     case 11: monthname = 'November'; break;
     case 12: monthname = 'December'; break;
   }
   return monthname;
 }
  
  Widget userInformation(String value, String label){
    return 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.pinkAccent,fontSize: 18),)),
          Text(label,style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.grey,fontSize: 10),),),
        ],
      );
  }

  Widget animate(){
    return SpinKitFadingCircle(color: Colors.pink.shade300,);
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
