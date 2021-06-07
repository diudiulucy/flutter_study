import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/http/DioManager.dart';
import 'package:flutter_study/util/BaiduOcr.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var access_token = 'Unknown';

  void postRequest() {
    var repStr = BaiduOcr.accurateBasic(
        "https://www.baidu.com/img/bdlogo.png", IMAGE_TYPE.URL);
    setState(() {
      access_token = repStr;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);

    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('Your current IP address is:'),
            new Text('$access_token.'),
            spacer,
            new RaisedButton(
              onPressed: postRequest,
              child: new Text('Get IP address'),
            ),
          ],
        ),
      ),
    );
  }
}
