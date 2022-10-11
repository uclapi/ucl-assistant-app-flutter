import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucl_assistant/constants.dart';
import 'package:ucl_assistant/models/room.dart';

class RoomsAPI {
  const RoomsAPI({required this.client});
  final http.Client client;

  Future<Map> getBookings(String roomid, String siteid, String date) async {
    final response = await client.get(Uri.parse(
        '$API_ROOMBOOKINGS_URL/?roomid=$roomid&siteid=$siteid&date=$date'));

    if (response.statusCode != 200) {
      throw 'There was an error loading room bookings :(';
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return decodedResponse;
  }

  Future<List<Room>> getEmptyRooms(
      String startDateTime, String endDateTime) async {
    final response = await client.get(Uri.parse(
        '$API_EMPTY_ROOMS_URL/?startDateTime=$startDateTime&endDateTime=$endDateTime'));

    if (response.statusCode != 200) {
      throw 'There was an error loading empty rooms :(';
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return (decodedResponse['content']['free_rooms'] as List)
        .map((room) => _parseJsonRoom(room))
        .toList();
  }

  Future<Map> getEquipment(String roomid, String siteid) async {
    final response = await client
        .get(Uri.parse('$API_EQUIPMENT_URL/?roomid=$roomid&siteid=$siteid'));

    if (response.statusCode != 200) {
      throw 'There was an error loading room equipment :(';
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return decodedResponse;
  }

  Future<List<Room>> getAllRooms() async {
    final response = await client.get(Uri.parse(API_ROOMS_URL));

    if (response.statusCode != 200) {
      throw 'There was an error loading rooms :(';
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return (decodedResponse['content']['rooms'] as List)
        .map((room) => _parseJsonRoom(room))
        .toList();
  }

  Future<List<Room>> search(String query) async {
    final response =
        await client.get(Uri.parse('$API_SEARCH_ROOMS_URL/?query=$query'));

    if (response.statusCode != 200) {
      throw 'There was an error searching for rooms :(';
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return (decodedResponse['content']['rooms'] as List)
        .map((room) => _parseJsonRoom(room))
        .toList();
  }

  Room _parseJsonRoom(Map json) {
    return Room(
      name: json['roomname'],
      address: json['location']['address'].join('\n'),
      classification: json['classification_name'],
      capacity: json['capacity'],
      siteid: json['siteid'],
      roomid: json['roomid'],
      longitude:
          double.tryParse(json['location']?['coordinates']?['lng'] ?? ''),
      latitude: double.tryParse(json['location']?['coordinates']?['lat'] ?? ''),
    );
  }
}
