import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modals/premium_modal.dart';
import '../../utils/app_keys.dart';

String premiumDate = "";
// bool isPremium = true;

class PremiumScreenController extends GetxController{
  RxInt selectedI = 1.obs;


  onChangeIndex(int index){
    selectedI.value = index;
    update();
  }

  storeDate(String dateTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Premium_Date', dateTime);
    update();
  }


  // getDate() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   premiumDate = prefs.getString('Premium_Date') ?? "";
  //   print("premiumDate -----> $premiumDate");
  //   DateTime fin = DateTime.parse(premiumDate);
  //   DateTime date =  DateTime.now();
  //   DateTime time = DateTime(date.year, date.month, date.day);
  //   if(premiumDate != ""){
  //     if(time.compareTo(fin) < 0){
  //       isPremium = false;
  //       update();
  //     }else{
  //       isPremium = true;
  //       update();
  //     }
  //   }else{
  //     print("non premium");
  //   }
  // }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // getDate();
    print('-------> $isPremium');
  }



}