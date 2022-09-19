import 'package:badges/badges.dart';
import 'package:city_truck_driver/controllers/task_detail_map_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utlities/constants.dart';

class Taskdetail extends StatefulWidget {
  Taskdetail({Key? key}) : super(key: key);

  @override
  State<Taskdetail> createState() => _TaskdetailState();
}

class _TaskdetailState extends State<Taskdetail> {
  var args = Get.arguments;
  List<LatLng> polylinecordinates = [];
  BitmapDescriptor start_marker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor end_marker = BitmapDescriptor.defaultMarker;

  void getpolyline() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapApi,
        PointLatLng(args.start_loc_lat, args.start_loc_long),
        PointLatLng(args.end_loc_lat, args.end_loc_long));

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylinecordinates.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {});
    }
  }

  getcustom_marker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/location.png")
        .then((value) => end_marker = value);
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/pin.png")
        .then((value) => start_marker = value);
  }

  @override
  void initState() {
    super.initState();
    getpolyline();
    getcustom_marker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(args.task_type),
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(args.start_loc_lat, args.start_loc_long),
              zoom: 11.4746,
            ),
            polylines: {
              Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylinecordinates,
                  color: Colors.blue,
                  width: 5)
            },
            markers: {
              Marker(
                  markerId: const MarkerId("start"),
                  position: LatLng(args.start_loc_lat, args.start_loc_long),
                  icon: start_marker),
              Marker(
                  markerId: const MarkerId("end"),
                  position: LatLng(args.end_loc_lat, args.end_loc_long),
                  icon: end_marker),
            },
          ),
          Container(
              height: 100,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                  color: Colors.orange)),
          Positioned(
            top: 3,
            left: 10,
            right: 10,
            child: Card(
              elevation: 5,
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('trucks')
                            .doc(args.truck_id)
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
                                  trailing: Text(
                                    "${args.load_carring} Tonnes",
                                    style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                )
                              : const LinearProgressIndicator();
                        }),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Task",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                args.task_type,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Badge(
                                badgeColor: Colors.orange,
                                badgeContent: Text(
                                  args.total_task,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                shape: BadgeShape.circle,
                                padding: const EdgeInsets.all(10),
                              )
                            ],
                          ),
                          const Text(
                            "Departed",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Text(
                            args.date,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Location",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "${args.start_location} To ${args.end_location}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
          ),
          Positioned(
              bottom: 0,
              right: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Fastest Route"),
                          Text(
                              "${Get.find<TaskDetailMapController>().calculateDistance(args.start_loc_lat, args.start_loc_long, args.end_loc_lat, args.end_loc_long)} km",
                              style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Container(
                      width: Get.width,
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GetBuilder<TaskDetailMapController>(
                            init: Get.find<TaskDetailMapController>(),
                            initState: (_) {},
                            builder: (controller) {
                              return RaisedButton.icon(
                                  icon: args.statuss == 0
                                      ? const Icon(Icons.track_changes)
                                      : const Icon(Icons.location_on),
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.orange,
                                  textColor: Colors.black,
                                  onPressed: () async {
                                    await Get.find<TaskDetailMapController>()
                                        .update_task(args.id);
                                    Get.offNamed("/starttrip", arguments: args);
                                  },
                                  label: args.statuss == 0
                                      ? const Text("Start Trip",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                              fontSize: 19))
                                      : const Text(" Track",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                              fontSize: 19)));
                            },
                          )),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
