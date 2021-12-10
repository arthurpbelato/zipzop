import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Util{
  static String sharedPreferencesUserLoggedInKey = "ISLOGGED";
  static String sharedPreferencesUsernameKey = "USERNAME";
  static String sharedPreferencesEmailKey = "EMAIL";

  final ImagePicker _picker = ImagePicker();

  static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferencesUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUsernameSharedPreference(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUsernameKey, username);
  }

  static Future<bool> saveEmailSharedPreference(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesEmailKey, email);
  }


  static Future<bool?> getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferencesUserLoggedInKey);
  }

  static Future<String?> getUsernameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesUsernameKey);
  }

  static Future<String?> getEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesEmailKey);
  }

  static getImage(){
    File _image;


  }
}

