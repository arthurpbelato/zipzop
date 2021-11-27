import 'package:fluttertoast/fluttertoast.dart';

class ExceptionHandler {
  static handleException(String msg){
    return Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0
    );
  }
}