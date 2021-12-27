import 'package:flutter/material.dart';
import 'package:my_todo/ui/themes.dart';

class ButtonWidgets extends StatelessWidget {
  String label;
  Function()? onTap;
  ButtonWidgets({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 120.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0), color: primaryClr),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
