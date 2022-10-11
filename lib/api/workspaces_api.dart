import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucl_assistant/constants.dart';
import 'package:ucl_assistant/models/study_space.dart';

class WorkspacesAPI {
  const WorkspacesAPI({required this.client});
  final http.Client client;

  Future<List<StudySpace>> getWorkspaces() async {
    final response = await client.get(Uri.parse(API_WORKSPACES_URL));

    if (response.statusCode != 200) {
      throw 'There was an error loading study spaces :(';
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return (decodedResponse['content'] as List)
        .map((room) => _parseJsonWorkspace(room))
        .toList();
  }

  Future<List<StudySpace>> getSummary() async {
    final response = await client.get(Uri.parse(API_WORKSPACES_SUMMARY_URL));

    if (response.statusCode != 200) {
      throw 'There was an error loading study spaces :(';
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return (decodedResponse['content'] as List)
        .map((room) => _parseJsonWorkspace(room))
        .toList();
  }

  Future<String> getLiveImage(int surveyId, int mapId) async {
    final response = await client.get(Uri.parse(
        '$API_LIVE_IMAGE_URL?map_id=$mapId&survey_id=$surveyId&circle_radius=200'));

    if (response.statusCode != 200) {
      throw 'There was an error getting a live image map :(';
    }

    final decodedResponse = utf8.decode(response.bodyBytes);
    return decodedResponse;
  }

  StudySpace _parseJsonWorkspace(Map json) {
    return StudySpace(
      name: json['name'],
      surveyid: json['id'],
      capacity: json['total'],
      occupied: json['occupied'],
      maps: json['maps'],
    );
  }
}
