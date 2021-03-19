import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../route.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../customtextupdate.dart';





class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();


 final auth = FirebaseAuth.instance;
 final db = FirebaseFirestore.instance;
 final _storage = FirebaseStorage.instance;


 TextEditingController confirmpassword = TextEditingController();
 TextEditingController firstName = TextEditingController();
 TextEditingController lastName = TextEditingController();
 TextEditingController address = TextEditingController();
 TextEditingController mbrand = TextEditingController();
 TextEditingController brandName = TextEditingController();
 TextEditingController brandNumber = TextEditingController();
 TextEditingController placeVacined = TextEditingController();
 TextEditingController physicianName = TextEditingController();
 TextEditingController licenseNumber = TextEditingController();


 final TextInputType keytext = TextInputType.text;

 CollectionReference users = FirebaseFirestore.instance.collection('VacPass');



  Widget imageProfile(){
    return Stack(
      children: <Widget>[
        CircleAvatar( 
                      radius: 82.0,
                      backgroundImage: _imageFile == null?
                      AssetImage('Images/user.png'):
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
              FlatButton.icon(onPressed: (){takePhoto(ImageSource.camera);}, icon: Icon(Icons.camera), label: Text('Upload Image')),
              FlatButton.icon(onPressed: (){takePhoto(ImageSource.gallery);}, icon: Icon(Icons.image), label: Text('Open Gallery')),
              
          ]
        )
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


Future<void> updateUser(String ln,
                        String fn,
                        String add,
                        String mb,
                        String b, 
                        String bnum, 
                        String dv, 
                        String pv,
                        String pn,
                        String lin,
                        String las) {
    
    

  return users
    .doc(auth.currentUser.uid)
    .update({
           "L_name": ln,
           "F_name": fn,
           "Address": add,
           "M_Brand": mb,
           "Brand_name": b,
           "Brand_number": bnum,
           "Date_of_Vaccination": dv,
           "Placed_vacined": pv ,
           "Physician_name":pn ,
           "License_no": lin,
           "RT_PCr_Date": las,
      })
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));
}


  @override
  Widget build(BuildContext context) {
    return Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: db.collection('users').doc(auth.currentUser.uid).snapshots(),
          builder: (context, snapshot) {
          print('reload');
          Map data = snapshot.data.data();
          
          
          String _lastname;
          String _firstname;
          String _address;
          String _mbrand;
          String _brandname;
          String _brandnumber;
          String _datevac;
          String _placevaccined;
          String _physicianname;
          String _licensenumber;
          String _lastrtpcr;

           _lastname = data["L_name"];
           _firstname = data["F_name"];
           _address = data["Address"];
           _mbrand = data["M_Brand"];
           _brandname = data["Brand_name"];
           _brandnumber = data["Brand_number"].toString();
           _datevac= data['Date_of_Vaccination'];
           _placevaccined = data["Placed_vacined"];
           _physicianname = data["Physician_name"];
           _licensenumber= data["License_no"];
           _lastrtpcr = data['RT_PCR_Date'];

            return Container(
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Profile',
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 28
                  ),
                  ),
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading:false
                ),
                body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width ,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                          gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              ]
                            )
                          ),
                    child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(15),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    
                    children: <Widget>[
                      SizedBox(height: 30),
                      imageProfile(),
                      SizedBox(height: 30),
                      Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    
                                ),
                                height: 25,
                                width: 300,
                                child: Text(
                                'Name: ' + data['F_name'] + ' ' + data['L_name'],
                                style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    
                                ),
                                height: 25,
                                width: 300,
                                child: Text(
                                'Address: ' + data['Address'],
                                style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              ), 
                              SizedBox(height: 10),
                              Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                             
                                          ),
                                          height: 25,
                                          width: 300,
                                          child: Text(
                                          'Manufacturer Brand: ' + data['M_Brand'],
                                          style: TextStyle(
                                            color: Colors.pink,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,                                        
                                          ),
                                          height: 25,
                                          width: 300,
                                          child: Text(
                                          'Brand Name: '+ data['Brand_name'],
                                          style: TextStyle(
                                            color: Colors.pink,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                            
                                              
                                          ),
                                          height: 25,
                                          width: 300,
                                          child: Text(
                                          'Brand Number: ' + data['Brand_number'].toString(),
                                          style: TextStyle(
                                            color: Colors.pink,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                             
                                          ),
                                          height: 25,
                                          width: 300,
                                          child: Text(
                                          'Date of Vaccination: ' + data['Date_of_Vaccination'],
                                          style: TextStyle(
                                            color: Colors.pink,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                              ),
                            
                              SizedBox(height: 10),
                              Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          
                                          
                                ),
                                height: 25,
                                width: 300,
                                child: Text(
                                'Place of Vacination:' + data['Placed_vacined'],
                                style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    
                                ),
                                height: 25,
                                width: 300,
                                child: Text(
                                'Physician Name:' + data['Physician_name'],
                                style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    
                                ),
                                height: 25,
                                width: 300,
                                child: Text(
                                'License Number:' + data['License_no'],
                                style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    
                                ),
                                height: 25,
                                width: 300,
                                child: Text(
                                'Date of Last RT-PCR: ' + data['RT_PCR_Date'],
                                style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              ), 
                              SizedBox(height: 10),    
                              Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                                  ElevatedButton(
                                      child: Text('Log out'),
                                      onPressed:(){
                                          auth.signOut();
                                          Navigator.of(context).pop(AppRoutes.authLogin);
                                      },
                                  ),
                                  ElevatedButton(
                                      child: Text('Edit Profile'),
                                       onPressed: () {
                                          showDialog(context: context, builder: (context){
                                                return Dialog(
                                                  child: Form(
                                                      child: Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      height: MediaQuery.of(context).size.height,
                                                      child:  Center(
                                                          child: SingleChildScrollView(
                                                            child: Column(
                                                               mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                                    Custom(firstName, keytext, 'First name', "firstname",_firstname),
                                                                    Custom(lastName, keytext, 'Last name', "lastname",_lastname),
                                                                    Custom(address, keytext, 'Address', "address",_address),
                                                                    Custom(mbrand, keytext, 'Manufacturer', "manufacturer",_mbrand),
                                                                    Custom(brandName, keytext, 'Brand name', "brandname",_brandname),
                                                                    Custom(brandNumber, keytext, 'Brand number', "brandnumber",_brandnumber),
                                                                    // CustomText(, keytext, 'Date of Vaccination', "datevaccined",_brandnumber), IMplement changes
                                                                    Custom(placeVacined, keytext, 'Place Vaccined', "placevaccined",_placevaccined),
                                                                    Custom(physicianName, keytext, 'Physician name', "physician",_physicianname),
                                                                    Custom(licenseNumber, keytext, 'License number', "licensenumber",_licensenumber),
                                                                    TextFormField(
                                                                      decoration: const InputDecoration(
                                                                        icon: Icon(Icons.person),
                                                                        labelText: 'Date of Last RT-PCR',
                                                                      ),
                                                                      initialValue: _lastrtpcr,
                                                                    ),
                                                                    Row(

                                                                      children: [
                                                                        ElevatedButton(
                                                                            child: Text('Save'),
                                                                            onPressed:(){
                                                                                auth.signOut();
                                                                                Navigator.of(context).pop(AppRoutes.authLogin);
                                                                            },
                                                                        ),
                                                                      ],
                                                                    ), 
                                                                    ElevatedButton(
                                                                        child: Text('Cancel'),
                                                                        onPressed:(){
                                                                            
                                                                        },
                                                                    ),
                                                            ],
                                                            ) ,
                                                           ),
                                                        ),
                                                    ),
                                                  ) 
                                              );
                                          });
                                        },   
                                  )
                                ],
                              )
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
       )
      );
         }
        ),
      );
  }
}