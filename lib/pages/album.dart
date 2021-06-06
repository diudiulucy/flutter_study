import 'package:flutter/material.dart';

class Album extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: new Text('获取网络图片')),
        body: GridView(
          //划分网格
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //横轴固定数量子元素
              crossAxisCount: 3, //横轴子元素数量
              mainAxisSpacing: 2.0, //主轴间距
              crossAxisSpacing: 2.0, //横轴间距
              childAspectRatio: 1.0 //子元素放置比例
              ),
          children: <Widget>[
            new Image.network(
                'http://img5.mtime.cn/mg/2020/08/14/145018.89856988_285X160X4.jpg',
                fit: BoxFit.cover),
            new Image.network(
                'http://img5.mtime.cn/mg/2020/08/14/083852.73752310_285X160X4.jpg',
                fit: BoxFit.cover),
            new Image.network(
                'http://img5.mtime.cn/mg/2020/08/10/120400.47292216.jpg',
                fit: BoxFit.cover),
            new Image.network(
                'http://img5.mtime.cn/mg/2020/07/23/201005.49303255_270X405X4.jpg',
                fit: BoxFit.cover),
            new Image.network(
                'http://img5.mtime.cn/mg/2020/08/02/162809.52117921_270X405X4.jpg',
                fit: BoxFit.cover),
            new Image.network(
                'http://img5.mtime.cn/mg/2020/07/24/084255.58952810_270X405X4.jpg',
                fit: BoxFit.cover),
            new Image.network(
                'http://img5.mtime.cn/mg/2020/07/24/105612.82558632_270X405X4.jpg',
                fit: BoxFit.cover),
            new Image.network(
                'http://img5.mtime.cn/mg/2020/08/14/091552.47653984_285X160X4.jpg',
                fit: BoxFit.cover),
          ],
        ));
  }
}
