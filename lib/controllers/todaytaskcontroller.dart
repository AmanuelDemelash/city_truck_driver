import 'package:city_truck_driver/model/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TodaysTaskcontroller extends GetxController {
  var todaystask = [];

  Rx<List<Task>> tasks = Rx<List<Task>>([]);
  Rx<List<Task>> upcomming_tasks = Rx<List<Task>>([]);
  Rx<List<Task>> complated_tasks = Rx<List<Task>>([]);
  Rx<List<Task>> all_tasks = Rx<List<Task>>([]);

  @override
  void onInit() {
    super.onInit();
    tasks.bindStream(gettasks());
    upcomming_tasks.bindStream(get_upcomming_tasks());
    complated_tasks.bindStream(get_complated_tasks());
    all_tasks.bindStream(getalltasks());
  }

  Stream<List<Task>> getalltasks() {
    return FirebaseFirestore.instance
        .collection("Tasks")
        .where("driver", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((event) {
      List<Task> task = [];
      for (var element in event.docs) {
        task.add(Task.fromDocunmentSnapshot(element));
      }
      return task;
    });
  }

  Stream<List<Task>> gettasks() {
    return FirebaseFirestore.instance
        .collection("Tasks")
        .where("driver", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where("task_statuss", isLessThanOrEqualTo: 1)
        .snapshots()
        .map((event) {
      List<Task> task = [];
      for (var element in event.docs) {
        task.add(Task.fromDocunmentSnapshot(element));
      }
      return task;
    });
  }

  Stream<List<Task>> get_upcomming_tasks() {
    return FirebaseFirestore.instance
        .collection("Tasks")
        .where("driver", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where("task_statuss", isEqualTo: 0)
        .snapshots()
        .map((event) {
      List<Task> task = [];
      for (var element in event.docs) {
        task.add(Task.fromDocunmentSnapshot(element));
      }
      return task;
    });
  }

  Stream<List<Task>> get_complated_tasks() {
    return FirebaseFirestore.instance
        .collection("Tasks")
        .where("driver", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where("task_statuss", isEqualTo: 2)
        .snapshots()
        .map((event) {
      List<Task> comtask = [];
      for (var element in event.docs) {
        comtask.add(Task.fromDocunmentSnapshot(element));
      }
      return comtask;
    });
  }

  Future<void> refresh() async {
    tasks.bindStream(gettasks());
    Future.delayed(const Duration(seconds: 2));
  }
}
