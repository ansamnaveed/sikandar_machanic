// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mechanic/widgets/AppDialog/app_dialog.dart';
import 'package:sms/sms.dart';
import 'package:mechanic/dashboard.dart';
import 'package:mechanic/user_dashboard.dart';
import 'package:provider/provider.dart';
import 'package:mechanic/login_screen.dart';
import 'package:mechanic/widgets/Scroll/Scroll.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(
    () => print('done dona done done'),
  );
  runApp(
    MyApp(),
  );
  SmsReceiver receiver = SmsReceiver();
  receiver.onSmsReceived.listen(
    (SmsMessage msg) => AppDialog(
      title: msg.sender,
      subtitle: msg.body,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        )
      ],
      child: GetMaterialApp(
        scrollBehavior: AppScrollBehavior(),
        title: 'Sikandar Mechanic',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          canvasColor: Colors.white,
        ),
        home: Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatefulWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String role;

  checkExist(String email) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(email)
          .get()
          .then(
        (doc) async {
          if (doc.exists == true) {
            setState(() {
              role = 'user';
            });
          } else if (doc.exists == false) {
            await FirebaseFirestore.instance
                .collection('Mechanics')
                .doc(email)
                .get()
                .then(
              (value) {
                setState(() {
                  role = 'mechanic';
                });
              },
            );
            print(role + '000000000000000000000000000000000000000000000');
          }
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    if (user != null) {
      checkExist(user.email);
      return role == 'mechanic' ? Dashboard() : UserDashboard();
    }
    return LoginScreen();
  }
}

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<User> get authStateChanges => _auth.idTokenChanges();
  Future<User> login(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user;

    return user;
  }

  Future<User> signUp(email, password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user;

    return user;
  }
}
