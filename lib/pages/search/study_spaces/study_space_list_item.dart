import 'package:flutter/material.dart';
import 'package:ucl_assistant/models/study_space.dart';
import 'package:ucl_assistant/pages/search/study_spaces/study_space_detail.dart';

class StudySpaceListItem extends StatelessWidget {
  const StudySpaceListItem(this.studySpace, {super.key});
  final StudySpace studySpace;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return FractionallySizedBox(
              heightFactor: 0.9,
              child: StudySpaceDetail(studySpace: studySpace),
            );
          },
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
                    Text(studySpace.name, overflow: TextOverflow.ellipsis),
                    Text(
                      '${studySpace.capacity - studySpace.occupied}/${studySpace.capacity} seats available',
                      style: Theme.of(context).textTheme.caption,
                    )
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
      ),
    );
  }
}
