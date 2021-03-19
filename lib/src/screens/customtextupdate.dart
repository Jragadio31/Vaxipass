import 'package:flutter/material.dart';
import 'package:vacpass_app/src/screens/ValidatorFunction.dart';

class Custom extends StatefulWidget{
  final String action;
  final TextEditingController _controller;
  final TextInputType keyType;
  final String label;
  final String initial;

  Custom(this._controller,this.keyType,this.label, this.action, this.initial);

  @override 
  CustomText createState() => CustomText();
}


class CustomText extends State<Custom>{
  // CustomText(this._controller, this.keyType, this.label, this.action, this.initial);

  Icon iconStyle(){
    if(widget.action == 'lastname') return Icon(Icons.person, color: Colors.purple[300]);
    if(widget.action == 'firstname') return Icon(Icons.person, color: Colors.purple[300]);
    if(widget.action == 'address') return Icon(Icons.location_city, color: Colors.purple[300]);
    if(widget.action == 'brandname') return Icon(Icons.branding_watermark, color: Colors.purple[300]);
    if(widget.action == 'brandnumber') return Icon(Icons.format_list_numbered, color: Colors.purple[300]);
    if(widget.action == 'physician') return Icon(Icons.local_hospital, color: Colors.purple[300]);
    if(widget.action == 'placevaccined') return Icon(Icons.add_location, color: Colors.purple[300]);
    if(widget.action == 'licensenumber') return Icon(Icons.credit_card, color: Colors.purple[300]);
    if(widget.action == 'manufacturer') return Icon(Icons.business, color: Colors.purple[300]);
    return null;
  }

  @override
  Widget build(BuildContext context){
    return 
      TextFormField(
        controller: widget._controller,
        validator: (String value){
          return ValidatorFunction(widget.action).validate(value);
        },
        style: TextStyle(
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: iconStyle(),
          hintText: widget.label,
          hintStyle: TextStyle(
            color: Colors.black38
          )
        ),
        initialValue: widget.initial,
      );
  }
}
