import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ucl_assistant/api/auth.dart';
import 'package:ucl_assistant/pages/login_page.dart';
import 'package:ucl_assistant/widgets/gradient_button.dart';
import 'package:ucl_assistant/widgets/header.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ucl_assistant/widgets/link.dart';
import 'package:ucl_assistant/widgets/loading.dart';
import 'dart:convert';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<Map<String, String>> getAllSettings() async {
    const storage = FlutterSecureStorage();
    final settings = await storage.readAll();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    settings['appVersion'] = packageInfo.version;
    return settings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: FutureBuilder(
          future: getAllSettings(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final feedbackTechnicalInformation = {
                'version': snapshot.data?['appVersion'],
                'platform': kIsWeb ? 'web' : Platform.operatingSystem,
                'upi': snapshot.data?['upi'],
              };

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Header(text: "User", topPadding: 0),
                      Text("Logged in as ${snapshot.data?['full_name']}"),
                      Text(
                          "Unique Person Identifier (UPI): ${snapshot.data?['upi']}"),
                      GradientButton(
                          onPressed: () => signOut().then((success) {
                                if (success) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                }
                              }),
                          width: 100,
                          child: const Text('Sign out?'))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Header(text: "App Info"),
                      Text("Version: ${snapshot.data?['appVersion']}"),
                      const Link(text: 'Website', url: 'https://uclapi.com'),
                      const Link(
                          text: 'Source Code',
                          url: 'https://github.com/uclapi/ucl-assistant-app'),
                      Link(
                          text: 'Send Us Feedback',
                          url:
                              "mailto:isd.apiteam@ucl.ac.uk?subject=Feedback%20about%20UCL%20Assistant&body=I've%20been%20using%20UCL%20Assistant%20and%20I%20just%20wanted%20to%20tell%20you%20...%0D%0A%0D%0ATechnical%20Information%3A${jsonEncode(feedbackTechnicalInformation)}"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Header(text: "Credits"),
                      Text(
                          'Originally created by Matt Bell (class of 2018) using the UCL API.\n'),
                      Text(
                          'Now managed by the UCL API team: a group of students working together within ISD to improve UCL by building a platform on top of UCL\'s digital services for students.\n'),
                      Text(
                          'Illustrations courtsey of the unDraw project, released under the MIT License'),
                    ],
                  ),
                ],
              );
            }

            return const Loading();
          },
        ),
      ),
    );
  }
}
