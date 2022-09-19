import 'package:get/get.dart';

class SettingController extends GetxController {
  var is_admin_send_task_notif = false.obs;
  var is_someone_view_mytrip_notif = false.obs;
  var is_when_i_accept_notif = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> save_setting_state() async {
    // save setting state using sharedperferance or hive
  }
}
