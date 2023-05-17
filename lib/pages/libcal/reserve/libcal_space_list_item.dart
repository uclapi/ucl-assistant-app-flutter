import 'package:flutter/material.dart';
import 'package:ucl_assistant/helpers.dart';
import 'package:ucl_assistant/models/libcal.dart';
import 'package:ucl_assistant/pages/libcal/reserve/libcal_space_detail.dart';

class LibcalSpaceListItem extends StatelessWidget {
  const LibcalSpaceListItem(
      {super.key,
      required this.space,
      required this.date,
      required this.onDismiss,
      this.startTime,
      this.endTime});

  final LibcalSpace space;
  final String date;
  final Function() onDismiss;
  final String? startTime;
  final String? endTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: LibcalSpaceDetail(
                space: space,
                date: date,
                startTime: startTime,
                latestEndTime: endTime),
          );
        },
      ).whenComplete(onDismiss),
      child: Container(
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.only(bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(space.name)),
                Wrap(
                  children: [
                    Icon(
                      space.isAccessible
                          ? Icons.accessible
                          : Icons.not_accessible,
                      size: 20,
                      color: space.isAccessible ? Colors.green : Colors.grey,
                    ),
                    Icon(
                      space.isPowered ? Icons.power : Icons.power_off,
                      size: 20,
                      color: space.isPowered ? Colors.grey : Colors.red,
                    ),
                  ],
                ),
              ],
            ),
            Text(
                startTime != null && endTime != null
                    ? 'available ${extractTimeString(startTime!)} - ${extractTimeString(endTime!)}'
                    : 'available ${space.contiguousSlots.join(', ')}',
                style: Theme.of(context).textTheme.caption),
          ],
        ),
      ),
    );
  }
}
