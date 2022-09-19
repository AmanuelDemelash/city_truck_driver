import 'package:get/get.dart';

class StartTripcontroller extends GetxController {
  var currentmenuitem = 0.obs;
  Rx<List<String>> currentmenu_text =
      Rx<List<String>>(["About Trip", "Vehicle Info"]);

  changemenu(int index) {
    currentmenuitem.value = index;
  }
}
