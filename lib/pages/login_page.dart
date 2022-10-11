import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ucl_assistant/api/auth.dart';
import 'package:ucl_assistant/pages/home_page.dart';
import 'package:ucl_assistant/widgets/gradient_button.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Color(0xff1B998B), Color(0xff4BB3FD)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Image(image: AssetImage('assets/ucl.png'), width: 400),
            const Text(
              'One app to manage your life at UCL.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Column(
              children: [
                GradientButton(
                  onPressed: () => login().then((success) {
                    if (success) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                          (route) => false);
                    }
                  }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage('assets/uclapi.png'),
                        height: 40,
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                      Text('Sign in with UCL'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text:
                            "By signing into this app, you agree to UCL API's ",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'terms & conditions.',
                        style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(Uri.parse(
                                'https://github.com/uclapi/ucl-assistant-app/blob/master/TERMS.md'));
                          },
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
