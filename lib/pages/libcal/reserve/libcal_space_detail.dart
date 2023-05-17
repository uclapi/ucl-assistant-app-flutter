import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/helpers.dart';
import 'package:ucl_assistant/models/libcal.dart';
import 'package:ucl_assistant/widgets/gradient_button.dart';
import 'package:ucl_assistant/widgets/header.dart';
import 'package:collection/collection.dart';
import 'package:ucl_assistant/widgets/horizontal_toggle_buttons.dart';

class LibcalSpaceDetail extends StatefulWidget {
  const LibcalSpaceDetail({
    super.key,
    required this.space,
    required this.date,
    this.startTime,
    this.latestEndTime,
  });

  final LibcalSpace space;
  final String date;
  final String? startTime;
  final String? latestEndTime;

  @override
  State<LibcalSpaceDetail> createState() => _LibcalSpaceDetailState();
}

class _LibcalSpaceDetailState extends State<LibcalSpaceDetail> {
  String chosenFromTime = '';
  String chosenToTime = '';

  Future<bool> makeBooking() async {
    final bool success = await API().libcal().bookSpace(
          spaceId: widget.space.spaceId,
          date: widget.date,
          from: chosenFromTime,
          to: chosenToTime,
          seatId: widget.space is LibcalSeat
              ? (widget.space as LibcalSeat).seatId
              : null,
        );

    if (success) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Booking Successful',
        desc: 'Please check your email for your booking confirmation.',
        btnOkOnPress: () => Navigator.pop(context),
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Booking Failed',
        desc:
            'There was an error booking your slot. The availability may have changed. Please try again.',
        btnOkOnPress: () => Navigator.pop(context),
        btnOkColor: Colors.red,
        btnOkText: 'Close',
      ).show();
    }

    return success;
  }

  List<String> getFromTimes() {
    List<String> times = [];
    if (widget.startTime != null && widget.latestEndTime != null) {
      double start = convertTimeStringToNumericDivision(widget.startTime!);
      double end = convertTimeStringToNumericDivision(widget.latestEndTime!);
      for (double i = start; i < end; i++) {
        times.add(convertNumericDivisionToTimeString(i));
      }
    } else {
      for (final slot in widget.space.contiguousSlots) {
        for (double i = slot.fromDivision; i < slot.toDivision; i++) {
          times.add(convertNumericDivisionToTimeString(i));
        }
      }
    }

    return times;
  }

  List<String> getToTimes(String from) {
    List<String> times = [];
    double start = convertTimeStringToNumericDivision(from);

    if (widget.startTime != null && widget.latestEndTime != null) {
      double end = convertTimeStringToNumericDivision(widget.latestEndTime!);
      for (double i = start + 1; i <= end; i++) {
        times.add(convertNumericDivisionToTimeString(i));
      }
    } else {
      final slot = widget.space.contiguousSlots
          .firstWhereOrNull((s) => s.contains(from));

      if (slot != null) {
        for (double i = start + 1; i <= slot.toDivision; i++) {
          times.add(convertNumericDivisionToTimeString(i));
        }
      }
    }

    return times;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Header(text: widget.space.name, bold: true)),
                Wrap(
                  children: [
                    Icon(
                      widget.space.isAccessible
                          ? Icons.accessible
                          : Icons.not_accessible,
                      color: widget.space.isAccessible
                          ? Colors.green
                          : Colors.grey,
                    ),
                    Icon(
                      widget.space.isPowered ? Icons.power : Icons.power_off,
                      color: widget.space.isPowered ? Colors.grey : Colors.red,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.space.description.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      // Strip HTML tags, spaces, final new line; replace double new lines with single new lines
                      widget.space.description
                          .replaceAll(RegExp(r"<[^>]*>|&nbsp;|\n$"), '')
                          .replaceAll(RegExp(r'\r\n\r\n'), '\n'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                ],
                if (widget.space.image.isNotEmpty) ...[
                  Image.network(
                    // URLs beginning with "//" are by-default treated as "file://", but we know it's a network resource
                    widget.space.image.replaceFirst(RegExp(r'^//'), 'https://'),
                    height: 300,
                  )
                ],
                const Header(text: 'Choose your slot'),
                HorizontalToggleButtons(
                  label: 'From:',
                  items: getFromTimes(),
                  selected:
                      getFromTimes().map((t) => t == chosenFromTime).toList(),
                  onPressed: (index) {
                    setState(() {
                      chosenFromTime = getFromTimes()[index];
                      chosenToTime = '';
                    });
                  },
                ),
                if (chosenFromTime.isNotEmpty) ...[
                  HorizontalToggleButtons(
                    label: 'To:',
                    items: getToTimes(chosenFromTime),
                    selected: getToTimes(chosenFromTime)
                        .map((t) => t == chosenToTime)
                        .toList(),
                    onPressed: (index) {
                      setState(() {
                        chosenToTime = getToTimes(chosenFromTime)[index];
                      });
                    },
                  ),
                ],
                if (chosenFromTime.isNotEmpty && chosenToTime.isNotEmpty) ...[
                  GradientButton(
                    onPressed: makeBooking,
                    height: 50,
                    child: Text('Book $chosenFromTime - $chosenToTime'),
                  ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}
