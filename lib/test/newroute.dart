import 'package:flutter/material.dart';

class NewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //获取路由参数
    var args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: new AppBar(
        title: Text("new route"),
      ),
      body: Center(
        child: Text("this is new rout"),
      ),
    );
  }
}
