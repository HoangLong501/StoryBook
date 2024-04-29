import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{

  static String userNameKey ="USERNAMEKEY";
  static String userIdKey ="USERIDKEY";
  static String userImageKey ="USERIMAGEKEY";
  static String userEmailKey ="USEREMAILKEY";
  static String userPhoneKey ="USERPHONEKEY";
  static String disPlayNameKey="USERDISPLAYNAME";

  Future<bool> saveIdUser(String getIdUser) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userIdKey, getIdUser);
  }
  Future<bool> saveImageUser(String img) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userImageKey, img);
  }
  Future<bool> saveUserName(String getUserName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userNameKey, getUserName);
  }
  Future<bool> saveUserEmail(String getUserEmail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userEmailKey, getUserEmail);
  }
  Future<bool> saveUserPhone(String getUserPhone) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userPhoneKey, getUserPhone);
  }
  Future<bool> saveUserDisPlayName(String getUserDisPlayName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(disPlayNameKey, getUserDisPlayName);
  }

  Future<String?> getIdUser()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userIdKey);
  }
  Future<String?> getImageUser()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userImageKey);
  }
  Future<String?> getUserName()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameKey);
  }
  Future<String?> getUserEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailKey);
  }
  Future<String?> getUserPhone()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userPhoneKey);
  }
  Future<String?> getDisPlayName()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(disPlayNameKey);
  }
}