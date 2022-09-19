import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashController extends GetxController {
  Future<void> cheek_login() async {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        Get.offNamed("/signin");
      } else {
        Get.offNamed("/homepage");
      }
    });
  }
}
