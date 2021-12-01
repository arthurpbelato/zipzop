import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zipzop/exception/exception_handler.dart';

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
    print(messageMap);
    FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e) {
          print(e.toString());
        });
  }

  Future getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }
}
