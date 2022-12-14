import 'package:flutter/material.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/models/study_space.dart';
import 'package:ucl_assistant/widgets/error_message.dart';
import 'package:ucl_assistant/widgets/header.dart';
import 'package:ucl_assistant/pages/search/study_spaces/study_space_list_item.dart';
import 'package:ucl_assistant/widgets/loading.dart';

class SearchStudySpacesPage extends StatefulWidget {
  const SearchStudySpacesPage({super.key});

  @override
  State<SearchStudySpacesPage> createState() => _SearchStudySpacesPageState();
}

class _SearchStudySpacesPageState extends State<SearchStudySpacesPage> {
  String search = '';
  bool loading = true;
  String? errorMessage;
  List<StudySpace> studySpaceResults = [];
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
        .workspaces()
        .getSummary()
        .then((workspaces) => setState(() {
              studySpaceResults = workspaces;
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
    for (var i = 0; i < studySpaceResults.length; i++) {
      final studySpace = studySpaceResults[i];

      if (textController.text.isNotEmpty &&
          !studySpace.name
              .toString()
              .toLowerCase()
              .contains(textController.text.toLowerCase())) {
        continue;
      }

      items.add(StudySpaceListItem(studySpace));
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
                const Header(text: "Study Spaces", bold: true),
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
                          hintText: "Search for a study space...",
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
