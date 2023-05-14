import 'package:flutter/material.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/constants.dart';
import 'package:ucl_assistant/helpers.dart';
import 'package:ucl_assistant/models/libcal.dart';
import 'package:ucl_assistant/widgets/error_message.dart';
import 'package:ucl_assistant/widgets/libcal_bookable_space_list_item.dart';
import 'package:ucl_assistant/widgets/libcal_filter_button.dart';
import 'package:ucl_assistant/widgets/libcal_filter_panel.dart';
import 'package:ucl_assistant/widgets/loading.dart';
import 'package:collection/collection.dart';

class BookLibcalLocationPage extends StatefulWidget {
  const BookLibcalLocationPage({super.key, required this.location});
  final LibcalLocation location;

  @override
  State<BookLibcalLocationPage> createState() => _BookLibcalLocationPageState();
}

class _BookLibcalLocationPageState extends State<BookLibcalLocationPage> {
  String search = '';

  bool singleSpace = true;
  int dayOffset = 0;
  String time = getClosestHalfHour();

  Future<List<Widget>> getSeats() async {
    DateTime selectedDate = DateTime.now().add(Duration(days: dayOffset));
    String date = getDateString(selectedDate);

    List<LibcalSpace> spaceResults = singleSpace
        ? await API().libcal().getSeats(widget.location.id, date)
        : await API().libcal().getGroupSpaces(widget.location.id, date);

    List<Widget> items = [];
    for (var i = 0; i < spaceResults.length; i++) {
      final space = spaceResults[i];

      if (time != LIBCAL_BOOK_FILTER_ANYTIME) {
        final contiguousSlot = space.contiguousSlots
            .firstWhereOrNull((slot) => slot.contains(time));

        if (contiguousSlot != null) {
          items.add(LibcalBookableSpaceListItem(
            space: space,
            date: date,
            startTime: contiguousSlot.from,
            endTime: contiguousSlot.to,
          ));
        }
      } else {
        items.add(LibcalBookableSpaceListItem(space: space, date: date));
      }
    }

    return items;
  }

  void showFilterPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: LibcalFilterPanel(
            singleSpace: singleSpace,
            dayOffset: dayOffset,
            time: time,
            onPressed: (newSingleSpace, newDayOffset, newTime) {
              setState(() {
                singleSpace = newSingleSpace;
                dayOffset = newDayOffset;
                time = newTime;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now().add(Duration(days: dayOffset));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.location.name,
          style: const TextStyle(color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          children: [
            GestureDetector(
              onTap: showFilterPanel,
              child: Wrap(
                spacing: 20,
                children: [
                  LibcalFilterButton(
                    text: singleSpace ? 'Single Space' : 'Group Space',
                    icon: Icons.people,
                  ),
                  LibcalFilterButton(
                    text:
                        '${selectedDate.day}${getDaySuffix(selectedDate.day)}',
                    icon: Icons.date_range,
                  ),
                  LibcalFilterButton(
                    text: time,
                    icon: Icons.access_time,
                  ),
                  const Icon(
                    Icons.tune,
                    color: Color(0xff1B998B),
                  )
                ],
              ),
            ),
            FutureBuilder(
              future: getSeats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Loading();
                }

                if (snapshot.hasError) {
                  return ErrorMessage(message: snapshot.error.toString());
                }

                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Text(
                        'There are no slots available that match your filters');
                  }

                  return Expanded(
                      child: ListView(children: snapshot.data as List<Widget>));
                }

                return const Loading();
              },
            )
          ],
        ),
      ),
    );
  }
}
