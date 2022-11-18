// @dart=2.9
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:mechanic/widgets/AppButton/AppButton.dart';
import 'package:mechanic/widgets/TextFields/AppTextField.dart';
import 'package:mechanic/widgets/const.dart';
import 'package:sms/sms.dart';

class SPDetails extends StatefulWidget {
  Map sp;
  SPDetails({@required this.sp});
  @override
  State<SPDetails> createState() => _SPDetailsState(sp: sp);
}

class _SPDetailsState extends State<SPDetails> {
  loc.Location _location = loc.Location();

  int selectedPageIndex = 0;
  Map sp;

  GoogleMapController googleMapController;

  void _onMapCreated(GoogleMapController _cntlr) {
    googleMapController = _cntlr;
  }

  _SPDetailsState({@required this.sp});
  BitmapDescriptor myLocation;
  BitmapDescriptor current;
  @override
  void initState() {
    getBytesFromAsset('assets/images/Dark Blue.png', 64).then((onValue) {
      current = BitmapDescriptor.fromBytes(onValue);
    });
    getBytesFromAsset('assets/images/pin.png', 64).then((onValue) {
      myLocation = BitmapDescriptor.fromBytes(onValue);
    }).whenComplete(
      () {
        setState(
          () {
            markers.add(
              Marker(
                icon: myLocation,
                markerId: MarkerId("My Location"),
                position: LatLng(
                  double.parse(sp['lat']),
                  double.parse(sp['long']),
                ),
              ),
            );
          },
        );
      },
    );
    checkDistance();
    super.initState();
  }

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  bool routing = false;

