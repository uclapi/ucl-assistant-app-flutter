import 'package:flutter/material.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/helpers.dart';
import 'package:ucl_assistant/models/libcal.dart';
import 'package:ucl_assistant/pages/libcal/bookings/libcal_booking_list_item.dart';
import 'package:ucl_assistant/widgets/error_message.dart';
import 'package:ucl_assistant/widgets/header.dart';
import 'package:ucl_assistant/widgets/loading.dart';

class LibcalBookingsPage extends StatefulWidget {
  const LibcalBookingsPage({super.key});

  @override
  State<LibcalBookingsPage> createState() => _LibcalBookingsPageState();
}

class _LibcalBookingsPageState extends State<LibcalBookingsPage> {
  bool loading = true;
  String? errorMessage;
  List<LibcalBooking> bookingResults = [];

  void fetchBookings(bool forceUpdate) {
    setState(() => loading = true);
    API()
        .libcal()
        .getPersonalBookings(forceUpdate)
        .then((bookings) => setState(() {
              bookingResults = bookings;
              loading = false;
              errorMessage = null;
            }))
        .catchError((e) => setState(() {
              errorMessage = e.toString();
              loading = false;
            }));
  }

  @override
  void initState() {
    super.initState();
    fetchBookings(false);
  }

  List<Widget> getListItems() {
    Set<String> dates = {};
    List<Widget> items = [];
    for (var i = 0; i < bookingResults.length; i++) {
      final booking = bookingResults[i];
      final date = DateTime.parse(booking.slot.from);
      final dateString = getDateString(date);
      if (!dates.contains(dateString)) {
        items.add(Header(text: '${getDayName(date.weekday)}, $dateString'));
      }
      dates.add(dateString);
      items.add(LibcalBookingListItem(
        booking: booking,
        refreshBookings: () => fetchBookings(true),
      ));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: true,
          child: Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(text: "Upcoming bookings", bold: true),
                if (loading) ...[
                  const Loading()
                ] else if (errorMessage != null) ...[
                  ErrorMessage(message: errorMessage!)
                ] else
                  Expanded(child: ListView(children: getListItems()))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
