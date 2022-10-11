import 'package:flutter/material.dart';
import 'package:ucl_assistant/pages/search/people/person_search_page.dart';
import 'package:ucl_assistant/pages/search/rooms/room_search_page.dart';
import 'package:ucl_assistant/pages/search/study_spaces/study_space_search_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: const TabBarView(children: [
          SearchStudySpacesPage(),
          SearchPeoplePage(),
          SearchRoomsPage(),
        ]),
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: PreferredSize(
            preferredSize: const Size(200, 50),
            child: TabBar(
              tabs: [Icons.school, Icons.people, Icons.meeting_room]
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
