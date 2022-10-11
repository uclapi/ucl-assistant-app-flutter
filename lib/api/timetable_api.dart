import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ucl_assistant/constants.dart';
import 'package:ucl_assistant/models/timetable_entry.dart';

class TimetableAPI {
  const TimetableAPI({required this.client});
  final http.Client client;

  Future<Map<String, List<TimetableEntry>>> getPersonalTimetable(
      String week) async {
    final response =
        await client.get(Uri.parse('$API_WEEK_TIMETABLE_URL/?date=$week'));

    if (response.statusCode != 200) {
      throw "There was an error loading your timetable :(";
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    final Map<String, List<TimetableEntry>> timetableEntries = {};
    for (final date in decodedResponse['content']['timetable'].keys) {
      timetableEntries[date] = decodedResponse['content']['timetable'][date]
          .map<TimetableEntry>((entry) => _parseJsonTimetableEntry(entry))
          .toList();
    }

    return timetableEntries;
  }

  TimetableEntry _parseJsonTimetableEntry(Map json) {
    return TimetableEntry(
      startTime: json['start_time'],
      endTime: json['end_time'],
      moduleCode: json['module']['module_id'] ?? '',
      moduleName: json['module']['name'] ?? 'Timetabled event',
      lecturerEmail: json['module']['lecturer']['email'] ?? 'Unknown',
      lecturerName: json['module']['lecturer']['name'] ?? 'Unknown lecturer',
      delivery: json['instance']['delivery'] ?? {},
      location: json['location'] ?? {},
    );
  }
}
