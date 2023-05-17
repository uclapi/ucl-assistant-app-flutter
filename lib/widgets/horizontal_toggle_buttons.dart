import 'package:flutter/material.dart';

class HorizontalToggleButtons extends StatelessWidget {
  const HorizontalToggleButtons({
    super.key,
    required this.label,
    required this.items,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final List<String> items;
  final List<bool> selected;
  final Function(int index) onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label),
        const Padding(padding: EdgeInsets.all(4)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Scrollbar(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: onPressed,
                  constraints:
                      const BoxConstraints(minHeight: 55, maxHeight: 55),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  fillColor: const Color(0xff1B998B),
                  selectedColor: Colors.white,
                  color: Colors.black,
                  textStyle: const TextStyle(fontSize: 13),
                  isSelected: selected,
                  children: items
                      .map((s) => Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(s),
                          ))
                      .toList()),
            ),
          ),
        ),
      ],
    );
  }
}
