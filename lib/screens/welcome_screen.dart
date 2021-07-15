import 'package:chat/screens/login_screen.dart';
import 'package:chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '/components/RoundedButton.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "/WelcomeScreen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "Logo",
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText("Flash Chat", textStyle: TextStyle( fontSize: 45.0, fontWeight: FontWeight.w900), colors: [ Colors.black ,Colors.redAccent, Colors.yellowAccent, Colors.purpleAccent, Colors.blueAccent ])
                  ],
                  isRepeatingAnimation: true,
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton( color: Colors.blueAccent, title: "Register", onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            }, ),
            RoundedButton( color: Colors.lightBlueAccent, title: "Log In", onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            }, ),
          ],
        ),
      ),
    );
  }
}

