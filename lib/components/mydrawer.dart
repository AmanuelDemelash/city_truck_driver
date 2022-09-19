import 'package:city_truck_driver/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class mydrawer extends StatelessWidget {
  const mydrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              accountName:
                  Text(FirebaseAuth.instance.currentUser!.email.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                      )),
              accountEmail: const Text("",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/profile.png"),
              )),
          const SizedBox(
            height: 25,
          ),
          InkWell(
            onTap: () => Get.back(),
            child: const ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.orange,
              ),
              title: Text("Home"),
            ),
          ),
          InkWell(
            onTap: () => Get.toNamed("/mytasklist"),
            child: const ListTile(
              leading: Icon(
                Icons.task,
                color: Colors.orange,
              ),
              title: Text("My Task List"),
            ),
          ),
          InkWell(
            onTap: () => Get.toNamed("/mytriphistory"),
            child: const ListTile(
              leading: Icon(
                Icons.trip_origin,
                color: Colors.orange,
              ),
              title: Text("My Trip History"),
            ),
          ),
          const InkWell(
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.orange,
              ),
              title: Text("Profile"),
            ),
          ),
          InkWell(
            onTap: () => Get.toNamed("/setting"),
            child: const ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.orange,
              ),
              title: Text("Setting"),
            ),
          ),
          GetBuilder<AuthController>(
            init: Get.find<AuthController>(),
            initState: (_) {},
            builder: (controller) {
              return InkWell(
                onTap: () => Get.defaultDialog(
                  title: "Do you want to Logout?",
                  content: Container(),
                  barrierDismissible: false,
                  radius: 10,
                  contentPadding: const EdgeInsets.all(15),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.logout();
                      },
                      child: const Text("Logout"),
                    )
                  ],
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.orange,
                  ),
                  title: Text("Log Out"),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
