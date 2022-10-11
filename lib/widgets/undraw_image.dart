import 'package:flutter/material.dart';

class UndrawImage extends StatelessWidget {
  const UndrawImage(this.image, {super.key});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Image(image: AssetImage('assets/undraw/$image.png'));
  }
}
