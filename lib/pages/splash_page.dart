import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zipzop/helper/authenticate.dart';
import 'package:zipzop/pages/chat_%20room_page.dart';

class SplashPage extends StatefulWidget {
  final bool logged;

  const SplashPage(this.logged, {Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState(logged: this.logged);
}

class _SplashPageState extends State<SplashPage> {
  bool logged;

  _SplashPageState({required this.logged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              'assets/images/logo.png',
              width: 100,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.teal),
              strokeWidth: 5.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      print(this.logged);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  this.logged ? ChatRoomPage() : Authenticate()));
    });
    super.initState();
  }
}
