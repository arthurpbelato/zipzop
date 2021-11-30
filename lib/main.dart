import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zipzop/helper/authenticate.dart';
import 'package:zipzop/helper/util.dart';
import 'package:zipzop/pages/chat_%20room_page.dart';
import 'package:zipzop/pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffEFEFEF),
        primarySwatch: Colors.teal,
      ),
      home: SplashPage(userLoggedIn),
    );
  }

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await Util.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userLoggedIn = value!;
      });
    });
  }
}