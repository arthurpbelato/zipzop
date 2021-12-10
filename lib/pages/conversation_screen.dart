import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zipzop/helper/constants.dart';
import 'package:zipzop/helper/image_picker.dart';
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

  late File _image;

  bool imageLodade = false;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  ImagePickerUtil imagePickerUtil = new ImagePickerUtil();

  Stream<QuerySnapshot>? chatMessagesStream;

  Widget ChatMessageList(){
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessagesStream,
      builder: (context, snapshots) {
        if (snapshots.hasData)
          return ListView.builder(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshots.data?.docs.length,
              itemBuilder: (context, index) {
                if(snapshots.data!.docs[index].get('type') == 0){
                  return MessageTile(
                      snapshots.data!.docs[index].get('message'),
                      snapshots.data!.docs[index].get('sendBy') ==
                          Constants.myName);
                }else{
                  return MessageImage(
                      snapshots.data!.docs[index].get('image'),
                      snapshots.data!.docs[index].get('sendBy') ==
                          Constants.myName);
                }
              });
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future scrollDown() async {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  sendMessage(type) {
    late Map<String, dynamic> messageMap;
    if (messageController.text.isNotEmpty) {
      messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
        "type": 0,
        "image": null
      };
    }
    databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    messageController.clear();
    scrollDown();
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
        .getConversationMessages(widget.chatRoomId).then((value) {
          setState(() {
            chatMessagesStream = value;
            isLoading = false;
          });
        });
  }

  teste() async {
    var a = await imagePickerUtil.getImage();
    if(a != null){
      setState(() {
        _image = a;
        databaseMethods.uploadFile(_image,widget.chatRoomId);
        imageLodade = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            Container(
                padding: EdgeInsets.only(bottom: 59), child: ChatMessageList()),
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
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
                      onTap: () => teste(),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        padding: EdgeInsets.zero,
                        child: Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () => sendMessage(1),
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

// isLoading? Center(child: CircularProgressIndicator()) :
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.5, horizontal: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [const Color(0xffdca65a), const Color(0xffe87bca)]
                    : [const Color(0xff6b97bd), const Color(0xffadecb4)]),
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23))),
        child:
            Text(message, style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}


class MessageImage extends StatelessWidget {
  final bool isSendByMe;

  String url;

  bool imageLodade = false;
  late File _image;
  MessageImage(this.url, this.isSendByMe);

  DatabaseMethods databaseMethods = new DatabaseMethods();

  download() async {
    await databaseMethods.download(url).then((value) {
      print(value);
      _image = File.fromRawPath(value);
      imageLodade = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.5, horizontal: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [const Color(0xffdca65a), const Color(0xffe87bca)]
                    : [const Color(0xff6b97bd), const Color(0xffadecb4)]),
            borderRadius: isSendByMe
                ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23))),
        child: !imageLodade ?
        GestureDetector(
          onTap: () => download(),
          child: Container(
            height: 35,
            width: 35,
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.image,
              color: Colors.white,
            ),
          ),
        ): Image.file(_image),
      ),
    );
  }
}
