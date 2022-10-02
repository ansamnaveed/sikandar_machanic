// @dart=2.9
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:mechanic/widgets/const.dart';

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

  addPoly() async {
    await loc.Location().getLocation().then(
      (value) {
        setState(() async {
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
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            });
          } else {
            print(result.errorMessage);
          }

          addPolyLine(polylineCoordinates);
          // _polyline.add(Polyline(
          //   polylineId: PolylineId('Mechanic'),
          //   visible: true,
          //   points: <LatLng>[
          //     LatLng(
          //       value.latitude,
          //       value.longitude,
          //     ),
          //     LatLng(
          // double.parse(sp['lat']),
          // double.parse(sp['long']),
          //     ),
          //   ],
          //   color: Colors.blue,
          // ));
        });
      },
    );
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: appThemeColor,
      points: polylineCoordinates,
      width: 8,
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
            Navigator.pop(context);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              height: Get.height / 2.5,
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
                      addPoly();
                    },
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
