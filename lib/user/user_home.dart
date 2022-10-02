// ignore_for_file: unused_import, import_of_legacy_library_into_null_safe
// @dart=2.9
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:mechanic/user/mechanic_details.dart';
import 'package:mechanic/widgets/AppText/AppText.dart';
import 'package:mechanic/widgets/const.dart';

class UserHomeScreen extends StatefulWidget {
  ScrollController scrollcontroller = ScrollController();
  UserHomeScreen({
    Key key,
    @required this.scrollcontroller,
  }) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  GoogleMapController _controller;
  double myLat = 0.0, myLng = 0.0;
  loc.Location _location = loc.Location();
  @override
  void initState() {
    getBytesFromAsset('assets/images/pin.png', 64).then((onValue) {
      customIcon = BitmapDescriptor.fromBytes(onValue);
    }).whenComplete(
      () => getData(),
    );
    super.initState();
  }

  BitmapDescriptor customIcon;

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))
        .buffer
        .asUint8List();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: Get.height / 2,
            width: Get.width,
            child: GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              ].toSet(),
              scrollGesturesEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              markers: markers,
              initialCameraPosition: CameraPosition(
                target: LatLng(myLat, myLng),
                zoom: 15,
              ),
            ),
          ),
          SizedBox(
            height: Get.height / 2,
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: mechanics.length,
              itemBuilder: (context, i) {
                return 
                ListTile(
                  onTap: () {
                    Get.to(
                      SPDetails(
                        sp: mechanics[i],
                      ),
                    );
                  },
                  leading: Container(
                    clipBehavior: Clip.hardEdge,
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: appThemeColor,
                      shape: BoxShape.circle,
                    ),
                    child: mechanics[i]['imageUrl'].toString() == 'null'
                        ? Image(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.fill,
                          )
                        : Image(
                            image: NetworkImage(mechanics[i]['imageUrl']),
                            fit: BoxFit.cover,
                          ),
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        Icon(
                          mechanics[i]['type'] == 'Bike'
                              ? Icons.motorcycle_rounded
                              : mechanics[i]['type'] == 'Car'
                                  ? Icons.directions_car_rounded
                                  : mechanics[i]['type'] == 'Rickshaw'
                                      ? Icons.electric_rickshaw
                                      : null,
                          color: Colors.grey,
                        ),
                        Txt(text: '  |  '),
                        Image(
                          image: AssetImage(
                            mechanics[i]['work'] == 'Petrolium'
                                ? 'assets/images/oil-barrel-icon-26.png'
                                : mechanics[i]['work'] == 'Carwash'
                                    ? 'assets/images/img_159173.png'
                                    : mechanics[i]['work'] == 'Tyre & Tube'
                                        ? 'assets/images/img_537354.png'
                                        : mechanics[i]['work'] == 'Service'
                                            ? 'assets/images/services-icon.webp'
                                            : mechanics[i]['work'] == 'Parts'
                                                ? 'assets/images/Parts+&+Accessories.png'
                                                : 'assets/images/logo.png',
                          ),
                          width: 18,
                          color: Colors.grey,
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                  title: Text(
                    mechanics[i]['firstname'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    mechanics[i]['address'].toString().trim(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> markers = {};

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Mechanics');

  List mechanics = [];

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    setState(() {
      mechanics = querySnapshot.docs
          .map(
            (doc) => doc.data(),
          )
          .toList();
    });
    mechanics.forEach(
      (e) {
        setState(
          () {
            markers.add(
              Marker(
                icon: customIcon,
                markerId: MarkerId("${e['uid']}"),
                position: LatLng(
                  double.parse(e['lat']),
                  double.parse(
                    e['long'],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    setState(() {
      myLat = double.parse(mechanics[0]['lat']);
      myLng = double.parse(mechanics[0]['long']);
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(myLat, myLng), zoom: 15),
        ),
      );
    });
  }
}
