import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _imageUrls = [
    'lib/assets/images/home/swiper1.jpg',
    'lib/assets/images/home/swiper2.jpg',
    'lib/assets/images/home/swiper3.jpg',
    // 'http://img5.mtime.cn/mg/2020/08/10/120400.47292216.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   title: Text("识票AI"),
      //   backgroundColor: Colors.transparent,
      // ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              child: Swiper(
                itemCount: _imageUrls.length,
                autoplay: true,
                itemBuilder: (BuildContext context, int index) {
                  // return Image.network(
                  //   _imageUrls[index],
                  //   fit: BoxFit.fill,
                  // );
                  return Image.asset(_imageUrls[index], fit: BoxFit.cover);
                },
                pagination: SwiperPagination(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
