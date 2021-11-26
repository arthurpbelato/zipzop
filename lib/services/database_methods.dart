import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('user')
        .where('username', isEqualTo: username)
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
      print(onError);
    });
  }

  Future<bool>? addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

}
