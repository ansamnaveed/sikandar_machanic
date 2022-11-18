// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mechanic/widgets/AppText/AppText.dart';
import 'package:mechanic/widgets/const.dart';

class WalletScreen extends StatefulWidget {
  ScrollController scrollcontroller = ScrollController();
  WalletScreen({Key? key, required this.scrollcontroller}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: widget.scrollcontroller,
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Center(
                child: Txt(
                  text: 'Wallet & Payment History',
                  bold: true,
                  size: 24,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                decoration: BoxDecoration(
                  color: pagesBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/images/wallet.png'),
                      width: 36,
                    ),
                    Txt(
                      text: 'Rs. $sum',
                      size: 24,
                      bold: true,
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: pagesBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Txt(
                        text: 'Customer History',
                        size: 14,
                        bold: true,
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: mechanics.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Txt(
                            text: mechanics[i]["Paid by"]["firstname"],
                          ),
                          subtitle: Txt(
                              text:
                                  '${mechanics[i]["date"]} ${mechanics[i]["time"]}'),
                          trailing: Txt(text: 'Rs. ${mechanics[i]["amount"]}'),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                mechanics[i]["Paid by"]["imageUrl"]),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  List mechanics = [];
  List<int> wallet = [];

  Future<void> getData() async {
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('Mechanics')
        .doc(auth.currentUser!.email)
        .collection("Wallet");
    final User? user = auth.currentUser;
    QuerySnapshot querySnapshot = await _collectionRef.get();
    setState(
      () {
        mechanics = querySnapshot.docs
            .map(
              (doc) => doc.data(),
            )
            .toList();
      },
    );
    setState(
      () {
        for (var i = 0; i < mechanics.length; i++) {
          wallet.add(
            int.parse(
              mechanics[i]['amount'],
            ),
          );
        }
      },
    );
    if (wallet.length == 1) {
      setState(() {
        sum = wallet[0];
      });
    } else {
      setState(() {
        sum = wallet.reduce((a, b) => a + b);
      });
    }
  }

  int sum = 0;
}
