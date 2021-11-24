import 'package:flutter/material.dart';

PreferredSizeWidget appBarMain(BuildContext context){
  return AppBar(
    title: Text('ZipZop'),
  );
}

InputDecoration textFieldInputDecoration(String hint){
  return InputDecoration(
    hintText: hint,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
  );
}

TextStyle linkTextStyle(){
  return TextStyle(
    color: Colors.teal,
  );
}

TextStyle mediumTextStyle(){
  return TextStyle(
    color: Color(0xff005850),
    fontSize: 17
  );
}