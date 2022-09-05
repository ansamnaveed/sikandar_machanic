// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechanic/dashboard.dart';
import 'package:mechanic/login_screen.dart';
import 'package:mechanic/widgets/AppButton/AppButton.dart';
import 'package:mechanic/widgets/AppText/AppText.dart';
import 'package:mechanic/widgets/TextFields/AppTextField.dart';
import 'package:mechanic/widgets/app_logo.dart';
import 'package:mechanic/widgets/const.dart';

class MechanicDetails extends StatefulWidget {
  const MechanicDetails({Key? key}) : super(key: key);

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

class _MechanicDetailsState extends State<MechanicDetails> {
  String dropdownValue = type.first;
  String dropdownValue2 = work.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      setState(() {
                        dropdownValue2 = value!;
                      });
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
                  onPressed: () {
                    Get.to(
                      Dashboard(),
                    );
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
    );
  }

  TextEditingController addressController = TextEditingController();
}
