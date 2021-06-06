import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/page/album.dart';
import 'package:flutter_study/page/camera.dart';
import 'package:flutter_study/page/home.dart';
import 'package:flutter_study/page/picselect.dart';
import 'package:flutter_study/test/newroute.dart';
import 'package:flutter_study/test/tiproute.dart';

List<CameraDescription> cameras;

void main() async {
  //camera必须添加下面main()函数中的第一行,否则报错 WidgetsFlutterBinding是框架和flutter引擎之间的胶水
  WidgetsFlutterBinding.ensureInitialized();
  // 获取可用摄像头列表，cameras为全局变量
  cameras = await availableCameras();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/", //名为"/"的路由作为应用的home(首页)
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 注册路由表
      routes: {
        "new_page": (context) => NewRoute(),
        "/": (context) => Home(), //注册首页路由
        "tip2": (context) {
          return TipRoute(text: ModalRoute.of(context).settings.arguments);
        },
        "camera": (context) => CameraExampleHome(),
        "album": (context) => Album(),
        "picselect": (context) => PickSelect()
      },
    );
  }
}
