import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/constants.dart';

Future<String?> authenticate() async {
  final String result = await FlutterWebAuth.authenticate(
      url: "$API_AUTH_URL?return=$URL_SCHEME:/", callbackUrlScheme: URL_SCHEME);

  final Uri uri = Uri.parse(result);

  const storage = FlutterSecureStorage();
  for (final key in [
    'token',
    'department',
    'email',
    'upi',
    'full_name',
    'apiToken',
    'token'
  ]) {
    await storage.write(key: key, value: uri.queryParameters[key]);
  }

  final String? token = uri.queryParameters['token'];
  if (token != null) API().setToken(token);
  return token;
}

Future<bool> login() async {
  final String? token = await authenticate();
  if (token != null) {
    API().setToken(token);
    return true;
  }
  return false;
}

Future<bool> signOut() async {
  const storage = FlutterSecureStorage();
  try {
    await storage.deleteAll();
  } catch (err, stack) {
    Sentry.captureException(err, stackTrace: stack);
    return false;
  }
  return true;
}
