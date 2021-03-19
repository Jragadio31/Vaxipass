import 'package:flutter/material.dart';
import 'package:vacpass_app/src/screens/ValidatorFunction.dart';

class CustomTextField extends StatefulWidget{

  final String action;
  final TextEditingController _controller;
  final TextInputType keyType;
  final String label;
  bool obs;

  CustomTextField(this._controller, this.keyType, this.label, this.action, this.obs);
  @override 
  CustomInputField createState()=> CustomInputField();
}
class CustomInputField extends State<CustomTextField>{
  Icon iconStyle(){
    if(widget.action == 'email') return Icon(Icons.email, color: Colors.purple[300]);
    if(widget.action == 'password') return Icon(Icons.lock, color: Colors.purple[300]);
    if(widget.action == 'lastname') return Icon(Icons.person, color: Colors.purple[300]);
    if(widget.action == 'firstname') return Icon(Icons.person, color: Colors.purple[300]);
    if(widget.action == 'address') return Icon(Icons.location_city, color: Colors.purple[300]);
    if(widget.action == 'brandname') return Icon(Icons.branding_watermark, color: Colors.purple[300]);
    if(widget.action == 'brandnumber') return Icon(Icons.format_list_numbered, color: Colors.purple[300]);
    if(widget.action == 'physician') return Icon(Icons.local_hospital, color: Colors.purple[300]);
    if(widget.action == 'placevaccined') return Icon(Icons.add_location, color: Colors.purple[300]);
    if(widget.action == 'licensenumber') return Icon(Icons.credit_card, color: Colors.purple[300]);
    if(widget.action == 'manufacturer') return Icon(Icons.business, color: Colors.purple[300]);
  }
  // Icon suffixIcon(){
  //   if(widget.action == 'password') return Icon(Icons.visibility, color: Colors.purple[300]);
  // }

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // CustomText(this.label),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
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
            obscureText: widget.obs,
            controller: widget._controller,
            validator: (String value){
              return ValidatorFunction(widget.action).validate(value);
            },
            style: TextStyle(
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: iconStyle(),
              hintText: widget.label,
              hintStyle: TextStyle(
                color: Colors.black38
              ),
              suffixIcon: widget.action == "password" ? viewIcon() : null,
            ),
          ),
         )
      ],
    );
  }

  IconButton viewIcon (){
    return IconButton(
      onPressed:  (){setState(() {widget.obs = !widget.obs; });},
      icon: widget.obs ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
    );
  }
}