import 'package:flutter/material.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/models/room.dart';
import 'package:ucl_assistant/widgets/error_message.dart';
import 'package:ucl_assistant/widgets/gradient_button.dart';
import 'package:ucl_assistant/widgets/header.dart';
import 'package:ucl_assistant/pages/search/rooms/room_list_item.dart';
import 'package:ucl_assistant/widgets/loading.dart';
import 'package:ucl_assistant/widgets/undraw_image.dart';

class SearchRoomsPage extends StatefulWidget {
  const SearchRoomsPage({super.key});

  @override
  State<SearchRoomsPage> createState() => _SearchRoomsPageState();
}

class _SearchRoomsPageState extends State<SearchRoomsPage> {
  List<Room> roomResults = [];
  bool isShowingEmptyRooms = false;
  bool loading = false;
  String? errorMessage;
  final textController = TextEditingController();

  void handleSubmit() {
    if (textController.text.length <= 3) return;
    API()
        .rooms()
        .search(textController.text)
        .then((results) => setState(() {
              roomResults = results;
              errorMessage = null;
            }))
        .catchError((e) => setState(() {
              errorMessage = e;
            }));
  }

  void handleFindEmptyRooms() {
    textController.clear();
    setState(() {
      loading = true;
    });

    final now = DateTime.now();
    final end = DateTime.now();
    end.add(const Duration(hours: 1));

    API()
        .rooms()
        .getEmptyRooms(now.toIso8601String(), end.toIso8601String())
        .then((results) => setState(() {
              roomResults = results;
              isShowingEmptyRooms = true;
              loading = false;
              errorMessage = null;
            }))
        .catchError((e) => setState(() {
              errorMessage = e;
              loading = false;
            }));
  }

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      if (isShowingEmptyRooms) {
        setState(() {
          isShowingEmptyRooms = false;
          roomResults.clear();
        });
      }
      handleSubmit();
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void resetState() {
    textController.clear();
    setState(() {
      roomResults.clear();
      isShowingEmptyRooms = false;
      errorMessage = null;
      loading = false;
    });
  }

  List<Widget> getListItems() {
    List<Widget> items = [];
    for (var i = 0; i < roomResults.length; i++) {
      final room = roomResults[i];
      items.add(RoomListItem(room));
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
                const Header(text: "Rooms", bold: true),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: false,
                        controller: textController,
                        onSubmitted: (_) => handleSubmit(),
                        decoration: InputDecoration(
                          isDense: true,
                          suffixIcon: IconButton(
                            onPressed: resetState,
                            icon: const Icon(Icons.clear),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xffeaeaea),
                          hintText: "Search for a room or building name...",
                        ),
                      ),
                    ),
                  ],
                ),
                GradientButton(
                  onPressed: handleFindEmptyRooms,
                  height: 50,
                  child: const Text('or find an empty room?'),
                ),
                if (isShowingEmptyRooms) ...[
                  const Text('Rooms vacant for the next hour:')
                ],
                if (loading) ...[
                  const Loading()
                ] else if (errorMessage != null) ...[
                  ErrorMessage(message: errorMessage!)
                ] else
                  Expanded(
                    child: roomResults.isEmpty
                        ? const UndrawImage('scrum_board')
                        : ListView(children: getListItems()),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
