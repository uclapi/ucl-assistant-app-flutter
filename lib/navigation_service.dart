import 'package:flutter/material.dart';

// [Get the Global Context in Flutter](https://stackoverflow.com/a/69299440)
// Used for redirecting user to login screen if an API request is ever unauthorised
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
