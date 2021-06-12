import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_study/util/BaiduOcr.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final OCR_TYPE orcType;

  final String text;
  const DisplayPictureScreen(
      {Key key, @required this.imagePath, this.orcType, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("识别结果"),
      ),
      body: new Column(
        children: <Widget>[
          Text(text),
        ],
      ),
    );
  }
}
