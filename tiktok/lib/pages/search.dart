import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:tiktok/pages/profile.dart';
import 'package:tiktok/variable.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<QuerySnapshot> searchresult;
  searchUser(String typesUser) {
    var users = cloudInstance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: typesUser)
        .get();
    setState(() {
      searchresult = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffECE5DA),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Container(
          decoration: BoxDecoration(
              color: Colors.white10, borderRadius: BorderRadius.circular(25)),
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            onFieldSubmitted: searchUser,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: 'Seach Here',
              hintStyle: mystyle(
                17,
                Colors.white,
                FontWeight.w500,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: searchresult == null
          ? Center(
              child: Text(
                'Search for a TikToker',
                style: mystyle(20),
              ),
            )
          : FutureBuilder(
              future: searchresult,
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (ctx, index) {
                      DocumentSnapshot user = snapshot.data.docs[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Profile(snapshot.data.docs[index]['uid'])));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage(user.data()['profilepic']),
                          ),
                          title: Text(
                            user.data()['username'],
                            style: mystyle(15),
                          ),
                        ),
                      );
                    });
              }),
    );
  }
}
