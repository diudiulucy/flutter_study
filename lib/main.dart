import 'package:flutter/material.dart';
import 'package:flutter_study/page/home.dart';
import 'package:flutter_study/test/newroute.dart';
import 'package:flutter_study/test/tiproute.dart';

void main() => runApp(new MyApp());

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
        "/": (context) => Home(
            // title: "Lucy Demo Home Page",
            ), //注册首页路由
        "tip2": (context) {
          return TipRoute(text: ModalRoute.of(context).settings.arguments);
        }
      },
      // home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text(widget.title),
//       ),
//       body: new Center(
//         child: new Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             new Text(
//               'You have pushed the button this many times:',
//             ),
//             new Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//             FlatButton(
//                 textColor: Colors.blue,
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) {
//                     return TipRoute(
//                       text: "hi,我是传过来的参数hhhhhhhhhhhhhh",
//                     );
//                   }));
//                   // Navigator.pushNamed(context, 'new_page');
//                   // Navigator.of(context).pushNamed('new_page', arguments: "hi");
//                   // Navigator.of(context)
//                   //     .pushNamed('tip2', arguments: "hi,我是传过来的参数");
//                 },
//                 child: Text("open new route"))
//           ],
//         ),
//       ),
//       floatingActionButton: new FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: new Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
