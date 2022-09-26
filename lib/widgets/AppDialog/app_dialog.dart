// ignore_for_file: must_be_immutable
// @dart=2.9
import 'package:flutter/material.dart';
import 'package:mechanic/widgets/const.dart';

class AppDialog extends StatelessWidget {
  String title, subtitle;
  bool closeButton;
  VoidCallback onTapOk;
  AppDialog({
    Key key,
    this.title,
    this.subtitle,
    this.onTapOk,
    this.closeButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Image(
              width: MediaQuery.of(context).size.width * 0.25,
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: closeButton == true
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.center,
              children: [
                closeButton == true
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: appColorLight,
                          minimumSize: Size(100, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              100,
                            ),
                          ),
                        ),
                        onPressed: onTapOk,
                        child: Text(
                          'Yes',
                          style: TextStyle(
                              fontFamily: 'Janna', fontWeight: FontWeight.bold),
                        ),
                      )
                    : SizedBox(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(253, 53, 79, 1),
                    minimumSize: Size(100, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        100,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                        fontFamily: 'Janna', fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class ProgressDialog extends StatelessWidget {
  ProgressDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent,
        ),
        child: Container(
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                    height: 70, width: 70, child: CircularProgressIndicator()),
              ),
              Center(
                // padding: EdgeInsets.symmetric(vertical: 20),
                child: Image(
                  width: 50,
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
