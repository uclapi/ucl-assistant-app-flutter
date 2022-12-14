import 'package:flutter/material.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/models/person.dart';
import 'package:ucl_assistant/widgets/error_message.dart';
import 'package:ucl_assistant/widgets/header.dart';
import 'package:ucl_assistant/pages/search/people/person_list_item.dart';
import 'package:ucl_assistant/widgets/undraw_image.dart';

class SearchPeoplePage extends StatefulWidget {
  const SearchPeoplePage({super.key});

  @override
  State<SearchPeoplePage> createState() => _SearchPeoplePageState();
}

class _SearchPeoplePageState extends State<SearchPeoplePage> {
  List<Person> peopleResults = [];
  String? errorMessage;
  final textController = TextEditingController();

  void handleSubmit() {
    if (textController.text.length <= 3) return;
    API()
        .people()
        .search(textController.text)
        .then((results) => setState(() {
              peopleResults = results;
              errorMessage = null;
            }))
        .catchError((e) => setState(() {
              errorMessage = e.toString();
            }));
  }

  @override
  void initState() {
    super.initState();
    textController.addListener(() => handleSubmit());
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
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
                const Header(text: "People", bold: true),
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
                              setState(() => peopleResults.clear());
                            },
                            icon: const Icon(Icons.clear),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xffeaeaea),
                          hintText: "Search for a name or email...",
                        ),
                      ),
                    ),
                  ],
                ),
                if (errorMessage != null) ...[
                  ErrorMessage(message: errorMessage!)
                ] else
                  Expanded(
                    child: peopleResults.isEmpty
                        ? const UndrawImage('people_search')
                        : ListView(
                            children: peopleResults
                                .map((person) => PersonListItem(person))
                                .toList(),
                          ),
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
}
