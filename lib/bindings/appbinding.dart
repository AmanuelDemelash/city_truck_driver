import 'package:city_truck_driver/controllers/auth_controller.dart';
import 'package:city_truck_driver/controllers/settingcontroller.dart';
import 'package:city_truck_driver/controllers/splash_controller.dart';
import 'package:city_truck_driver/controllers/starttripcontroller.dart';
import 'package:city_truck_driver/controllers/task_detail_map_controller.dart';
import 'package:city_truck_driver/controllers/todaytaskcontroller.dart';
import 'package:get/get.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(StartTripcontroller());
    Get.put(SettingController());
    Get.put(AuthController());
    Get.put(SplashController());
    Get.put(TodaysTaskcontroller());
    Get.put(TaskDetailMapController());
  }
}
