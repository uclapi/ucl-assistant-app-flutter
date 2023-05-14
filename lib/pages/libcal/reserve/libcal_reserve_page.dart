import 'package:flutter/material.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/models/libcal.dart';
import 'package:ucl_assistant/widgets/error_message.dart';
import 'package:ucl_assistant/widgets/header.dart';
import 'package:ucl_assistant/pages/libcal/reserve/libcal_location_list_item.dart';
import 'package:ucl_assistant/widgets/loading.dart';

class LibcalReservePage extends StatefulWidget {
  const LibcalReservePage({super.key});

  @override
  State<LibcalReservePage> createState() => _LibcalReservePageState();
}

class _LibcalReservePageState extends State<LibcalReservePage> {
  bool loading = true;
  String? errorMessage;
  List<LibcalLocation> locationResults = [];
  final textController = TextEditingController();

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
                const Header(text: "Reserve a study space", bold: true),
                const Text('Choose a location:'),
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
