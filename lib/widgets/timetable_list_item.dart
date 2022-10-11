import 'package:flutter/material.dart';
import 'package:ucl_assistant/helpers.dart';
import 'package:ucl_assistant/models/timetable_entry.dart';

class TimetableListItem extends StatelessWidget {
  const TimetableListItem({super.key, required this.timetableEntry});
  final TimetableEntry timetableEntry;

  @override
  Widget build(BuildContext context) {
    double? latitude =
        double.tryParse(timetableEntry.location['coordinates']?['lat'] ?? '');
    double? longitude =
        double.tryParse(timetableEntry.location['coordinates']?['lng'] ?? '');

    return GestureDetector(
      onTap: () => openMaps(
        latitude: latitude,
        longitude: longitude,
        name: timetableEntry.location['name'],
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(timetableEntry.moduleName),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 3, 0, 0),
                      child: Text(
                        timetableEntry.moduleCode,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    )
                  ],
                ),
                Text(
                    '${timetableEntry.startTime} - ${timetableEntry.endTime} • ${timetableEntry.lecturerName}',
                    style: Theme.of(context).textTheme.caption),
                Text(timetableEntry.location['name'] ?? 'Online',
                    style: Theme.of(context).textTheme.caption)
              ],
            ),
            if (timetableEntry.location['name'] != null) ...[
              Icon(
                Icons.directions_outlined,
                color: Theme.of(context).iconTheme.color,
                size: 25,
              )
            ]
          ],
        ),
      ),
    );
  }
}
