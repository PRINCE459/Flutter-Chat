import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/components/RoundedButton.dart';
import '/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "RegisterationScreen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  String email = "";
  String password = "";
  var _auth = FirebaseAuth.instance;
  bool isSpinning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isSpinning,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "Logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter Your Email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter Your Password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton( color: Colors.blueAccent, title: "Register", onPressed: () async {
               setState(() {
                 isSpinning = true;
               });
               try {
                 final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                 if ( newUser != null ) {
                   Navigator.pop(context);
                 }
                 setState(() {
                   isSpinning = false;
                 });
               }
               catch (e) {
                 print(e);
               }

              }, ),
            ],
          ),
        ),
      ),
    );
  }
}
