import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/signup.dart';
import 'package:tiktok/variable.dart';
import './home.dart';

class Navigationpage extends StatefulWidget {
  static const routeName = '/login';
  @override
  _NavigationpageState createState() => _NavigationpageState();
}

class _NavigationpageState extends State<Navigationpage> {
  bool islogin = false;
  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        setState(() {
          islogin = true;
        });
      } else {
        setState(() {
          islogin = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: islogin ? Home() : login(),
    );
  }
}

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController textcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool isvalid = false;
  bool isvalid1 = false;
  bool isloading = false;
  loginpage(BuildContext ctx) async {
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
    if (textcontroller.text.trim().isEmpty) {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: textcontroller.text, password: passwordcontroller.text);
    } on FirebaseAuthException catch (err) {
      setState(() {
        isloading = false;
      });
      if (err.code == 'user-not-found') {
        showDialog(
            context: ctx,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    'Error Occured',
                    style: mystyle(15, Colors.black, FontWeight.bold),
                  ),
                  content: Text(
                    'This Account does not Exist',
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
      if (err.code == 'wrong-password') {
        showDialog(
            context: ctx,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    'Error Occured',
                    style: mystyle(15, Colors.black, FontWeight.bold),
                  ),
                  content: Text(
                    'Please Enter correct password',
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
      backgroundColor: Colors.red[200],
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
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: 'Email',
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
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.lock_outline),
                        hintText: 'Password',
                        hintStyle: mystyle(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
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
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 2,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                    child: InkWell(
                      onTap: () => loginpage(context),
                      child: isloading
                          ? CircularProgressIndicator()
                          : Text(
                              'Login',
                              style: mystyle(17, Colors.white, FontWeight.w500),
                            ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: mystyle(13, Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context)
                          .pushReplacementNamed(Signup.routeName),
                      child: Text(
                        'Sign Up',
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
