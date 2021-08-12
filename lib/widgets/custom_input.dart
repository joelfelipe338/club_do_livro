import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {

  final TextEditingController controller;
  final String name;
  final IconData icon;
  final bool obscure;
  final IconButton iconButton;
  final String Function(String) validacao ;

  CustomInput({this.controller, this.name, this.icon,this.obscure = false,this.validacao, this.iconButton});

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validacao ?? (value){
        if(value.isEmpty){
          return "Campo obrigatorio";
        }else{
          return null;
        }
      },
      style: TextStyle(color: Colors.white),
      obscureText: widget.obscure,
      controller: widget.controller,
      decoration: InputDecoration(
        suffixIcon: widget.iconButton != null ? widget.iconButton : null,
        labelText: widget.name,
        labelStyle: TextStyle(
          color: Colors.white
        ),
        prefixIcon: Icon(
          widget.icon,
          color: Colors.white,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          )
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white
            )
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white
            )
        ),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white
            )
        ),

      ),
    );
  }
}
