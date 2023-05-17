import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ucl_assistant/api/api.dart';
import 'package:ucl_assistant/constants.dart';
import 'package:ucl_assistant/navigation_service.dart';
import 'package:ucl_assistant/pages/home_page.dart';
import 'package:ucl_assistant/pages/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  await SentryFlutter.init((options) {
    options.dsn = kDebugMode ? '' : SENTRY_DSN;
    options.tracesSampleRate = 1.0;
    options.enableAutoSessionTracking = true;
    options.debug = kDebugMode;
  }, appRunner: () => runApp(const MyApp()));
}

Future<String?> getUserToken() async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'token');
  return token;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;

  @override
  void initState() {
    super.initState();
    getUserToken().then((t) {
      if (t != null) {
        API().setToken(t);
        setState(() {
          token = t;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UCL Assistant',
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.white,
          onPrimary: Colors.white,
          secondary: Color(0xff1b998b),
          onSecondary: Color(0xff1b998b),
          error: Colors.black,
          onError: Colors.white,
          background: Colors.black,
          onBackground: Colors.white,
          surface: Colors.black,
          onSurface: Colors.black,
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Color(0xff666785), fontSize: 14),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
        ),
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      home: token != null ? const HomePage() : const LoginPage(),
    );
  }
}
