import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var access_token = 'Unknown';

  void postRequest() async {
    String url = "https://aip.baidubce.com/oauth/2.0/token";
    // var API_KEY = "l40T5erM8mnvjvNdgSjLqubt";
    // var SECRET_KEY = "o82euZbmUYXqO2GnwNPawlTgIQ1VYP4L";
    Options options = Options(headers: {HttpHeaders.acceptHeader: "*"});
    Dio dio = Dio();
    FormData formData = FormData.from({
      "grant_type": "client_credentials",
      "client_id": "l40T5erM8mnvjvNdgSjLqubt",
      "client_secret": "o82euZbmUYXqO2GnwNPawlTgIQ1VYP4L"
    });

    try {
      var result;
      var response = await dio.post(url, options: options, data: formData);
      if (response.statusCode == HttpStatus.OK) {
        result = response.data['access_token'];
      } else {
        result =
            'Error getting IP address:\nHttp status ${response.statusCode}';
      }

      setState(() {
        access_token = result;
      });
    } catch (exception) {}
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
