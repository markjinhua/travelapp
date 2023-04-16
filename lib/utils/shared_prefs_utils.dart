import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../modals/message_model.dart';

class SharedPrefsUtils {


  static storeOnBoarding(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isHomeScreen', value);
  }




  static Future<void> storeChat({required String chat, required bool sentByMe, required String dateTime, required String answer}) async {
    String prefsKey = DateTime.now().microsecondsSinceEpoch.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MessageModel messageModel = MessageModel(message: chat, sentByMe: sentByMe, id: prefsKey, dateTime: dateTime, answer: answer);
    String jsonDocument = json.encode(messageModel);
    await prefs.setString(prefsKey.toString(), jsonDocument);
  }

  static Future<void> getChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    historyList.clear();
    prefs.getKeys().forEach((key) async  {

      if(key !=  "selectedIndex" && key != 'languageCode' && key != 'isHomeScreen' && key != 'countryCode' && key != 'voice' && key != 'isThemeMode' && key != 'isDarkMode' && key != 'messageLimit' && key != 'Premium_Date' ){
        var jsonDocument = await json.decode(prefs.getString(key).toString());
        MessageModel messageModel = MessageModel(
          message: jsonDocument['message'],
          sentByMe: jsonDocument['sentByMe'],
          id: jsonDocument['id'],
          dateTime: jsonDocument['dateTime'],
          answer: jsonDocument['answer'],
        );
        historyList.add(messageModel);
      }else{

      }


    });
  }

  static Future<void> removeChat(String? nameRemove) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(nameRemove!);

    print("Remove  ID  IS   =====> ${nameRemove.length}");
  }

}
