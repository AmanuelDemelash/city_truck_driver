import 'dart:async';

import 'package:city_truck_driver/controllers/task_detail_map_controller.dart';
import 'package:city_truck_driver/model/task.dart';
import 'package:city_truck_driver/utlities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/starttripcontroller.dart';

class Starttrip extends StatefulWidget {
  Starttrip({Key? key}) : super(key: key);

  @override
  State<Starttrip> createState() => _StarttripState();
}

class _StarttripState extends State<Starttrip> {
  final Task _task = Get.arguments;
  late final Completer<GoogleMapController> mapcontroller = Completer();

  late LatLng startloc;
  late LatLng endloc;
  BitmapDescriptor current_truck_marker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor start_marker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor end_marker = BitmapDescriptor.defaultMarker;

  List<LatLng> polylinecordinates = [];

  late double remainning_distance;

  void getcurrent_location() async {
    Location location = Location();
    location.getLocation().then((value) {
      Get.find<TaskDetailMapController>().current_lat.value = value.latitude!;
      Get.find<TaskDetailMapController>().current_long.value = value.longitude!;

      Get.find<TaskDetailMapController>().update_task(_task.id);
      setState(() {});
    });

    GoogleMapController googleMapController = await mapcontroller.future;
    location.onLocationChanged.listen((newloc) {
      // current_location!.value = newloc;
      Get.find<TaskDetailMapController>().current_lat.value = newloc.latitude!;
      Get.find<TaskDetailMapController>().current_long.value =
          newloc.longitude!;
      Get.find<TaskDetailMapController>().update_task(_task.id);

      remainning_distance = Get.find<TaskDetailMapController>()
          .calculateDistance(
              Get.find<TaskDetailMapController>().current_lat.value,
              Get.find<TaskDetailMapController>().current_long.value,
              _task.end_loc_lat,
              _task.end_loc_long);

      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(newloc.latitude!, newloc.longitude!),
        zoom: 14.4746,
      )));
      setState(() {});
    });
  }

  void getpolyline() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapApi,
        PointLatLng(startloc.latitude, startloc.longitude),
        PointLatLng(endloc.latitude, endloc.longitude),
        travelMode: TravelMode.driving);

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylinecordinates.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {});
    }
  }

  getcustom_marker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/currenttruck.png")
        .then((value) => current_truck_marker = value);
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/location.png")
        .then((value) => end_marker = value);
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin.png")
        .then((value) => start_marker = value);
  }

  @override
  void initState() {
    super.initState();
    startloc = LatLng(_task.start_loc_lat, _task.start_loc_long);
    endloc = LatLng(_task.end_loc_lat, _task.end_loc_long);
    getpolyline();
    getcustom_marker();
    getcurrent_location();
    remainning_distance = Get.find<TaskDetailMapController>().calculateDistance(
        Get.find<TaskDetailMapController>().current_lat.value,
        Get.find<TaskDetailMapController>().current_long.value,
        _task.end_loc_lat,
        _task.end_loc_long);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Get.find<TaskDetailMapController>().update_task(_task.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    Get.find<TaskDetailMapController>()
                        .current_lat
                        .value
                        .toDouble(),
                    Get.find<TaskDetailMapController>()
                        .current_long
                        .value
                        .toDouble()),
                zoom: 16.4746,
              ),
              polylines: {
                Polyline(
                    polylineId: const PolylineId("route"),
                    points: polylinecordinates,
                    color: Colors.blue,
                    endCap: Cap.roundCap,
                    width: 5),
              },
              markers: {
                Marker(
                    markerId: const MarkerId("current"),
                    position: LatLng(
                        Get.find<TaskDetailMapController>().current_lat.value,
                        Get.find<TaskDetailMapController>().current_long.value),
                    infoWindow: InfoWindow(
                      title: _task.task_type,
                    ),
                    icon: current_truck_marker,
                    flat: true),
                Marker(
                    markerId: const MarkerId("start"),
                    position: startloc,
                    icon: start_marker),
                Marker(
                  markerId: const MarkerId("end"),
                  position: endloc,
                  icon: end_marker,
                )
              },
              onMapCreated: (mapControllers) {
                mapcontroller.complete(mapControllers);
              },
            );
          }),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 20),
            child: IconButton(
              onPressed: () {
                Get.find<StartTripcontroller>().currentmenuitem.value = 0;
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 34,
                color: Colors.orange,
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: Get.find<TaskDetailMapController>().show.value,
              child: Positioned(
                bottom: 0,
                left: 5,
                right: 5,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  width: Get.width,
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('trucks')
                              .doc(_task.truck_id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? ListTile(
                                    leading: CircleAvatar(
                                      radius: 24,
                                      backgroundImage: NetworkImage(
                                          snapshot.data!["truck_image"]),
                                    ),
                                    title: Text(snapshot.data!["truck_model"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(snapshot.data!["plate_num"]),
                                    trailing: const Text(
                                      "In transit",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  )
                                : const Text("TRUCK");
                          }),
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                2,
                                (index) => Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 10),
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 1),
                                      child: TextButton(
                                          onPressed: () {
                                            Get.find<StartTripcontroller>()
                                                .changemenu(index);
                                          },
                                          child: Text(
                                            Get.find<StartTripcontroller>()
                                                .currentmenu_text
                                                .value[index]
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight:
                                                  Get.find<StartTripcontroller>()
                                                              .currentmenuitem
                                                              .value ==
                                                          index
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              fontSize:
                                                  Get.find<StartTripcontroller>()
                                                              .currentmenuitem
                                                              .value ==
                                                          index
                                                      ? 16
                                                      : 13,
                                              color:
                                                  Get.find<StartTripcontroller>()
                                                              .currentmenuitem
                                                              .value ==
                                                          index
                                                      ? Colors.orange
                                                      : Colors.black45,
                                            ),
                                          )),
                                    ))),
                          )),
                      Obx(() => IndexedStack(
                            index: Get.find<StartTripcontroller>()
                                .currentmenuitem
                                .value,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Task",
                                        style: TextStyle(color: Colors.black)),
                                    Text(
                                      _task.task_type,
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text("Departed",
                                        style: TextStyle(color: Colors.black)),
                                    Text(
                                      _task.date,
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text("Start Location",
                                        style: TextStyle(color: Colors.black)),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          color: Colors.red,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          _task.start_location,
                                          style: const TextStyle(
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text("Current Location",
                                        style: TextStyle(color: Colors.black)),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.gps_fixed,
                                          color: Colors.pink,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "056 4kilo Rd Addis Ababa",
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text("Trip End Location",
                                        style: TextStyle(color: Colors.black)),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          color: Colors.green,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          _task.end_location,
                                          style: const TextStyle(
                                              color: Colors.black54),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("trucks")
                                      .doc(_task.truck_id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData
                                        ? AnimatedContainer(
                                            duration:
                                                const Duration(seconds: 3),
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text("Vehicle Model",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    Text(
                                                        snapshot.data![
                                                            "truck_model"],
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .black54)),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text("Vehicle Number",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    Text(
                                                        snapshot
                                                            .data!["plate_num"],
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .black54)),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                        "Max Load Capacity",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    Text(
                                                        snapshot.data![
                                                            "load_capacity"],
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .black54)),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                        "Insured Due Date",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    Text(
                                                        snapshot.data![
                                                            "insured_date"],
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .black54)),
                                                  ],
                                                ),
                                                StreamBuilder<DocumentSnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection("drivers")
                                                        .doc(_task.driver_id)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      return snapshot.hasData
                                                          ? ExpansionTile(
                                                              iconColor:
                                                                  Colors.orange,
                                                              title: const Text(
                                                                  "Driver",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15)),
                                                              children: [
                                                                ListTile(
                                                                  leading:
                                                                      CircleAvatar(
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                            snapshot.data!["image"]),
                                                                  ),
                                                                  title: Text(
                                                                      snapshot.data![
                                                                          "name"],
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  subtitle: Text(
                                                                      snapshot.data![
                                                                          "phone"],
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.black45)),
                                                                  trailing:
                                                                      IconButton(
                                                                          onPressed:
                                                                              () async {
                                                                            await launchUrl(
                                                                              Uri.parse("tel:${snapshot.data!["phone"]}"),
                                                                              mode: LaunchMode.externalApplication,
                                                                            );
                                                                          },
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.phone,
                                                                            size:
                                                                                30,
                                                                            color:
                                                                                Colors.black,
                                                                          )),
                                                                )
                                                              ],
                                                            )
                                                          : const Text(
                                                              "loading..");
                                                    }),
                                                StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('drivers')
                                                        .doc(_task.driver_id)
                                                        .collection('helper')
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      return snapshot.hasData
                                                          ? ExpansionTile(
                                                              iconColor:
                                                                  Colors.orange,
                                                              title: const Text(
                                                                  "Helper",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15)),
                                                              children: [
                                                                ListView
                                                                    .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            const NeverScrollableScrollPhysics(),
                                                                        itemCount: snapshot
                                                                            .data!
                                                                            .docs
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          var helperData = snapshot
                                                                              .data
                                                                              ?.docs[index];
                                                                          return ListTile(
                                                                            leading:
                                                                                CircleAvatar(
                                                                              backgroundImage: NetworkImage(helperData!["image"]),
                                                                            ),
                                                                            title:
                                                                                const Text("Tekeleab mulu", style: TextStyle(fontWeight: FontWeight.bold)),
                                                                            subtitle:
                                                                                Text(helperData["phone"], style: const TextStyle(color: Colors.black45)),
                                                                            trailing: IconButton(
                                                                                onPressed: () async {
                                                                                  await launchUrl(
                                                                                    Uri.parse("tel:${helperData["phone"]}"),
                                                                                    mode: LaunchMode.externalApplication,
                                                                                  );
                                                                                },
                                                                                icon: const Icon(
                                                                                  Icons.phone,
                                                                                  size: 30,
                                                                                  color: Colors.black,
                                                                                )),
                                                                          );
                                                                        })
                                                              ],
                                                            )
                                                          : const Text(
                                                              "no helper assigned");
                                                    })
                                              ],
                                            ),
                                          )
                                        : const Text("loading");
                                  })
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: 40,
            child: Obx(() => FloatingActionButton(
                onPressed: () {
                  Get.find<TaskDetailMapController>().show.value == true
                      ? Get.find<TaskDetailMapController>().show.value = false
                      : Get.find<TaskDetailMapController>().show.value = true;
                },
                child: Get.find<TaskDetailMapController>().show.value == true
                    ? const Icon(
                        Icons.close,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.info,
                        color: Colors.white,
                      ))),
          ),
          Positioned(
            right: 15,
            top: 100,
            child: FloatingActionButton(
                onPressed: () {
                  Get.defaultDialog(
                      title: "End Trip",
                      middleText: "Do you want to end trip?",
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.find<TaskDetailMapController>()
                                .end_trip(_task.id);
                            Get.back();
                          },
                          child: const Text("Yes"),
                        )
                      ],
                      contentPadding: const EdgeInsets.all(10));
                },
                child: const Icon(
                  Icons.stop_sharp,
                  color: Colors.white,
                )),
          ),
          Positioned(
            right: 15,
            top: 160,
            child: FloatingActionButton(
                onPressed: () async {
                  await launchUrl(Uri.parse(
                      'google.navigation:q=${_task.end_loc_lat},${_task.end_loc_long}'));
                },
                child: const Icon(
                  Icons.directions,
                  color: Colors.white,
                )),
          ),
          Positioned(
              top: 35,
              left: 90,
              child: Text(
                "$remainning_distance KM Remaining",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
          Obx(() => Visibility(
                visible: Get.find<TaskDetailMapController>().isendtrip.value,
                child: Center(
                  child: SpinKitFadingCircle(
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
                ),
              ))
        ],
      ),
    );
  }
}
