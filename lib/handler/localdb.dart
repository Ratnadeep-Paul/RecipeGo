import 'package:shared_preferences/shared_preferences.dart';

class localDataSaver {
  static String nameKey = "NAMEKEY";
  static String emailKey = "EMAILKEY";
  static String imgKey = "IMAGEKEY";

  static Future<bool> saveName(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(nameKey, userName);
  }

  static Future<bool> saveEmail(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(emailKey, userEmail);
  }

  static Future<bool> saveImg(String userImg) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(imgKey, userImg);
  }

  static Future<String?> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(nameKey);
  }

  static Future<String?> getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(emailKey);
  }

  static Future<String?> getImg() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(imgKey);
  }
}
