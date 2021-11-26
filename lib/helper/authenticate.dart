import 'package:flutter/material.dart';
import 'package:zipzop/pages/singin_page.dart';
import 'package:zipzop/pages/singup_page.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSingIn = true;

  _toggleView() {
    setState(() {
      showSingIn = !showSingIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSingIn ? SingInPage(_toggleView) : SingUpPage(_toggleView);
  }
}
