import 'package:badges/badges.dart';
import 'package:city_truck_driver/controllers/todaytaskcontroller.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MytripHistory extends StatelessWidget {
  const MytripHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text("My Trip History")),
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
                return controller.complated_tasks.value.isEmpty
                    ? const Center(
                        child: Text("No task complated yet.."),
                      )
                    : ListView.builder(
                        itemCount: controller.complated_tasks.value.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            child: Container(
                              width: Get.width,
                              margin: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text(
                                              "Task",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                            Text(
                                              "Complated",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              controller.complated_tasks
                                                  .value[index].task_type,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const Text(
                                          "Departed",
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          controller.complated_tasks
                                              .value[index].date,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        const Text(
                                          "Location",
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${controller.complated_tasks.value[index].start_location}To${controller.complated_tasks.value[index].start_location}",
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
