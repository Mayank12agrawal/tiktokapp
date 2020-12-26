import 'package:flutter/material.dart';
import 'package:tiktok/variable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  final String uid;
  Profile(this.uid);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName;
  String profilePic;
  String onlineUser;
  int likes = 0;
  bool _isDataThere = false;
  int followers;
  int following;
  bool isfollowing = false;
  TextEditingController _userNameCon = TextEditingController();

  Future myVideos;

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  getAllData() async {
    // get videos data
    myVideos = cloudInstance
        .collection('videos')
        .where('uid', isEqualTo: widget.uid)
        .get();

// get user data
    final userDoc =
        await cloudInstance.collection('users').doc(widget.uid).get();
    userName = userDoc.data()['username'];
    profilePic = userDoc.data()['profilepic'];

    // get likes
    final doc = await myVideos;
    final followerdoc =
        await usercollection.doc(widget.uid).collection('followers').get();

    final followingdoc =
        await usercollection.doc(widget.uid).collection('following').get();
    followers = followerdoc.docs.length;
    following = followingdoc.docs.length;

    usercollection
        .doc(widget.uid)
        .collection('followers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      if (!value.exists) {
        setState(() {
          isfollowing = false;
        });
      } else {
        setState(() {
          isfollowing = true;
        });
      }
    });

    for (var item in doc.docs) {
      likes = item.data()['likes'].length + likes;
    }
    setState(() {
      _isDataThere = true;
    });
  }

  followUser() async {
    var doc = await cloudInstance
        .collection('users')
        .doc(widget.uid)
        .collection('followers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    if (!doc.exists) {
      cloudInstance
          .collection('users')
          .doc(widget.uid)
          .collection('followers')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({});

      cloudInstance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('following')
          .doc(widget.uid)
          .set({});
      setState(() {
        isfollowing = true;
        followers++;
      });
    } else {
      cloudInstance
          .collection('users')
          .doc(widget.uid)
          .collection('followers')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .delete();

      cloudInstance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('following')
          .doc(widget.uid)
          .delete();
      setState(() {
        isfollowing = false;
        followers--;
      });
    }
  }

  editProfile(uid) {
    return showDialog(
        context: context,
        builder: (ctx) => Dialog(
              child: Container(
                alignment: Alignment.center,
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hey, Edit your Profile",
                      style: mystyle(18, Colors.black, FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        controller: _userNameCon,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: mystyle(
                            18,
                            Colors.grey,
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        cloudInstance.collection('users').doc(uid).update(
                          {'username': _userNameCon.text.trim()},
                        );
                        setState(() {
                          userName = _userNameCon.text.trim();
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 2,
                        height: 40,
                        color: Colors.redAccent,
                        child: Text(
                          "Update",
                          style: mystyle(
                            18,
                            Colors.white,
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isDataThere == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 12),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(profilePic),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(userName,
                        style: mystyle(15, Colors.black, FontWeight.w500)),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          followers.toString(),
                          style: mystyle(15, Colors.black, FontWeight.w500),
                        ),
                        Text(
                          following.toString(),
                          style: mystyle(15, Colors.black, FontWeight.w500),
                        ),
                        Text(
                          likes.toString(),
                          style: mystyle(15, Colors.black, FontWeight.w500),
                        )
                      ],
                    ),
                    SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Followers',
                          style: mystyle(17, Colors.grey, FontWeight.w700),
                        ),
                        Text(
                          'Following',
                          style: mystyle(17, Colors.grey, FontWeight.w700),
                        ),
                        Text(
                          'Likes',
                          style: mystyle(17, Colors.grey, FontWeight.w700),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    widget.uid == FirebaseAuth.instance.currentUser.uid
                        ? InkWell(
                            onTap: () => editProfile(
                                FirebaseAuth.instance.currentUser.uid),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.redAccent,
                              ),
                              child: Center(
                                child: Text('Edit Profile',
                                    style: mystyle(
                                        15, Colors.white, FontWeight.w500)),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () => followUser(),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.redAccent,
                              ),
                              child: Center(
                                child: Text(isfollowing ? 'UnFollow' : 'Follow',
                                    style: mystyle(
                                        15, Colors.white, FontWeight.w500)),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'My Videos',
                      style: mystyle(15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                      future: myVideos,
                      builder: (ctx, snapShot) {
                        if (!snapShot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapShot.data.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                          ),
                          itemBuilder: (ctx, index) => Container(
                            child: Image(
                              image: NetworkImage(
                                snapShot.data.docs[index]['previewimage'],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
