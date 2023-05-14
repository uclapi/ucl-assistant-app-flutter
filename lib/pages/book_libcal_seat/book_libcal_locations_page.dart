import 'package:flutter/material.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/models/libcal.dart';
import 'package:ucl_assistant/widgets/error_message.dart';
import 'package:ucl_assistant/widgets/header.dart';
import 'package:ucl_assistant/pages/book_libcal_seat/libcal_location_list_item.dart';
import 'package:ucl_assistant/widgets/loading.dart';

class BookLibcalLocationsPage extends StatefulWidget {
  const BookLibcalLocationsPage({super.key});

  @override
  State<BookLibcalLocationsPage> createState() =>
      _BookLibcalLocationsPageState();
}

class _BookLibcalLocationsPageState extends State<BookLibcalLocationsPage> {
  String search = '';
  bool loading = true;
  String? errorMessage;
  List<LibcalLocation> locationResults = [];
  final textController = TextEditingController();

  void handleSubmit() {
    setState(() {
      search = textController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    API()
        .libcal()
        .getLocations()
        .then((locations) => setState(() {
              locationResults = locations;
              loading = false;
              errorMessage = null;
            }))
        .catchError((e) => setState(() {
              errorMessage = e.toString();
              loading = false;
            }));

    textController.addListener(() {
      handleSubmit();
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  List<Widget> getListItems() {
    List<Widget> items = [];
    for (var i = 0; i < locationResults.length; i++) {
      final location = locationResults[i];

      if (textController.text.isNotEmpty &&
          !location.name
              .toString()
              .toLowerCase()
              .contains(textController.text.toLowerCase())) {
        continue;
      }

      items.add(LibcalLocationListItem(location: location));
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
                const Header(text: "Book a study space", bold: true),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        onSubmitted: (_) => handleSubmit(),
                        decoration: InputDecoration(
                          isDense: true,
                          suffixIcon: IconButton(
                            onPressed: () {
                              textController.clear();
                            },
                            icon: const Icon(Icons.clear),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xffeaeaea),
                          hintText: "Search for a location...",
                        ),
                      ),
                    ),
                  ],
                ),
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
