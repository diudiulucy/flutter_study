import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/page/picselect.dart';
import 'package:flutter_study/test/newroute.dart';
import 'package:flutter_study/test/tiproute.dart';
import 'DisplayPictureScreen.dart';
import 'album.dart';
import 'camera.dart';
import 'mydrawer.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  // Home({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  //需要定义一个Controller
  PageController _pageController = PageController(
    initialPage: 0,
  );
  var _imgPath;

  @override
  void initState() {
    super.initState();
  }

  //销毁时调用
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("扫描AI"),
        leading: Builder(builder: (context) {
          return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
        }),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share), onPressed: () => {})
        ],
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "主页"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "文档"),
          BottomNavigationBarItem(icon: Icon(null), label: "拍照"),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "计算"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed, // 当items大于3时需要设置此类型
        fixedColor: Colors.blue,
        // elevation: 20,
        onTap: _onItemTapped,
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          PickSelect(),
          Album(),
          CameraExampleHome(),
          NewRoute(),
          TipRoute(text: "测试"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_a_photo),
          onPressed: () {
            Navigator.pushNamed(context, 'camera');
            // Navigator.pushNamed(context, 'picselect');
          }
          // _takePhoto,
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /*拍照*/
  void _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imgPath = image;
    });
  }

  /*相册*/
  void _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DisplayPictureScreen(
        imagePath: image.path,
      );
    }));
    setState(() {
      _imgPath = image;
    });
  }

  void _openAlbum() {
    Navigator.pushNamed(context, 'album');
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }
}
