import 'package:flutter/material.dart';
import 'package:ucl_assistant/models/libcal.dart';
import 'package:ucl_assistant/pages/libcal/reserve/libcal_location_page.dart';

class LibcalLocationListItem extends StatelessWidget {
  const LibcalLocationListItem({super.key, required this.location});
  final LibcalLocation location;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LibcalLocationPage(location: location)),
          );
        },
        child: Material(
          elevation: 5,
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
            child: Row(
              children: [
                Icon(
                  Icons.school_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                const Padding(padding: EdgeInsets.all(5)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          child: Text(location.name,
                              overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_right,
                  color: Theme.of(context).iconTheme.color,
                  size: 30,
                )
              ],
            ),
          ),
        ));
  }
}
