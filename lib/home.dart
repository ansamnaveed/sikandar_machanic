import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechanic/widgets/const.dart';

class HomeScreen extends StatefulWidget {
  ScrollController scrollcontroller = ScrollController();
  HomeScreen({Key? key, required this.scrollcontroller}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: Get.height,
            child: Image(
              image: AssetImage('assets/images/map.png'),
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Image(
              image: AssetImage(
                'assets/images/pin.png',
              ),
              width: 30,
              color: appThemeColor,
            ),
          ),
        ],
      ),
    );
  }
}
