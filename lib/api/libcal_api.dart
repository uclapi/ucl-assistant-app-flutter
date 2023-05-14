import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ucl_assistant/constants.dart';
import 'package:ucl_assistant/helpers.dart';
import 'package:ucl_assistant/models/libcal.dart';

class LibcalAPI {
  const LibcalAPI({required this.client});
  final http.Client client;

  Future<List<LibcalLocation>> getLocations() async {
    final response = await client.get(Uri.parse(API_LIBCAL_LOCATIONS_URL));

    if (response.statusCode != 200) {
      throw 'There was an error loading study spaces :(';
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return (decodedResponse['content']['locations'] as List)
        .map((location) => _parseJsonLocation(location))
        .toList();
  }

  Future<List<LibcalSpace>> getSeats(int locationId, String date) async {
    final response = await client.get(
        Uri.parse('$API_LIBCAL_LOCATIONS_URL/$locationId/seats?date=$date'));
    if (response.statusCode != 200) {
      throw 'There was an error loading available seats :(';
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return (decodedResponse['content']['seats'] as List)
        .map((seat) => _parseJsonSeat(seat))
        .toList();
  }

  Future<List<LibcalGroupSpace>> getGroupSpaces(
      int locationId, String date) async {
    final response = await client.get(Uri.parse(
        '$API_LIBCAL_LOCATIONS_URL/$locationId/groupSpaces?date=$date'));
    if (response.statusCode != 200) {
      throw 'There was an error loading available seats :(';
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return (decodedResponse['content']['spaces'] as List)
        .map((space) => _parseJsonSpace(space))
        .toList();
  }

  Future<bool> bookSpace({
    required int spaceId,
    required String date,
    required String from,
    required String to,
    int? seatId,
  }) async {
    final fromString = formatLibcalDateString(DateTime.parse('$date $from'));
    final toString = formatLibcalDateString(DateTime.parse('$date $to'));

    final response = await client.post(
      Uri.parse('$API_LIBCAL_SPACES_URL/$spaceId/reserve'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'from': fromString,
        'to': toString,
        'seat_id': seatId,
      }),
    );

    if (response.statusCode != 200) {
      throw 'There was an error reserving your space :(';
    }

    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse);
    return decodedResponse['content']['ok'];
  }

  LibcalLocation _parseJsonLocation(Map json) {
    return LibcalLocation(
      id: json['lid'],
      name: json['name'],
    );
  }

  LibcalSeat _parseJsonSeat(Map json) {
    return LibcalSeat(
      seatId: json['id'],
      spaceId: json['space_id'],
      name: json['name'],
      description: json['description'],
      isAccessible: json['is_accessible'],
      isPowered: json['is_powered'],
      image: json['image'],
      availability: json['availability'],
    );
  }

  LibcalGroupSpace _parseJsonSpace(Map json) {
    return LibcalGroupSpace(
      spaceId: json['id'],
      name: json['name'],
      description: json['description'],
      isAccessible: json['is_accessible'],
      isPowered: json['is_powered'],
      image: json['image'],
      availability: json['availability'],
      capacity: json['capacity'],
    );
  }
}
