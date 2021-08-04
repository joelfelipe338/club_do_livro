import 'package:flutter/material.dart';


SnackBar snack(String text, Color color, int seconds){
  return SnackBar(
    content:  Container(
        height: 20.0,
        child:  Center(child: Text(text, style: TextStyle(color: Colors.white),),)
    ),
    backgroundColor: color,
    duration: Duration(seconds: seconds),
  );
}