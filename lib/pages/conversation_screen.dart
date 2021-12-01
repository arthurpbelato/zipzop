import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zipzop/helper/constants.dart';
import 'package:zipzop/services/database_methods.dart';
import 'package:zipzop/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  const ConversationScreen({Key? key, required this.chatRoomId})
      : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  bool isLoading = false;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  late Stream<QuerySnapshot> chatMessagesStream;

  Widget ChatMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessagesStream,
      builder: (context, snapshots) {
        if(snapshots.hasData)
          return ListView.builder(
              itemCount: snapshots.data?.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(snapshots. data!.docs[index].data().toString());
              });
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  sendMessage() {
    late Map<String, dynamic> messageMap;
    if (messageController.text.isNotEmpty) {
      messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
    }
    databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
  }

  @override
  initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    await databaseMethods
        .getConversationMessages(widget.chatRoomId)
        .then((value) {
      setState(() {
        chatMessagesStream = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
              child: Stack(
                children: [
                  ChatMessageList(),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messageController,
                              decoration: InputDecoration(
                                hintText: 'Digite uma mensagem...',
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => sendMessage(),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              padding: EdgeInsets.zero,
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;

  MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(message),
    );
  }
}
