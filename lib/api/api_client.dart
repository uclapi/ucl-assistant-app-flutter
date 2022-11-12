import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ucl_assistant/api/auth.dart';
import 'package:ucl_assistant/navigation_service.dart';
import 'package:ucl_assistant/pages/login_page.dart';

class APIClient extends http.BaseClient {
  final http.Client _inner;
  final String _token;

  APIClient(this._inner, this._token);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['Authorization'] = 'Bearer $_token';
    final response = await _inner.send(request).catchError((err, stack) {
      Sentry.captureException(err, stackTrace: stack);
      throw 'There was an error fetching this information';
    });

    if (response.statusCode == 401) {
      signOut().then((success) {
        if (success) {
          Navigator.pushAndRemoveUntil(
              NavigationService.navigatorKey.currentContext!,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false);
        }
      });
    }
    return response;
  }
}
