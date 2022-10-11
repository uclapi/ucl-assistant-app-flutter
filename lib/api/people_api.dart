import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucl_assistant/constants.dart';
import 'package:ucl_assistant/models/person.dart';

class PeopleAPI {
  const PeopleAPI({required this.client});
  final http.Client client;

  Future<List<Person>> search(String query) async {
    final response = await client.get(Uri.parse(
        '$API_SEARCH_PEOPLE_URL/?query=${Uri.encodeComponent(query)}'));

    if (response.statusCode != 200) {
      throw 'There was an error performing your search :(';
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return (decodedResponse['content']['people'] as List)
        .map((room) => _parseJsonPerson(room))
        .toList();
  }

  Person _parseJsonPerson(Map json) {
    return Person(
        name: json['name'],
        department: json['department'],
        email: json['email']);
  }
}
