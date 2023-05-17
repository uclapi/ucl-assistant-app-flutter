import 'package:flutter/material.dart';
import 'package:ucl_assistant/pages/libcal/bookings/libcal_bookings_page.dart';
import 'package:ucl_assistant/pages/libcal/reserve/libcal_reserve_page.dart';

class LibcalPage extends StatefulWidget {
  const LibcalPage({super.key});

  @override
  State<LibcalPage> createState() => _LibcalPageState();
}

class _LibcalPageState extends State<LibcalPage> {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: const TabBarView(children: [
          LibcalReservePage(),
          LibcalBookingsPage(),
        ]),
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: PreferredSize(
            preferredSize: const Size(200, 50),
            child: TabBar(
              tabs: [Icons.desk, Icons.list]
                  .map((icon) => Tab(
                        icon: Icon(
                          icon,
                          size: 20,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
