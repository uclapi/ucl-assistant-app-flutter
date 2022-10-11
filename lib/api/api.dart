import 'package:http/http.dart' as http;
import 'package:ucl_assistant/api/api_client.dart';
import 'package:ucl_assistant/api/people_api.dart';
import 'package:ucl_assistant/api/rooms_api.dart';
import 'package:ucl_assistant/api/timetable_api.dart';
import 'package:ucl_assistant/api/workspaces_api.dart';

class API {
  late http.BaseClient _client;
  late String _token;

  static final API _instance = API._internal();
  factory API() {
    return _instance;
  }
  API._internal();

  void setToken(String token) {
    _token = token;
    _client = APIClient(http.Client(), _token);
  }

  PeopleAPI people() {
    return PeopleAPI(client: _client);
  }

  RoomsAPI rooms() {
    return RoomsAPI(client: _client);
  }

  TimetableAPI timetable() {
    return TimetableAPI(client: _client);
  }

  WorkspacesAPI workspaces() {
    return WorkspacesAPI(client: _client);
  }
}
