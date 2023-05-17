import 'package:flutter/material.dart';
import 'package:ucl_assistant/constants.dart';
import 'package:ucl_assistant/helpers.dart';
import 'package:ucl_assistant/widgets/gradient_button.dart';
import 'package:ucl_assistant/widgets/header.dart';

List<String> generateTimeStrings() {
  List<String> times = [LIBCAL_BOOK_FILTER_ANYTIME];
  for (var i = 0; i < 24; i++) {
    final String hour = i.toString().padLeft(2, '0');
    times.add('$hour:00');
    times.add('$hour:30');
  }
  return times;
}

class LibcalFilterPanel extends StatefulWidget {
  const LibcalFilterPanel(
      {super.key,
      required this.singleSpace,
      required this.dayOffset,
      required this.time,
      required this.onPressed});

  final bool singleSpace;
  final int dayOffset;
  final String time;
  final Function(bool singleSpace, int dayOffset, String time) onPressed;

  @override
  State<LibcalFilterPanel> createState() => _LibcalFilterPanelState();
}

class _LibcalFilterPanelState extends State<LibcalFilterPanel> {
  bool singleSpace = true;
  int dayOffset = 0;
  String time = LIBCAL_BOOK_FILTER_ANYTIME;

  final DateTime today = DateTime.now();
  final DateTime todayPlusOne = DateTime.now().add(const Duration(days: 1));
  final DateTime todayPlusTwo = DateTime.now().add(const Duration(days: 2));
  final times = generateTimeStrings();

  @override
  void initState() {
    super.initState();
    singleSpace = widget.singleSpace;
    dayOffset = widget.dayOffset;
    time = widget.time;
  }

  @override
  Widget build(BuildContext context) {
    final dayStrings = [
      'Today (${today.day}${getDaySuffix(today.day)})',
      'Tomorrow (${todayPlusOne.day}${getDaySuffix(todayPlusOne.day)})',
      'Day after (${todayPlusTwo.day}${getDaySuffix(todayPlusTwo.day)})'
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Header(text: 'Filters'),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Category'),
              ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    setState(() {
                      singleSpace = index == 0;
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  fillColor: const Color(0xff1B998B),
                  selectedColor: Colors.white,
                  color: Colors.black,
                  textStyle: const TextStyle(fontSize: 13),
                  isSelected: [
                    singleSpace,
                    !singleSpace
                  ],
                  children: const [
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Text('Single Study Space')),
                    Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Text('Group Study Space / Meeting Room')),
                  ]),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Date'),
              ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    setState(() {
                      dayOffset = index;
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  fillColor: const Color(0xff1B998B),
                  selectedColor: Colors.white,
                  color: Colors.black,
                  textStyle: const TextStyle(fontSize: 13),
                  isSelected: [dayOffset == 0, dayOffset == 1, dayOffset == 2],
                  children: dayStrings
                      .map((s) => Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(s),
                          ))
                      .toList()),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Time'),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: ToggleButtons(
                          direction: Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              time = times[index];
                            });
                          },
                          constraints: const BoxConstraints(
                              minHeight: 55, maxHeight: 55),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          fillColor: const Color(0xff1B998B),
                          selectedColor: Colors.white,
                          color: Colors.black,
                          textStyle: const TextStyle(fontSize: 13),
                          isSelected: times.map((t) => t == time).toList(),
                          children: times
                              .map((s) => Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Text(s),
                                  ))
                              .toList()),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        GradientButton(
          onPressed: () => widget.onPressed(singleSpace, dayOffset, time),
          height: 35,
          child: const Text('Save'),
        )
      ],
    );
  }
}
