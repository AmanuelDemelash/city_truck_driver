import 'package:badges/badges.dart';
import 'package:city_truck_driver/components/mydrawer.dart';
import 'package:city_truck_driver/controllers/todaytaskcontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flag/flag.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Todays Tasks"),
      ),
      drawer: const mydrawer(),
      body: Stack(
        children: [
          const GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(9.005401, 38.763611),
              zoom: 14.4746,
            ),
            zoomGesturesEnabled: false,
          ),
          Container(
            height: 100,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
                color: Colors.orange),
          ),
          Container(
              width: Get.width,
              height: Get.height,
              margin: const EdgeInsets.only(left: 14, right: 14, top: 15),
              child: RefreshIndicator(
                  onRefresh: () => Get.find<TodaysTaskcontroller>().refresh(),
                  displacement: 50,
                  strokeWidth: 2,
                  backgroundColor: Colors.white,
                  color: Colors.orange,
                  edgeOffset: 1.0,
                  child: GetBuilder<TodaysTaskcontroller>(
                      init: Get.find<TodaysTaskcontroller>(),
                      initState: (_) {},
                      builder: (controller) {
                        return controller.tasks.value.isEmpty
                            ? const Text("no task assigned yet")
                            : ListView.builder(
                                itemCount: controller.tasks.value.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => Get.toNamed("/taskdetail",
                                        arguments:
                                            controller.tasks.value[index]),
                                    child: Card(
                                      elevation: 5,
                                      color: controller
                                                  .tasks.value[index].statuss ==
                                              1
                                          ? Colors.green.shade200
                                          : Colors.white,
                                      child: Container(
                                        width: Get.width,
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            StreamBuilder<DocumentSnapshot?>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('trucks')
                                                    .doc(controller.tasks
                                                        .value[index].truck_id)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  return snapshot.hasData
                                                      ? ListTile(
                                                          leading: CircleAvatar(
                                                            radius: 24,
                                                            backgroundImage:
                                                                NetworkImage(snapshot
                                                                        .data![
                                                                    "truck_image"]),
                                                          ),
                                                          title: Text(
                                                              snapshot.data![
                                                                  "truck_model"],
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          subtitle: Text(
                                                              snapshot.data![
                                                                  "plate_num"]),
                                                          trailing: Text(
                                                            "${controller.tasks.value[index].load_carring} Tonnes",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .orange,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17),
                                                          ),
                                                        )
                                                      : const LinearProgressIndicator();
                                                }),
                                            Container(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Task",
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        controller
                                                            .tasks
                                                            .value[index]
                                                            .task_type,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Badge(
                                                        badgeColor:
                                                            Colors.orange,
                                                        badgeContent: Text(
                                                          controller
                                                              .tasks
                                                              .value[index]
                                                              .total_task,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        shape:
                                                            BadgeShape.circle,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                      )
                                                    ],
                                                  ),
                                                  const Text(
                                                    "Departed",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            137, 53, 46, 46)),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    controller.tasks
                                                        .value[index].date,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  const Text(
                                                    "Location",
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "${controller.tasks.value[index].start_location} to ${controller.tasks.value[index].end_location}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Flag.fromCode(
                                                        FlagsCode.ET,
                                                        height: 20,
                                                        width: 30,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                      }))),
          Positioned(
            bottom: 10,
            right: 15,
            left: 15,
            child: Container(
              width: Get.width,
              decoration: const BoxDecoration(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: RaisedButton(
                    padding: const EdgeInsets.all(10),
                    color: Colors.orange,
                    textColor: Colors.black,
                    onPressed: () {
                      Get.toNamed("/upcomming");
                    },
                    child: const Text("View Upcomming Tasks",
                        style: TextStyle(
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontSize: 18))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
