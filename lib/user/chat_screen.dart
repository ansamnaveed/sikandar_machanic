import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, required ScrollController scrollcontroller})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
          elevation: 0,
          centerTitle: true,
          title: Image(
            image: AssetImage(
              'assets/images/white_logo.png',
            ),
            width: 50,
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
            Padding(
              padding: EdgeInsets.all(10),
              child: ListTile(
                leading: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://nettv4u.com/imagine/andrew-garfield.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                dense: true,
                title: Text(
                  'Captain',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                subtitle: Text(
                  "widget.recieverName.toString()",
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                      height: 1,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    return Align();
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
                color: Colors.transparent,
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
                leading: SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image(
                        image: AssetImage(
                            'assets/images/icons/Icon-Menu & Layout-Grid.png'),
                        width: 16,
                      )
                    ],
                  ),
                ),
                title: TextFormField(
                  textInputAction: TextInputAction.newline,
                  controller: messageController,
                  cursorColor: Color.fromRGBO(191, 95, 40, 1),
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () async {
                        messageController.clear();
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
