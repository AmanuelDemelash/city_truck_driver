import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TaskDetailMapController extends GetxController {
  Rx<LocationData>? current_location;
  Rx<double> current_lat = Rx<double>(0.00);
  Rx<double> current_long = Rx<double>(0.00);
  var isupdateing = false.obs;
  var isendtrip = false.obs;
  var show = false.obs;
  //var totalDistance = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<BitmapDescriptor> getmarker() async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/bike.png",
    );
    return markerbitmap;
  }

// Calculate distance b/n two cordinates
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var result = 12742 * asin(sqrt(a));
    return result.ceilToDouble();
  }

  Future<void> update_task(String task_id) async {
    await FirebaseFirestore.instance.collection("Tasks").doc(task_id).update({
      'task_statuss': 1,
      'current_lat': current_lat.value,
      'current_long': current_long.value
    }).then((value) {
      isupdateing.value = true;
    }).catchError((error) {
      Get.snackbar("Error", error.toString(),
          snackPosition: SnackPosition.BOTTOM,
          padding: const EdgeInsets.all(5),
          duration: const Duration(seconds: 4));
    });
  }

  Future<void> end_trip(String task_id) async {
    isendtrip.value = true;
    await FirebaseFirestore.instance.collection("Tasks").doc(task_id).update({
      'task_statuss': 2,
      'current_lat': current_lat.value,
      'current_long': current_long.value
    }).then((value) {
      isendtrip.value = false;
      Get.offNamed("/homepage");
    }).catchError((error) {
      Get.snackbar("Error", error.toString(),
          snackPosition: SnackPosition.BOTTOM,
          padding: const EdgeInsets.all(5),
          duration: const Duration(seconds: 4));
    });
  }
}