  addPoly() async {
    await loc.Location().getLocation().then(
      (value) {
        setState(
          () async {
            setState(() {
              polylineCoordinates = [];
            });
            markers.add(
              Marker(
                icon: current,
                markerId: MarkerId("Location"),
                position: LatLng(value.latitude, value.longitude),
              ),
            );
            googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(value.latitude, value.longitude), zoom: 15),
              ),
            );
            PolylineResult result =
                await polylinePoints.getRouteBetweenCoordinates(
              'AIzaSyDKmLLFNfWuryZusNOe77ltmmJsJU7_XvI',
              PointLatLng(value.latitude, value.longitude),
              PointLatLng(
                double.parse(sp['lat']),
                double.parse(sp['long']),
              ),
              travelMode: TravelMode.driving,
            );

            if (result.points.isNotEmpty) {
              result.points.forEach((PointLatLng point) {
                polylineCoordinates
                    .add(LatLng(point.latitude, point.longitude));
              });
            } else {
              print(result.errorMessage);
            }
            if (routing == true) {
              addPolyLine(polylineCoordinates);
            }
          },
        );
      },
    );
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
      polylineId: id,
      color: appThemeColor,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

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

  Set<Marker> markers = {};
  Set<Polyline> _polyline = {};

  checkDistance() async {
    bool x = false;
    var lock = await loc.Location().getLocation();
    double lat1 = lock.latitude;
    double lng1 = lock.longitude;
    double lat2 = double.parse(sp['lat']);
    double lng2 = double.parse(sp['long']);
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat1 - lat2) * p) / 2 +
        c(lat2 * p) * c(lat1 * p) * (1 - c((lng1 - lng2) * p)) / 2;
    print("HelloDistance: ${(12742 * asin(sqrt(a)))}");
    setState(() {
      totalDistance = (12742 * asin(sqrt(a)));
    });
  }

  double totalDistance = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () {
            if (routing == true) {
              setState(() {
                routing = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(
            Icons.arrow_back_rounded,
          ),
        ),
        elevation: 0,
        leadingWidth: 30,
        title: ListTile(
          contentPadding: EdgeInsets.all(0),
          minVerticalPadding: 0,
          minLeadingWidth: 0,
          leading: Container(
            clipBehavior: Clip.hardEdge,
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: appThemeColor,
              shape: BoxShape.circle,
            ),
            child: sp['imageUrl'].toString() == 'null'
                ? Image(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.fill,
                  )
                : Image(
                    image: NetworkImage(sp['imageUrl']),
                    fit: BoxFit.cover,
                  ),
          ),
          title: Text(
            sp['firstname'].toString(),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          subtitle: Text(
            sp['status'] == 1 ? 'Online' : 'Offline',
            style: TextStyle(
                color: sp['status'] == 1 ? Colors.green : Colors.black),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: routing == true
            ? NeverScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Duration(
                milliseconds: 500,
              ),
              margin: EdgeInsets.only(top: 50),
              height: routing == true ? Get.height / 1.25 : Get.height / 2.5,
              child: GoogleMap(
                markers: markers,
                polylines: Set<Polyline>.of(polylines.values),
                mapType: MapType.normal,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                ].toSet(),
                onMapCreated: _onMapCreated,
                scrollGesturesEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    double.parse(sp['lat']),
                    double.parse(sp['long']),
                  ),
                  zoom: 15,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact:',
                    style: TextStyle(
                      color: appThemeColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.all(0),
                      childrenPadding: EdgeInsets.all(0),
                      title: Text(
                        "${sp['phone']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      children: [
                        ListTile(
                          onTap: () {
                            Get.dialog(
                              Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.white,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Send an sms to the given phone number.",
                                      ),
                                      Text(
                                        "(SMS charges may apply.)",
                                        style: TextStyle(
                                          fontSize: 9,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: AppTextField(
                                          controller: commentController,
                                        ),
                                      ),
                                      Center(
                                        child: AppBtn(
                                          child: Text("Send"),
                                          onPressed: () async {
                                            SimCardsProvider provider =
                                                SimCardsProvider();
                                            List<SimCard> sims =
                                                await provider.getSimCards();
                                            SmsSender sender = SmsSender();
                                            sender.sendSms(
                                              SmsMessage(sp["phone"],
                                                  commentController.text),
                                              simCard: sims[0],
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          minLeadingWidth: 0,
                          minVerticalPadding: 0,
                          dense: true,
                          leading: Icon(Icons.message_rounded),
                          title: Text('Sms'),
                        ),
                        ListTile(
                          onTap: () async {
                            await FlutterPhoneDirectCaller.callNumber(
                                sp["phone"]);
                          },
                          minLeadingWidth: 0,
                          minVerticalPadding: 0,
                          dense: true,
                          leading: Icon(Icons.call),
                          title: Text('Call'),
                        ),
                        ListTile(
                          onTap: () {},
                          minLeadingWidth: 0,
                          minVerticalPadding: 0,
                          dense: true,
                          leading: Icon(Icons.message_outlined),
                          title: Text('Direct Message'),
                        )
                      ],
                    ),
                  ),
                  Text(
                    'Description:',
                    style: TextStyle(
                      color: appThemeColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${sp['description']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Distance:',
                    style: TextStyle(
                      color: appThemeColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      if (_polyline.isEmpty) {
                        addPoly();
                      }
                      setState(() {
                        routing = true;
                      });
                    },
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    contentPadding: EdgeInsets.all(0),
                    minLeadingWidth: 0,
                    leading: Icon(
                      Icons.near_me_rounded,
                    ),
                    title: Text('${totalDistance.toStringAsFixed(2)} KM'),
                  ),
                  Text(
                    'Services:',
                    style: TextStyle(
                      color: appThemeColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    minLeadingWidth: 0,
                    leading: Image(
                      image: AssetImage(
                        sp['work'] == 'Petrolium'
                            ? 'assets/images/oil-barrel-icon-26.png'
                            : sp['work'] == 'Carwash'
                                ? 'assets/images/img_159173.png'
                                : sp['work'] == 'Tyre & Tube'
                                    ? 'assets/images/img_537354.png'
                                    : sp['work'] == 'Service'
                                        ? 'assets/images/services-icon.webp'
                                        : sp['work'] == 'Parts'
                                            ? 'assets/images/Parts+&+Accessories.png'
                                            : 'assets/images/logo.png',
                      ),
                      width: 18,
                      color: Colors.grey,
                    ),
                    title: Text('${sp['work']}'),
                  ),
                  Text(
                    'Vehicle:',
                    style: TextStyle(
                      color: appThemeColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    minLeadingWidth: 0,
                    leading: Icon(
                      sp['type'] == 'Bike'
                          ? Icons.motorcycle_rounded
                          : sp['type'] == 'Car'
                              ? Icons.directions_car_rounded
                              : sp['type'] == 'Rickshaw'
                                  ? Icons.electric_rickshaw
                                  : null,
                      color: Colors.grey,
                    ),
                    title: Text('${sp['type']}'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppBtn(
                        child: Text(
                          "Done",
                        ),
                        onPressed: () {
                          Get.dialog(
                            Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.white,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Enter the amount decided by mechanic.",
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: AppTextField(
                                        controller: amountController,
                                      ),
                                    ),
                                    Center(
                                      child: AppBtn(
                                        child: Text("Pay"),
                                        onPressed: () async {
                                          final FirebaseAuth auth =
                                              FirebaseAuth.instance;
                                          final User user = auth.currentUser;
                                          await FirebaseFirestore.instance
                                              .collection("Users")
                                              .doc(user.email)
                                              .get()
                                              .then(
                                            (value) async {
                                              FirebaseFirestore.instance
                                                  .collection("Mechanics")
                                                  .doc(sp['email'])
                                                  .collection("Wallet")
                                                  .doc(value["email"])
                                                  .set(
                                                {
                                                  "Paid by": value.data(),
                                                  "date":
                                                      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                                  "time":
                                                      "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}}",
                                                  "Recieved by":
                                                      sp["firstname"],
                                                  "amount":
                                                      amountController.text,
                                                },
                                              );
                                              Get.back();
                                              Get.snackbar(
                                                "Success",
                                                "Ammount added to the mechanic's wallet.",
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      AppBtn(
                        child: Text(
                          "Rate Mechanic",
                        ),
                        onPressed: () {
                          Get.dialog(
                            Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.white,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Review and rate the mechanic.",
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: AppTextField(
                                        controller: commentController,
                                      ),
                                    ),
                                    Center(
                                      child: RatingBar.builder(
                                        glow: false,
                                        initialRating: 3,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          setState(
                                            () {
                                              finalRating = rating;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: AppBtn(
                                        child: Text("Send"),
                                        onPressed: () async {
                                          final FirebaseAuth auth =
                                              FirebaseAuth.instance;
                                          final User user = auth.currentUser;
                                          await FirebaseFirestore.instance
                                              .collection("Users")
                                              .doc(user.email)
                                              .get()
                                              .then(
                                            (value) async {
                                              FirebaseFirestore.instance
                                                  .collection("Mechanics")
                                                  .doc(sp['email'])
                                                  .collection("FeedBack")
                                                  .doc(value["email"])
                                                  .set(
                                                {
                                                  "from": value.data(),
                                                  "feedback":
                                                      commentController.text,
                                                  "rating": finalRating
                                                },
                                              );
                                              Get.back();
                                              Get.snackbar("Success",
                                                  "Feedback sent to Mechanc.");
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double finalRating = 0.0;

  TextEditingController amountController = TextEditingController();
  TextEditingController commentController = TextEditingController();
}
