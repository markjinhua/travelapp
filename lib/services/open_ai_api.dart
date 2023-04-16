import 'dart:convert';

import 'package:chat_gpt/utils/app_keys.dart';
import 'package:http/http.dart' as http;




class ChatGptApi {

   getImageFromChatGpt(String message,{required String? size}) async {
    try {
      http.Response response = await http.post(
          Uri.parse("https://api.openai.com/v1/images/generations"),
          headers: {
            "Authorization": "Bearer $openAiToken",
            'Content-Type': 'application/json',
          },
          body: jsonEncode({"prompt": message,"size" : size,"n": 1,}));
      return jsonDecode(response. body)["data"][0]["url"] as String;
    } catch (e) {
      print("Error  is  -----> $e");
      return "";
    }
  }

}