import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header(
      {super.key,
      required this.text,
      this.bold = false,
      this.topPadding = 15,
      this.bottomPadding = 10,
      this.color});

  final String text;
  final bool bold;
  final double topPadding;
  final double bottomPadding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, topPadding, 0, bottomPadding),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 25,
          color: color ?? Theme.of(context).textTheme.bodySmall!.color,
          fontWeight: bold ? FontWeight.bold : FontWeight.w300,
        ),
      ),
    );
  }
}
