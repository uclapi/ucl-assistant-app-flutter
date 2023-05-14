import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ucl_assistant/pages/book_libcal_seat/book_libcal_locations_page.dart';
import 'package:ucl_assistant/pages/search/search_page.dart';
import 'package:ucl_assistant/pages/settings_page.dart';
import 'package:ucl_assistant/pages/timetable_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            TimetablePage(),
            BookLibcalLocationsPage(),
            SearchPage(),
            SettingsPage()
          ],
        ),
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light),
        ),
        bottomNavigationBar: const SizedBox(
          height: 60,
          child: TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            tabs: [
              Tab(
                  icon: Icon(Icons.calendar_month, size: 25),
                  text: 'Timetable'),
              Tab(icon: Icon(Icons.desk, size: 25), text: 'Book'),
              Tab(icon: Icon(Icons.search, size: 25), text: 'Search'),
              Tab(icon: Icon(Icons.settings, size: 25), text: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}
