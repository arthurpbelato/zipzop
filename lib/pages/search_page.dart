import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zipzop/exception/exception_handler.dart';
import 'package:zipzop/helper/constants.dart';
import 'package:zipzop/helper/util.dart';
import 'package:zipzop/pages/conversation_page.dart';
import 'package:zipzop/services/database_methods.dart';
import 'package:zipzop/widgets/widget.dart';

import 'conversation_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String? _myName = '';
  QuerySnapshot? searchSnapshot;

  createChatRoomAndStartConversation(BuildContext context, String username) {
    if(username != Constants.myName){
      List<String> users = [username, Constants.myName];

      String chatroomId = getChatRoomId(username, Constants.myName);

      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'chatroomId': chatroomId
      };

      DatabaseMethods().addChatRoom(chatRoomMap, chatroomId);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ConversationScreen(
                chatRoomId: chatroomId,
      )));
    }else{
      ExceptionHandler.handleException('Tentando conversar sozinho? Quanta solidão :(');
    }
  }

  Widget searchTile(String username, String email) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: mediumTextStyle(),
              ),
              Text(
                email,
                style: mediumTextStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap:() => createChatRoomAndStartConversation(
                context, searchController.text),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(30.0)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Icon(
                Icons.chat,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                searchSnapshot!.docs[index]['username'],
                searchSnapshot!.docs[index]['email'],
              );
            })
        : Container();
  }

  getUserInfo() async{
     _myName = await Util.getUsernameSharedPreference();
     setState(() {

     });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  _searchUsers() {
    databaseMethods.getUserByUsername(searchController.text).then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Procure por um nome de usuário',
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _searchUsers(),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return '$b\_$a';
  }
  return '$a\_$b';
}
