import 'package:flutter/material.dart';
import 'package:tiktok/confirmpage.dart';
import 'dart:async';
import 'dart:io';
import '../variable.dart';
import 'package:image_picker/image_picker.dart';

class Addvideos extends StatefulWidget {
  @override
  _AddvideosState createState() => _AddvideosState();
}

class _AddvideosState extends State<Addvideos> {
  pickvideo(ImageSource src) async {
    Navigator.of(context).pop();
    final video = await ImagePicker().getVideo(source: src);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Confirm(File(video.path), video.path, src)));
  }

  showdialogoption() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Open with'),
            children: [
              SimpleDialogOption(
                onPressed: () => pickvideo(ImageSource.gallery),
                child: Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => pickvideo(ImageSource.camera),
                child: Text(
                  'Camera',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
          child: InkWell(
        onTap: () => showdialogoption(),
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 2,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'Upload Tiktok',
            style: mystyle(18, Colors.white, FontWeight.normal),
          ),
        ),
      )),
    );
  }
}
