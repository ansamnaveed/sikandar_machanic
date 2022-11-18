// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          Center(
            child: Txt(
              text: 'Ratings & Reviews',
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
                    return ListTile();
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
