import 'package:flutter/material.dart';
import 'package:tiktok/confirmpage.dart';
import './Navigationpage.dart';
import './signup.dart';
import 'package:firebase_core/firebase_core.dart';
import './home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tiktok',
      home: Navigationpage(),
      routes: {
        Signup.routeName: (ctx) => Signup(),
        Navigationpage.routeName: (ctx) => Navigationpage(),
        Home.routeName: (ctx) => Home(),
      },
    );
  }
}
