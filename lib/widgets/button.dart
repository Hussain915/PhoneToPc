import 'package:flutter/material.dart';
import 'package:shop/colors.dart';

class Button extends StatelessWidget {
  final String title;
  final onPressed;

  Button({@required this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: appBarColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              '$title',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
