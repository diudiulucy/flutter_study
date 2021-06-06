import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DisplayPictureScreen.dart';
import 'mydrawer.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  // Home({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  TabController _tabController; //需要定义一个Controller
  List tabs = ["新闻", "历史", "图片"];
  var _imgPath;

  @override
  void initState() {
    super.initState();
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      switch (_tabController.index) {
        // case 1:
      }
    });
  }

  //销毁时调用
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
        bottom: TabBar(
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList()),
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "主页"),
          BottomNavigationBarItem(icon: Icon(Icons.file_present), label: "文档"),
          BottomNavigationBarItem(icon: Icon(null), label: "拍照"),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "计算"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.account_balance), label: "用户"),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.account_balance), label: "用户"),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed, // 当items大于3时需要设置此类型
        fixedColor: Colors.blue,
        // elevation: 20,
        onTap: _onItemTapped,
      ),
      // bottomNavigationBar: BottomAppBar(
      //     color: Colors.white,
      //     shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
      //     child: Row(
      //       children: [
      //         IconButton(icon: Icon(Icons.home), onPressed: _openAlbum),
      //         SizedBox(), //中间的位置空出
      //         IconButton(icon: Icon(Icons.calculate), onPressed: _openGallery)
      //       ],
      //       mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
      //     )),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((e) {
          return Container(
            alignment: Alignment.center,
            child: Text(e, textScaleFactor: 5),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_a_photo),
          onPressed: () {
            Navigator.pushNamed(context, 'camera');
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
    setState(() {
      _selectedIndex = index;
    });
  }
}
