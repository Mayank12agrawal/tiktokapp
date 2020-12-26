import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

mystyle(double size, [Color color, FontWeight fw = FontWeight.w700]) {
  return GoogleFonts.montserrat(fontSize: size, color: color, fontWeight: fw);
}

var usercollection = FirebaseFirestore.instance.collection('users');
var videoscollection = FirebaseFirestore.instance.collection('videos');
final videosfolder = FirebaseStorage.instance.ref().child('videos');
final imagesfolder = FirebaseStorage.instance.ref().child('images');
FirebaseFirestore cloudInstance = FirebaseFirestore.instance;
