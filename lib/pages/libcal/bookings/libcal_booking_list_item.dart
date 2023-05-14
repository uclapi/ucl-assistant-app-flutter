import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/models/libcal.dart';
import 'package:ucl_assistant/widgets/gradient_button.dart';

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
                if (booking.cancelledDate == null) ...[
                  GradientButton(
                      child: const Text('Cancel?'),
                      onPressed: () async {
                        final success = await API()
                            .libcal()
                            .cancelBooking(booking.bookingId);

                        if (success) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            title: 'Booking Cancelled',
                            btnOkOnPress: () => Navigator.pop(context),
                          ).show();
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: 'Cancellation Failed',
                            desc:
                                'There was an error cancelling your slot. Please try again.',
                            btnOkOnPress: () => Navigator.pop(context),
                            btnOkColor: Colors.red,
                            btnOkText: 'Close',
                          ).show();
                        }
                      })
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
