// ignore_for_file: import_of_legacy_library_into_null_safe

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
                      text: '\$ 20',
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
                      itemCount: 10,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Txt(text: 'Customer Name'),
                          subtitle: Txt(text: 'Address'),
                          trailing: Txt(text: '\$ 20'),
                          leading: CircleAvatar(),
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
}
