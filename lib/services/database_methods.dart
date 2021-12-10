import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zipzop/exception/exception_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zipzop/helper/constants.dart';

class DatabaseMethods {
  Future getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('user')
        .where('username',
            isGreaterThanOrEqualTo: username,
            isLessThan: username.substring(0, username.length - 1) +
                String.fromCharCode(
                    username.codeUnitAt(username.length - 1) + 1))
        .get();
  }

  Future getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();
  }

  uploadUserInfo(Map<String, String> userMap) {
    FirebaseFirestore.instance
        .collection('user')
        .add(userMap)
        .catchError((onError) {
      ExceptionHandler.handleException(onError);
    });
  }

  Future<bool>? addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      ExceptionHandler.handleException(e);
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e) {
          print(e.toString());
        });
  }

  Future getConversationMessages(String chatRoomId) async {
    return FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future getChatRooms(String userName) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  Future uploadFile(File _image,String chatRoomId) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("image" + DateTime.now().toString());
    ref.putFile(_image).then((res) {
      res.ref.getDownloadURL().then((value) {
        late Map<String, dynamic> messageMap;
        messageMap = {
          "message": "image",
          "sendBy": Constants.myName,
          "time": DateTime.now().millisecondsSinceEpoch,
          "type": 1,
          "image": value
        };
        addConversationMessages(chatRoomId, messageMap);
      });
    });
  }

  Future download(String url) async {
    Reference httpsReference = FirebaseStorage.instance.refFromURL(url);
    final int ONE_MEGABYTE = 1024 * 1024;
    return httpsReference.getData(ONE_MEGABYTE);
  }

}
