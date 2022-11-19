// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mechanic/user/chat_screen.dart';
import 'package:mechanic/widgets/AppText/AppText.dart';

class ChatUsers extends StatelessWidget {
  ChatUsers({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 20),
            child: Txt(
              text: 'Chats',
              bold: true,
              size: 24,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Mechanics')
                .doc(user!.email)
                .collection("Chatters")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        Divider(
                          height: 0,
                        ),
                        ListTile(
                          onTap: () {
                            Get.to(
                              ChatScreenM(
                                data: snapshot.data!.docs[i]['User'],
                              ),
                            );
                          },
                          trailing: Txt(
                            text:
                                formatTimestamp(snapshot.data!.docs[i]['time']),
                            color: Colors.black,
                            align: TextAlign.end,
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              snapshot.data!.docs[i]['User']['imageUrl'],
                            ),
                          ),
                          subtitle: Txt(
                            text: snapshot.data!.docs[i]['last_message'],
                            color: Colors.black,
                          ),
                          title: Text(
                            snapshot.data!.docs[i]['User']['firstname'],
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Divider(
                          height: 0,
                        )
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    var format = DateFormat('dd/MM/yyyy\nH:m'); // <- use skeleton here
    return format.format(timestamp.toDate());
  }
}
