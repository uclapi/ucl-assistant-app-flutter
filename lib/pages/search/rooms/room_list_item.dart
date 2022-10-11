import 'package:flutter/material.dart';
import 'package:ucl_assistant/models/room.dart';
import 'package:ucl_assistant/pages/search/rooms/room_detail.dart';

class RoomListItem extends StatelessWidget {
  const RoomListItem(this.room, {super.key});
  final Room room;

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
              child: RoomDetail(room: room),
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
              Icon(Icons.meeting_room,
                  color: Theme.of(context).iconTheme.color),
              const Padding(padding: EdgeInsets.all(5)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(room.name, overflow: TextOverflow.ellipsis),
                    Text(room.classification,
                        style: Theme.of(context).textTheme.caption)
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
