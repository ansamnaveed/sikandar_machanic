// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ChatScreenUser extends StatefulWidget {
  var data;
  ChatScreenUser({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ChatScreenUser> createState() => _ChatScreenUserState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _ChatScreenUserState extends State<ChatScreenUser> {
  final User? user = auth.currentUser;
  List messages = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
          leadingWidth: 30,
          elevation: 0,
          title: ListTile(
            trailing: IconButton(
              onPressed: () async {
                await FlutterPhoneDirectCaller.callNumber(
                  widget.data["phone"],
                );
              },
              icon: Icon(
                Icons.call_rounded,
                color: Colors.white,
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            minVerticalPadding: 0,
            title: Text(
              widget.data['firstname'],
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              widget.data['phone'],
              style: TextStyle(color: Colors.white),
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                widget.data["imageUrl"],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Mechanics")
                      .doc(widget.data['email'])
                      .collection("Chatters")
                      .doc(user!.email)
                      .collection("Chat")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: snapshot.data!.docs[i]['Sent by']
                                        ['email'] ==
                                    widget.data['email']
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              snapshot.data!.docs[i]['Sent by']['email'] ==
                                      widget.data['email']
                                  ? SizedBox()
                                  : CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        snapshot.data!.docs[i]['Sent by']
                                            ['imageUrl'],
                                      ),
                                    ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: snapshot.data!.docs[i]['Sent by']
                                                ['email'] ==
                                            widget.data['email']
                                        ? Radius.circular(10)
                                        : Radius.circular(0),
                                    topRight: snapshot.data!.docs[i]['Sent by']
                                                ['email'] ==
                                            widget.data['email']
                                        ? Radius.circular(0)
                                        : Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: snapshot.data!.docs[i]['Sent by']
                                              ['email'] ==
                                          widget.data['email']
                                      ? Colors.blue.withOpacity(0.5)
                                      : Colors.blueGrey.withOpacity(0.5),
                                ),
                                child: Text(
                                  snapshot.data!.docs[i]['message'],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              snapshot.data!.docs[i]['Sent by']['email'] ==
                                      widget.data['email']
                                  ? CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        snapshot.data!.docs[i]['Sent by']
                                            ['imageUrl'],
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, top: 5.0),
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 0.75),
                  )
                ],
              ),
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                title: TextFormField(
                  textInputAction: TextInputAction.newline,
                  controller: messageController,
                  cursorColor: Color.fromRGBO(191, 95, 40, 1),
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection("Users")
                            .doc(user!.email)
                            .get()
                            .then(
                          (value) async {
                            FirebaseFirestore.instance
                                .collection("Mechanics")
                                .doc(widget.data['email'])
                                .collection("Chatters")
                                .doc(value["email"])
                                .set(
                                  {
                                    "User": value.data(),
                                    "last_message": messageController.text,
                                    "time": DateTime.now()
                                  },
                                )
                                .whenComplete(
                                  () => FirebaseFirestore.instance
                                      .collection("Mechanics")
                                      .doc(widget.data['email'])
                                      .collection("Chatters")
                                      .doc(value["email"])
                                      .collection("Chat")
                                      .doc(
                                        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
                                      )
                                      .set(
                                    {
                                      "Sent by": value.data(),
                                      "date":
                                          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                      "time":
                                          "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
                                      "Recieved by": widget.data["firstname"],
                                      "message": messageController.text,
                                    },
                                  ),
                                )
                                .whenComplete(
                                  () => messageController.clear(),
                                );
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 57,
                        height: 34,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.send_rounded, color: Colors.white),
                      ),
                    ),
                    hintText: "Message Here",
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(193, 199, 208, 1), fontSize: 14),
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController messageController = TextEditingController();

  ScrollController _scrollController = ScrollController();
  _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }
}

class ChatScreenM extends StatefulWidget {
  var data;
  ChatScreenM({super.key, required this.data});

  @override
  State<ChatScreenM> createState() => _ChatScreenMState();
}

class _ChatScreenMState extends State<ChatScreenM> {
  final User? user = auth.currentUser;
  List messages = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
          leadingWidth: 30,
          elevation: 0,
          title: ListTile(
            trailing: IconButton(
              onPressed: () async {
                await FlutterPhoneDirectCaller.callNumber(
                  widget.data["phone"],
                );
              },
              icon: Icon(
                Icons.call_rounded,
                color: Colors.white,
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            minVerticalPadding: 0,
            title: Text(
              widget.data['firstname'],
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              widget.data['phone'],
              style: TextStyle(color: Colors.white),
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                widget.data["imageUrl"],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Mechanics")
                      .doc(user!.email)
                      .collection("Chatters")
                      .doc(widget.data['email'])
                      .collection("Chat")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: snapshot.data!.docs[i]['Sent by']
                                        ['email'] ==
                                    widget.data['email']
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              snapshot.data!.docs[i]['Sent by']['email'] ==
                                      widget.data['email']
                                  ? SizedBox()
                                  : CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        snapshot.data!.docs[i]['Sent by']
                                            ['imageUrl'],
                                      ),
                                    ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: snapshot.data!.docs[i]['Sent by']
                                                ['email'] ==
                                            widget.data['email']
                                        ? Radius.circular(10)
                                        : Radius.circular(0),
                                    topRight: snapshot.data!.docs[i]['Sent by']
                                                ['email'] ==
                                            widget.data['email']
                                        ? Radius.circular(0)
                                        : Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: snapshot.data!.docs[i]['Sent by']
                                              ['email'] ==
                                          widget.data['email']
                                      ? Colors.blue.withOpacity(0.5)
                                      : Colors.blueGrey.withOpacity(0.5),
                                ),
                                child: Text(
                                  snapshot.data!.docs[i]['message'],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              snapshot.data!.docs[i]['Sent by']['email'] ==
                                      widget.data['email']
                                  ? CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        snapshot.data!.docs[i]['Sent by']
                                            ['imageUrl'],
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, top: 5.0),
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 0.75),
                  )
                ],
              ),
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                title: TextFormField(
                  textInputAction: TextInputAction.newline,
                  controller: messageController,
                  cursorColor: Color.fromRGBO(191, 95, 40, 1),
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection("Mechanics")
                            .doc(user!.email)
                            .get()
                            .then(
                          (value) async {
                            FirebaseFirestore.instance
                                .collection("Mechanics")
                                .doc(user!.email)
                                .collection("Chatters")
                                .doc(widget.data["email"])
                                .set(
                                  {
                                    "User": widget.data,
                                    "last_message": messageController.text,
                                    "time": DateTime.now()
                                  },
                                )
                                .whenComplete(
                                  () => FirebaseFirestore.instance
                                      .collection("Mechanics")
                                      .doc(user!.email)
                                      .collection("Chatters")
                                      .doc(widget.data["email"])
                                      .collection("Chat")
                                      .doc(
                                        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
                                      )
                                      .set(
                                    {
                                      "Sent by": value.data(),
                                      "date":
                                          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                      "time":
                                          "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
                                      "Recieved by": widget.data["firstname"],
                                      "message": messageController.text,
                                    },
                                  ),
                                )
                                .whenComplete(
                                  () => messageController.clear(),
                                );
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 57,
                        height: 34,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.send_rounded, color: Colors.white),
                      ),
                    ),
                    hintText: "Message Here",
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(193, 199, 208, 1), fontSize: 14),
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController messageController = TextEditingController();
}
