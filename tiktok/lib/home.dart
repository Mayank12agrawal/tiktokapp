import 'package:flutter/material.dart';
import './pages/videos.dart';
import './pages/addvideos.dart';
import './pages/messages.dart';
import './pages/profile.dart';
import './pages/search.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List pageoptions = [
    Videos(),
    Search(),
    Addvideos(),
    Messages(),
    Profile(FirebaseAuth.instance.currentUser.uid),
  ];
  int page = 0;
  customicon() {
    return Container(
      height: 27,
      width: 45,
      child: Stack(
        children: [
          Container(
              margin: EdgeInsets.only(left: 10),
              width: 38,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 250, 45, 108),
                borderRadius: BorderRadius.circular(7),
              )),
          Container(
              margin: EdgeInsets.only(right: 10),
              width: 38,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 32, 211, 234),
                borderRadius: BorderRadius.circular(7),
              )),
          Center(
            child: Container(
              height: double.infinity,
              width: 38,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(7)),
              child: Icon(
                Icons.add,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pageoptions[page],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              page = index;
            });
          },
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.grey,
          currentIndex: page,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  size: 30,
                ),
                label: 'search'),
            BottomNavigationBarItem(icon: customicon(), label: " "),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                  size: 30,
                ),
                label: 'message'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 30,
                ),
                label: 'person')
          ],
        ));
  }
}
