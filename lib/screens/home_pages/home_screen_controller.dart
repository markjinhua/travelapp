import 'dart:convert';
import 'package:chat_gpt/screens/premium_pages/premium_screen.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/app_assets.dart';
import '../../modals/all_modal.dart';
import '../../utils/shared_prefs_utils.dart';



class HomeScreenController extends GetxController {

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    socialMedialList.clear();
    readJson();
    SharedPrefsUtils.getChat();
    // TODO: implement onClose
    super.onInit();

  }

  RxInt selectedIndex = 0.obs;
  String selectedText = "";

  onChangeIndex(int index, text) {
    selectedIndex.value = index;
    selectedText = text;
    update();
  }



  List categoriesList = [];
  var items;
  List<SocialMediaModal> socialMedialList = [];
  List<AstrologyModal> astrologyList = [];

  Future<void> readJson() async {
    socialMedialList.clear();
    chatGPTList.clear();
    update();
    isLoading.value = true;
    update();
    final String response = await rootBundle.loadString(AppAssets.fileGPT3);
    final data = await json.decode(response);
    Map items = data["ChatGPT"];

    for (var i in items.values) {
      // print("i -----> ${i}"); /// GET CATEGORIES  DATA
      for (Map j in i) {
        categoriesList.add(j['name']); /// CATEGORIES in name add
        selectedText = categoriesList[0];
        update();
        // print("j -----> ${j.values}"); /// GET CATEGORIES NAME AND CATEGORIES DATA KEY

        for (var k in j['category_data']) {
          chatGPTList.add(
              ChatGPTModal(
                  name: j['name'],
                  categoriesData: [
                    CategoriesData(title: k["title"], description: k['description'], question: k['question'])
                   ]
              )
          );
        }
      }
    }
    // selectedText = chatGPTList[0].name[0];
    isLoading.value = false;
    update();
  }
}
