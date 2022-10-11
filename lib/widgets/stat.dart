import 'package:flutter/material.dart';

class Stat extends StatelessWidget {
  const Stat({super.key, required this.num, required this.label});

  final int num;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$num',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.caption),
      ],
    );
  }
}
