import 'package:flutter/material.dart';
import 'package:ucl_assistant/models/person.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonListItem extends StatelessWidget {
  const PersonListItem(this.person, {super.key});
  final Person person;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => launchUrl(Uri.parse('mailto:${person.email}')),
      child: Material(
        elevation: 5,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: Container(
          height: 60,
          padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
          child: Row(
            children: [
              Icon(Icons.person, color: Theme.of(context).iconTheme.color),
              const Padding(padding: EdgeInsets.all(5)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(person.name, overflow: TextOverflow.ellipsis),
                    Text(person.department,
                        style: Theme.of(context).textTheme.caption)
                  ],
                ),
              ),
              Icon(
                Icons.send,
                color: Theme.of(context).iconTheme.color,
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
