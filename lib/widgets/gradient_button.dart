import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.height,
      this.width,
      this.borderRadius = 8,
      this.padding = 5});

  final Function() onPressed;
  final Widget child;
  final double? height;
  final double? width;
  final double borderRadius;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Color(0xff1B998B), Color(0xff4BB3FD)],
          ),
        ),
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}
