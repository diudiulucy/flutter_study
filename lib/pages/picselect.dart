import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';

class PickSelect extends StatefulWidget {
  @override
  _PickSelectState createState() => _PickSelectState();
}

class _PickSelectState extends State<PickSelect> {
  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();
    loadAssets();
  }

  Widget buildGridView() {
    return GridView(
      //划分网格
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //横轴固定数量子元素
          crossAxisCount: 3, //横轴子元素数量
          mainAxisSpacing: 2.0, //主轴间距
          crossAxisSpacing: 2.0, //横轴间距
          childAspectRatio: 1.0 //子元素放置比例
          ),
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
            // 显示所有照片，值为 false 时显示相册
            startInAllView: false,
            actionBarColor: "#abcdef",
            // actionBarTitle: "Example App",
            allViewTitle: "所有照片",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
            textOnNothingSelected: '没有选择照片'),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择图片'),
      ),
      body: Column(
        children: <Widget>[
          // ElevatedButton(
          //   child: Text("Pick images"),
          //   onPressed: loadAssets,
          // ),
          Expanded(
            child: buildGridView(),
          )
        ],
      ),
    );
    // }
  }
}
