import 'package:flutter/material.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/models/study_space.dart';
import 'package:ucl_assistant/widgets/error_message.dart';
import 'package:ucl_assistant/widgets/gradient_button.dart';
import 'package:ucl_assistant/widgets/header.dart';
import 'package:ucl_assistant/widgets/stat.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudySpaceDetail extends StatelessWidget {
  const StudySpaceDetail({super.key, required this.studySpace});
  final StudySpace studySpace;

  void fetchAndShowLiveSeatMap(int mapId, BuildContext context) async {
    final String result = await API()
        .workspaces()
        .getLiveImage(studySpace.surveyid, mapId)
        .catchError((e) => e);

    showModalBottomSheet(
      enableDrag: false,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: result.isEmpty
              ? const ErrorMessage(
                  message: 'There was an error getting a live image map',
                  flexible: false,
                )
              : InteractiveViewer(
                  maxScale: 6,
                  child: SvgPicture.string(
                    result.replaceFirst(RegExp('<svg '),
                        '<svg width="2000px" height="1000px" '),
                  ),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Flexible(child: Header(text: studySpace.name, bold: true)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stat(
                  num: studySpace.capacity - studySpace.occupied,
                  label: 'seats available',
                ),
                Stat(num: studySpace.occupied, label: 'seats occupied')
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(text: 'Areas'),
                ...studySpace.maps.map(
                  (e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e['name']),
                      Text(
                          "${e['total'] - e['occupied']}/${e['total']} seats available"),
                      GradientButton(
                        child: const Text('View live seat map'),
                        onPressed: () =>
                            fetchAndShowLiveSeatMap(e['id'], context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
