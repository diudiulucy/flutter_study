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
    // var repStr = BaiduOcr.accurateBasic(
    //     "https://www.baidu.com/img/bdlogo.png", IMAGE_TYPE.URL);
    // setState(() {
    //   access_token = repStr;
    // });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var spacer = new SizedBox(height: 32.0);
    return buildStack();
    //   return new ConstrainedBox(
    //     constraints: BoxConstraints(
    //         minWidth: double
    //             .infinity), //将Column的宽度指定为屏幕宽度；这很简单，我们可以通过ConstrainedBox或SizedBox（我们将在后面章节中专门介绍这两个Widget）来强制更改宽度限制
    //     //介绍Row和Colum时，如果子widget超出屏幕范围，则会报溢出错误
    //     child: Container(
    //       color: Colors.green,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: <Widget>[
    //           Container(
    //             color: Colors.red,
    //             child: Column(
    //               mainAxisSize: MainAxisSize.max, //无效，内层Colum高度为实际高度
    //               children: <Widget>[
    //                 Text("hello world "),
    //                 Text("I am Jack "),
    //               ],
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   );
    // }
    // return Wrap(
    //   direction: Axis.horizontal,
    //   spacing: 2.0, // 主轴(水平)方向间距
    //   runSpacing: 1.0, // 纵轴（垂直）方向间距
    //   alignment: WrapAlignment.center, //沿主轴方向居中
    //   children: <Widget>[
    //     new Chip(
    //       avatar:
    //           new CircleAvatar(backgroundColor: Colors.blue, child: Text('A')),
    //       label: new Text('Hamilton'),
    //     ),
    //     new Chip(
    //       avatar:
    //           new CircleAvatar(backgroundColor: Colors.blue, child: Text('M')),
    //       label: new Text('Lafayette'),
    //     ),
    //     new Chip(
    //       avatar:
    //           new CircleAvatar(backgroundColor: Colors.blue, child: Text('H')),
    //       label: new Text('Mulligan'),
    //     ),
    //     new Chip(
    //       avatar:
    //           new CircleAvatar(backgroundColor: Colors.blue, child: Text('J')),
    //       label: new Text('Laurens'),
    //     ),
    //   ],
    // );
    // return Flow(
    //   delegate: TestFlowDelegate(margin: EdgeInsets.all(10.0)),
    //   children: <Widget>[
    //     new Container(
    //       width: 80.0,
    //       height: 80.0,
    //       color: Colors.red,
    //     ),
    //     new Container(
    //       width: 50.0,
    //       height: 80.0,
    //       color: Colors.green,
    //     ),
    //     new Container(
    //       width: 50.0,
    //       height: 80.0,
    //       color: Colors.blue,
    //     ),
    //     new Container(
    //       width: 80.0,
    //       height: 80.0,
    //       color: Colors.yellow,
    //     ),
    //     new Container(
    //       width: 80.0,
    //       height: 80.0,
    //       color: Colors.brown,
    //     ),
    //     new Container(
    //       width: 80.0,
    //       height: 80.0,
    //       color: Colors.purple,
    //     ),
    //   ],
    // );
  }
}

Widget buildStack() {
  //通过ConstrainedBox来确保Stack占满屏幕
  // return ConstrainedBox(
  //   constraints: BoxConstraints.expand(),
  //   child: Stack(
  //     alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
  //     fit: StackFit.expand, //未定位widget占满Stack整个空间
  //     children: <Widget>[
  //       Container(
  //         child: Text("Hello world", style: TextStyle(color: Colors.white)),
  //         color: Colors.red,
  //       ),
  //       Positioned(
  //         left: 18.0,
  //         child: Text("I am Jack"),
  //       ),
  //       Positioned(
  //         top: 18.0,
  //         child: Text("Your friend"),
  //       )
  //     ],
  //   ),
  // );
  // Widget child = Positioned(
  //     // bottom: 120,
  //     left: 0,
  //     right: 0,
  //     child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         itemCount: 100,
  //         itemExtent: 50.0, //强制高度为50.0
  //         itemBuilder: (BuildContext context, int index) {
  //           return ListTile(title: Text("$index"));
  //         }));

  Widget child = Container(
      // height: 200.0,
      margin: new EdgeInsets.symmetric(vertical: 300.0),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 100,
          itemExtent: 50.0, //强制高度为50.0
          itemBuilder: (BuildContext context, int index) {
            return ListTile(title: Text("$index"));
          }));
  return Stack(
    children: [child],
  );

  // Widget child =  ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         itemCount: 100,
  //         itemExtent: 50.0, //强制高度为50.0
  //         itemBuilder: (BuildContext context, int index) {
  //           return ListTile(title: Text("$index"));
  //         }),

  // return ListView.builder(
  //     scrollDirection: Axis.horizontal,
  //     itemCount: 100,
  //     itemExtent: 50.0, //强制高度为50.0
  //     itemBuilder: (BuildContext context, int index) {
  //       return ListTile(title: Text("$index"));
  //     });
}

class TestFlowDelegate extends FlowDelegate {
  EdgeInsets margin = EdgeInsets.zero;
  TestFlowDelegate({this.margin});
  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;
    //计算每一个子widget的位置
    for (int i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i).width + x + margin.right;
      if (w < context.size.width) {
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
        x = w + margin.left;
      } else {
        x = margin.left;
        y += context.getChildSize(i).height + margin.top + margin.bottom;
        //绘制子widget(有优化)
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i).width + margin.left + margin.right;
      }
    }
  }

  @override
  getSize(BoxConstraints constraints) {
    //指定Flow的大小
    return Size(double.infinity, 200.0);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
