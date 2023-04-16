import 'package:get/get.dart';


class HistoryChatController extends GetxController{
  RxBool textField = false.obs;


  onchangeTextField(bool value){
    textField.value = value;
    update();
  }

  

}