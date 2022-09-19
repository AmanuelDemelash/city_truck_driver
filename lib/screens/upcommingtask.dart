import 'package:badges/badges.dart';
import 'package:city_truck_driver/controllers/todaytaskcontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flag/flag.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Upcommingtask extends StatelessWidget {
  const Upcommingtask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Upcomming Tasks"),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Stack(children: [
          // const GoogleMap(
          //   mapType: MapType.normal,
          //   zoomControlsEnabled: false,
          //   initialCameraPosition: CameraPosition(
          //     target: LatLng(9.005401, 38.763611),
          //     zoom: 14.4746,
          //   ),
          // ),
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
              margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: GetBuilder<TodaysTaskcontroller>(
                init: Get.find<TodaysTaskcontroller>(),
                initState: (_) {},
                builder: (controller) {
                  return controller.upcomming_tasks.value.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SpinKitFadingCircle(
                                itemBuilder: (BuildContext context, int index) {
                                  return DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: index.isEven
                                          ? Colors.orange
                                          : Colors.orange.shade300,
                                    ),
                                  );
                                },
                              ),
                              const Text("Loading...")
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(5),
                          dragStartBehavior: DragStartBehavior.start,
                          itemCount: controller.upcomming_tasks.value.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Get.toNamed("/taskdetail",
                                  arguments:
                                      controller.upcomming_tasks.value[index]),
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  width: Get.width,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('trucks')
                                              .doc(controller.upcomming_tasks
                                                  .value[index].truck_id)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            return ListTile(
                                              leading: CircleAvatar(
                                                radius: 24,
                                                backgroundImage: NetworkImage(
                                                    snapshot
                                                        .data!["truck_image"]),
                                              ),
                                              title: Text(
                                                  snapshot.data!["truck_model"],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              subtitle: Text(
                                                  snapshot.data!["plate_num"]),
                                              trailing: Text(
                                                "${controller.upcomming_tasks.value[index].total_kilometer} KM",
                                                style: const TextStyle(
                                                    color: Colors.orange,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              ),
                                            );
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
                                                  controller.upcomming_tasks
                                                      .value[index].task_type,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Badge(
                                                  badgeColor: Colors.orange,
                                                  badgeContent: Text(
                                                    controller
                                                        .tasks
                                                        .value[index]
                                                        .total_task,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape: BadgeShape.circle,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                )
                                              ],
                                            ),
                                            const Text(
                                              "Departed",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              controller.upcomming_tasks
                                                  .value[index].date,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
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
                                                    "${controller.complated_tasks.value[index].start_location} to ${controller.upcomming_tasks.value[index].end_location}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
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
                          },
                        );
                },
              ))
        ]));
  }
}
