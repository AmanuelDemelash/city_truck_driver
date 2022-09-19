import 'package:badges/badges.dart';
import 'package:city_truck_driver/controllers/todaytaskcontroller.dart';
import 'package:flag/flag.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MytaskList extends StatelessWidget {
  const MytaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text("My Task List"),
      ),
      body: Stack(
        children: [
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
              child: GetBuilder<TodaysTaskcontroller>(
                  init: Get.find<TodaysTaskcontroller>(),
                  initState: (_) {},
                  builder: (controller) {
                    return ListView.builder(
                        itemCount: controller.all_tasks.value.length,
                        itemBuilder: (context, index) {
                          return controller.all_tasks.value.isEmpty
                              ? const Center(
                                  child: Text("No task yet assigned"))
                              : Card(
                                  elevation: 5,
                                  child: Container(
                                    width: Get.width,
                                    margin: const EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Task",
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  controller
                                                              .all_tasks
                                                              .value[index]
                                                              .statuss ==
                                                          0
                                                      ? const Text(
                                                          "Pending",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54),
                                                        )
                                                      : controller
                                                                  .all_tasks
                                                                  .value[index]
                                                                  .statuss ==
                                                              1
                                                          ? const Text(
                                                              "In Transit",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .orange),
                                                            )
                                                          : const Text(
                                                              "Complated",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green),
                                                            )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    controller.all_tasks
                                                        .value[index].task_type,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Badge(
                                                    badgeColor: Colors.orange,
                                                    badgeContent: const Text(
                                                      "5",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    shape: BadgeShape.circle,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                  )
                                                ],
                                              ),
                                              const Text(
                                                "Departed",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                controller.all_tasks
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
                                                      "${controller.all_tasks.value[index].start_location}To${controller.all_tasks.value[index].start_location}",
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
                                );
                        });
                  }))
        ],
      ),
    );
  }
}
