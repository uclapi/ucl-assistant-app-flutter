import 'package:flutter/material.dart';
import 'package:ucl_assistant/helpers.dart';
import 'package:ucl_assistant/models/timetable_entry.dart';
import 'package:ucl_assistant/widgets/header.dart';
import 'package:ucl_assistant/widgets/timetable_list_item.dart';

class TimetableDay extends StatelessWidget {
  const TimetableDay(
      {super.key, required this.date, required this.timetableEntries});

  final DateTime date;
  final List<TimetableEntry> timetableEntries;

  @override
  Widget build(BuildContext context) {
    final DateTime startOfToday = getStartOfToday();
    final bool isToday = DateUtils.isSameDay(startOfToday, date);
    final bool isInPast = date.compareTo(startOfToday) < 0;

    return Opacity(
      opacity: isInPast ? 0.6 : 1,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          border: Border(
            left: isToday
                ? BorderSide(
                    color: Theme.of(context).colorScheme.secondary, width: 4)
                : BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              text: formatTimetableDate(date),
              bottomPadding: 0,
              topPadding: 0,
              bold: isToday,
              color: Colors.black,
            ),
            ...timetableEntries.map(
              (entry) => TimetableListItem(timetableEntry: entry),
            ),
            if (timetableEntries.isEmpty) ...[const Text('Nothing today!')]
          ],
        ),
      ),
    );
  }
}
