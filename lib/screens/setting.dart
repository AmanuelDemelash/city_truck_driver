import 'package:city_truck_driver/controllers/settingcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

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
          title: const Text("Setting")),
      body: Stack(children: [
        Container(
          height: 100,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              color: Colors.orange),
        ),
        Container(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                        child: Column(
                      children: const [
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              hintText: "Current Password"),
                        ),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              hintText: "New Password"),
                        ),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              hintText: "Confirm Password"),
                        ),
                      ],
                    )),
                    const SizedBox(
                      height: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Notifications",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Obx(() => CheckboxListTile(
                          value: Get.find<SettingController>()
                              .is_admin_send_task_notif
                              .value,
                          onChanged: (value) {
                            Get.find<SettingController>()
                                .is_admin_send_task_notif
                                .value = value!;
                          },
                          title: const Text(
                            "When admin send task",
                            style: TextStyle(color: Colors.black54),
                          ),
                        )),
                    Obx(() => CheckboxListTile(
                          value: Get.find<SettingController>()
                              .is_someone_view_mytrip_notif
                              .value,
                          onChanged: (value) {
                            Get.find<SettingController>()
                                .is_someone_view_mytrip_notif
                                .value = value!;
                          },
                          title: const Text("When some one view my trip",
                              style: TextStyle(color: Colors.black54)),
                        )),
                    Obx(() => CheckboxListTile(
                          value: Get.find<SettingController>()
                              .is_when_i_accept_notif
                              .value,
                          onChanged: (value) {
                            Get.find<SettingController>()
                                .is_when_i_accept_notif
                                .value = value!;
                          },
                          title: const Text("When i accept task",
                              style: TextStyle(color: Colors.black54)),
                        ))
                  ],
                ),
              )),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 10,
          left: 10,
          child: Container(
            width: Get.width,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: const BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 5, color: Colors.orange)]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: RaisedButton(
                  padding: const EdgeInsets.all(10),
                  color: Colors.orange,
                  textColor: Colors.white,
                  onPressed: () {
                    //Get.toNamed("/upcomming");
                  },
                  child: const Text("Save",
                      style: TextStyle(
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          fontSize: 20))),
            ),
          ),
        ),
      ]),
    );
  }
}
