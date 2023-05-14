import 'package:flutter/material.dart';

class LibcalFilterButton extends StatelessWidget {
  const LibcalFilterButton({super.key, required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Color(0xff1B998B), spreadRadius: 1.5),
        ],
      ),
      child: Wrap(
        spacing: 2,
        children: [
          Icon(icon, size: 22),
          Text(
            text,
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.9),
          ),
        ],
      ),
    );
  }
}
