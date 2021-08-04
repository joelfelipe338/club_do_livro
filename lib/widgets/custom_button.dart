import 'package:flutter/material.dart';


class CustomButton extends StatefulWidget {

  final Color buttonColor;
  final Color textColor;
  final Widget child;
  final Function() action;

  CustomButton(
    this.buttonColor,
    this.textColor,
    this.action,
      this.child);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.action,
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(widget.textColor),
            backgroundColor: MaterialStateProperty.all<Color>(widget.buttonColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),

                )
            )
        ),
        child: widget.child,

      ),
    );
  }
}
