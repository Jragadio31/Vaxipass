import 'package:flutter/material.dart';
import 'ValidatorFunction.dart';
// ignore: must_be_immutable
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
    if(widget.action == 'email') return Icon(Icons.email);
    if(widget.action == 'password') return Icon(Icons.lock);
    if(widget.action == 'lastname') return Icon(Icons.person);
    if(widget.action == 'firstname') return Icon(Icons.person);
    if(widget.action == 'address') return Icon(Icons.location_city);
    if(widget.action == 'brandname') return Icon(Icons.branding_watermark);
    if(widget.action == 'brandnumber') return Icon(Icons.format_list_numbered);
    if(widget.action == 'physician') return Icon(Icons.local_hospital);
    if(widget.action == 'placevaccined') return Icon(Icons.add_location);
    if(widget.action == 'licensenumber') return Icon(Icons.credit_card);
    if(widget.action == 'manufacturer') return Icon(Icons.business);
    return null;
  }

  @override
  Widget build(BuildContext context){
    return TextFormField(
    obscureText: widget.obs,
    controller: widget._controller,
    style: TextStyle(
      color: Colors.black87,
    ),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.only(top: 14),
      prefixIcon: iconStyle(),
      hintText: widget.label,
      hintStyle: TextStyle(
        color: Colors.black38
      ),
      suffixIcon: widget.action == "password" ? viewIcon() : null,
    ),
    validator: (value) {
      return ValidatorFunction(widget.action).validate(value);
    },
  );
  }
  IconButton viewIcon (){
    return IconButton(
      onPressed:  (){setState(() {widget.obs = !widget.obs; });},
      icon: widget.obs ? Icon(Icons.visibility_off) : Icon(Icons.visibility)
    );
  }
}