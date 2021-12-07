import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zipzop/helper/authenticate.dart';
import 'package:zipzop/helper/constants.dart';
import 'package:zipzop/helper/util.dart';
import 'package:zipzop/pages/search_page.dart';
import 'package:zipzop/services/auth.dart';
import 'package:zipzop/services/database_methods.dart';
import 'package:zipzop/widgets/widget.dart';

import 'conversation_screen.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);



  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream<QuerySnapshot>? chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return ChatRoomTile(
              snapshot.data!.docs[index].get('chatroomId')
                  .toString().replaceAll('_', '')
                  .replaceAll(Constants.myName, ''),
              snapshot.data!.docs[index].get('chatroomId')
            );
          },
        ) : Container();
      }
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await Util.getUsernameSharedPreference())!;
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
    setState(() {
    });
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
      body: chatRoomList(),
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

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId: chatRoomId)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}",
                style: mediumTextStyle()),
            ),
            SizedBox(width: 8,),
            Text(userName, style: mediumTextStyle(),)
          ],
        ),
      ),
    );
  }
}
