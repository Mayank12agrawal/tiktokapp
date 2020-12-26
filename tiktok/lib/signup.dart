import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok/Navigationpage.dart';
import 'package:tiktok/home.dart';
import 'dart:io';
import './variable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signup extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // enum authProblems{
  //   email-already
  // }

  TextEditingController textcontroller = TextEditingController();
  TextEditingController usercontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool isvalid = false;
  bool isvalid1 = false;
  bool isloading = false;
  Registeruser(BuildContext ctx) async {
    setState(() {
      isvalid = false;
      isvalid1 = false;
      isloading = true;
    });
    if (passwordcontroller.text.trim().length <= 6 ||
        passwordcontroller.text.trim().contains(" ")) {
      setState(() {
        isvalid = true;
        isloading = false;
      });
      return;
    }
    setState(() {
      isvalid = false;
    });
    if (textcontroller.text.trim().isEmpty ||
        usercontroller.text.trim().isEmpty) {
      setState(() {
        isvalid1 = true;
        isloading = false;
      });
      return;
    }
    setState(() {
      isvalid1 = false;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: textcontroller.text, password: passwordcontroller.text);
      User user = userCredential.user;
      await usercollection.doc(user.uid).set({
        'email': textcontroller.text.trim(),
        'username': usercontroller.text.trim(),
        'password': passwordcontroller.text.trim(),
        'uid': user.uid,
        'profilepic': 'https://picsum.photos/250?image=9',
      });
      Navigator.of(context).pushReplacementNamed(Navigationpage.routeName);
    } on FirebaseAuthException catch (err) {
      setState(() {
        isloading = false;
      });
      if (err.code == 'email-already-in-use') {
        showDialog(
            context: ctx,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    'Error Occured',
                    style: mystyle(15, Colors.black, FontWeight.bold),
                  ),
                  content: Text(
                    'This Email is already Exist',
                    style: mystyle(14),
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'))
                  ],
                ));
      }
      if (err.code == 'invalid-email') {
        showDialog(
            context: ctx,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    'Error Occured',
                    style: mystyle(15, Colors.black, FontWeight.bold),
                  ),
                  content: Text(
                    'Please Enter a Valid Email',
                    style: mystyle(14),
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'))
                  ],
                ));
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
            height: double.infinity,
            child: Image.asset(
              'assests/images/guitar.jpg',
              fit: BoxFit.cover,
              color: Colors.black54,
              colorBlendMode: BlendMode.darken,
            )),
        SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to TikTok',
                  style: mystyle(25, Colors.white, FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: textcontroller,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                        ),
                        hintText: 'Email',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                        hintStyle: mystyle(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: usercontroller,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.grey,
                        ),
                        hintText: 'Username',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2)),
                        hintStyle: mystyle(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: SizedBox(
                    height: 60,
                    child: TextField(
                      obscureText: true,
                      controller: passwordcontroller,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.grey,
                          ),
                          hintText: ' Password',
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: isvalid
                                  ? BorderSide(
                                      color: Colors.redAccent, width: 2)
                                  : BorderSide(color: Colors.black, width: 2)),
                          hintStyle: mystyle(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                  ),
                ),
                if (isvalid)
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      'Password length should be > 6 chracters & no spaces',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                if (isvalid1)
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      'Field should not be empty',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: isloading ? () {} : () => Registeruser(context),
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20)),
                      child: isloading
                          ? CircularProgressIndicator()
                          : Text(
                              'Sign Up',
                              style: mystyle(17, Colors.white, FontWeight.w500),
                            )),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: mystyle(13, Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context)
                          .pushReplacementNamed(Navigationpage.routeName),
                      child: Text(
                        'Login',
                        style: mystyle(15, Colors.redAccent),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
