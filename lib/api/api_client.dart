import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

class APIClient extends http.BaseClient {
  final http.Client _inner;
  final String _token;

  APIClient(this._inner, this._token);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_token';
    return _inner.send(request).catchError((err, stack) {
      Sentry.captureException(err, stackTrace: stack);
      throw 'There was an error fetching this information';
    });
  }
}
