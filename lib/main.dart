import 'package:city_truck_driver/bindings/appbinding.dart';
import 'package:city_truck_driver/screens/forgotpassword.dart';
import 'package:city_truck_driver/screens/homepage.dart';
import 'package:city_truck_driver/screens/homesplash.dart';
import 'package:city_truck_driver/screens/mytasklist.dart';
import 'package:city_truck_driver/screens/mytriphistory.dart';
import 'package:city_truck_driver/screens/setting.dart';
import 'package:city_truck_driver/screens/signin.dart';
import 'package:city_truck_driver/screens/signup.dart';
import 'package:city_truck_driver/screens/starttrip.dart';
import 'package:city_truck_driver/screens/taskdetail.dart';
import 'package:city_truck_driver/screens/upcommingtask.dart';
import 'package:city_truck_driver/screens/verify.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
      title: 'City Truck',
      defaultTransition: Transition.circularReveal,
      theme: ThemeData(
          fontFamily: "Myappfont",
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Colors.white),
      initialRoute: "/homesplash",
      getPages: [
        GetPage(name: "/homesplash", page: () => const HomeSplash()),
        GetPage(name: "/signin", page: () => SignIn()),
        GetPage(name: "/signup", page: () => SignUp()),
        GetPage(name: "/verify", page: () => const Verify()),
        GetPage(name: "/homepage", page: () => const Homepage()),
        GetPage(name: "/upcomming", page: () => const Upcommingtask()),
        GetPage(name: "/taskdetail", page: () => Taskdetail()),
        GetPage(name: "/starttrip", page: () => Starttrip()),
        GetPage(name: "/mytasklist", page: () => const MytaskList()),
        GetPage(name: "/mytriphistory", page: () => const MytripHistory()),
        GetPage(name: "/setting", page: () => const Setting()),
        GetPage(name: "/forgotpassword", page: () => ForgotPassword()),
      ],
    );
  }
}
