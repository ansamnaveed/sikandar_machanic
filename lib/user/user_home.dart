import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class UserHomeScreen extends StatefulWidget {
  ScrollController scrollcontroller = ScrollController();
  UserHomeScreen({
    Key? key,
    required this.scrollcontroller,
  }) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  GoogleMapController? _controller;
  // double myLat = 0.0, myLng = 0.0;
  // loc.Location _location = loc.Location();
  @override
  // void initState() {
  //   _location.onLocationChanged.listen((l) {
  //     myLat = l.latitude!;
  //     myLng = l.longitude!;
  //   });
  //   super.initState();
  // }

  // void _onMapCreated(GoogleMapController _cntlr) {
  //   _controller = _cntlr;
  //   _location.onLocationChanged.listen((l) {
  //     myLat = l.latitude!;
  //     myLng = l.longitude!;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: Get.height / 2,
            width: Get.width,
            child: Image(
              image: AssetImage(
                'assets/images/map.png',
              ),
              fit: BoxFit.cover,
            ),
            // GoogleMap(
            //   zoomControlsEnabled: false,
            //   layoutDirection: TextDirection.rtl,
            //   initialCameraPosition: CameraPosition(
            //     target: LatLng(31.5011, 74.3216),
            //     zoom: 15,
            //   ),
            //   mapType: MapType.normal,
            //   myLocationButtonEnabled: false,
            // ),
          ),
          SizedBox(
            height: Get.height / 2,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Mechanics")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text("There is no expense");
                return ListView(
                  controller: widget.scrollcontroller,
                  children: getExpenseItems(snapshot),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => ListTile(
            title: Text(doc["firstname"]),
            subtitle: Text(
              doc["email"].toString(),
            ),
          ),
        )
        .toList();
  }
}
