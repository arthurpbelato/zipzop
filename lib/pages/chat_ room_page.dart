import 'package:flutter/material.dart';
import 'package:zipzop/helper/authenticate.dart';
import 'package:zipzop/helper/constants.dart';
import 'package:zipzop/helper/util.dart';
import 'package:zipzop/pages/search_page.dart';
import 'package:zipzop/services/auth.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);



  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  AuthMethods authMethods = new AuthMethods();


  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await Util.getUsernameSharedPreference())!;
  }

  _singMeOut() {
    authMethods.singOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Authenticate()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ZipZop'),
        actions: [
          GestureDetector(
            onTap: () => _singMeOut(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage()));
        },
      ),
    );
  }
}
