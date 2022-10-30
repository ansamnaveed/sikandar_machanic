// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:mechanic/mechanic/dashboard.dart';
import 'package:mechanic/login_screen.dart';
import 'package:mechanic/widgets/AppButton/AppButton.dart';
import 'package:mechanic/widgets/AppText/AppText.dart';
import 'package:mechanic/widgets/TextFields/AppTextField.dart';
import 'package:mechanic/widgets/app_logo.dart';
import 'package:mechanic/widgets/const.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MechanicDetails extends StatefulWidget {
  String name, email, phone, password;
  MechanicDetails({
    Key? key,
    required this.email,
    required this.name,
    required this.password,
    required this.phone,
  }) : super(key: key);

  @override
  State<MechanicDetails> createState() => _MechanicDetailsState();
}

List<String> type = <String>['Bike', 'Car', 'Rickshaw'];
List<String> work = <String>[
  'Petrolium',
  'Carwash',
  'Tyre & Tube',
  'Service',
  'Parts'
];
bool showSpinner = false;

class _MechanicDetailsState extends State<MechanicDetails> {
  String dropdownValue = type.first;
  String dropdownValue2 = work.first;
  String? address;
  double? myLat, myLng;
  loc.Location _location = loc.Location();
  @override
  void initState() {
    _location.getLocation().then((l) {
      myLat = l.latitude;
      myLng = l.longitude;
      getAddress(l.latitude, l.longitude);
    });
    super.initState();
  }

  getAddress(double? lat, double? lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat!, lng!);
    var first = placemarks.first;
    setState(
      () {
        address =
            '${first.subThoroughfare} ${first.thoroughfare} ${first.subLocality} ${first.locality}';
        addressController.text = address!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLogo(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Work Details',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Vehicle Type',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: appThemeColor, width: 4),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      isDense: true,
                      value: dropdownValue,
                      underline: SizedBox(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: type.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Work Type',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: appThemeColor, width: 4),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      isDense: true,
                      value: dropdownValue2,
                      underline: SizedBox(),
                      onChanged: (String? value) {
                        setState(
                          () {
                            dropdownValue2 = value!;
                          },
                        );
                      },
                      items: work.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AppTextField(
                    controller: addressController,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  AppBtn(
                    child: Text('Next'),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: widget.email, password: widget.password);
                        User? user = _auth.currentUser;
                        await FirebaseFirestore.instance
                            .collection("Mechanics")
                            .doc(widget.email)
                            .set(
                          {
                            'uid': user!.uid,
                            'phone': widget.phone,
                            'email': widget.email,
                            'password': widget.password,
                            'imageUrl': 'null',
                            'firstname': widget.name,
                            'role': 'mechanic',
                            'address': addressController.text,
                            'lat': myLat.toString(),
                            'long': myLng.toString(),
                            'type': dropdownValue,
                            'work': dropdownValue2,
                          },
                        );
                        if (newUser != null) {
                          Get.offAll(
                            Dashboard(),
                          );
                        }
                      } catch (e) {
                        Get.snackbar(
                          e
                              .toString()
                              .split('/')
                              .last
                              .split(']')
                              .first
                              .replaceAll('-', ' ')
                              .toUpperCase(),
                          e.toString().split('] ').last,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Txt(text: 'Already have an account? '),
                      HyperText(
                        text: 'Login Here',
                        onPressed: () {
                          Get.to(
                            LoginScreen(),
                          );
                        },
                        underLine: true,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final _auth = FirebaseAuth.instance;

  TextEditingController addressController = TextEditingController();
}
