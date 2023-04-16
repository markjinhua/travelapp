import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LanguageScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;

  onChangeIndex ( int index){
    selectedIndex.value = index;
    storeIndex(selectedIndex);
    update();
  }

  storeIndex(RxInt index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedIndex', index.value);
    update();
  }

  getIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedIndex.value = prefs.getInt('selectedIndex') ?? 0;
    update();
  }

  storeLanguageCode(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', code);
    print("Language code -----> $code");
    update();
  }

  storeCountryCode(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('countryCode', code);
    print("Country code -----> $code");
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getIndex();
  }


}