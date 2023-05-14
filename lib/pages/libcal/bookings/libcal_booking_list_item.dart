import 'package:flutter/material.dart';
import 'package:ucl_assistant/models/libcal.dart';

class LibcalBookingListItem extends StatelessWidget {
  const LibcalBookingListItem({super.key, required this.booking});
  final LibcalBooking booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0xff1b998b)),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
      margin: const EdgeInsets.fromLTRB(5, 8, 5, 8),
      child: Row(
        children: [
          Flexible(
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${booking.seatName} (${booking.locationName})'),
                  Text('Check-in code: ${booking.checkInCode}'),
                  Text(booking.slot.toString()),
                  Text(
                    booking.status,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
