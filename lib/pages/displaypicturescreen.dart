import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_study/util/BaiduOcr.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, @required this.imagePath})
      : super(key: key);

  void testImage() {
    print("testImage" + this.imagePath);
    // BaiduOcr.accurateBasic(this.imagePath, IMAGE_TYPE.IMAGE);
    BaiduOcr.idCard(this.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("图片识别"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.file(File(imagePath)),
          new RaisedButton(
            onPressed: testImage,
            child: new Text('开始识别'),
          ),
        ],
      ),
    );
  }
}
