import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

// import 'package:amap_location/amap_location.dart';
import 'package:camera/camera.dart';
import 'package:date_format/date_format.dart';
// import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_study/pages/displaypicturescreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_study/util/BaiduOcr.dart';
import '../main.dart';
// import 'package:stmy_mobile/plugin/amap/amap_location.dart';
// import 'package:stmy_mobile/plugin/amap/amap_location_option.dart';
// import 'package:stmy_mobile/utils/permission_util.dart';
// import 'package:xfile/xfile.dart';

class WatermarkPhoto extends StatefulWidget {
  static const String SAVE_DIR = 'tempImage';

  final double aspectRatio;
  final double pixelRatio;

  WatermarkPhoto({this.aspectRatio, this.pixelRatio});

  @override
  _WatermarkPhotoState createState() => _WatermarkPhotoState();
}

class _WatermarkPhotoState extends State<WatermarkPhoto>
    with WidgetsBindingObserver {
  final GlobalKey _cameraKey = GlobalKey();
  CameraController _cameraController;
  // TabController _tabController; //需要定义一个Controller
  OCR_TYPE ocrType = OCR_TYPE.BASE;
  String _time;
  String _address;
  TakeStatus _takeStatus = TakeStatus.preparing;
  XFile _curFile;
  // Timer _timer;
  bool _isCapturing = false;
  List tabs = ["文字识别", "身份证识别", "银行卡识别", "表格", "票据识别", "银行卡识别", "表格", "票据识别"];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // AMapLocation.init(AMapLocationOption());
    _time =
        formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
    _address = '未知位置';
    _initCamera();
  }

  void _initCamera() async {
    try {
      // _timer?.cancel();
      // _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //   if (mounted) {
      //     setState(() {
      //       _time = formatDate(
      //           DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
      //     });
      //   }
      // });
      setState(() {
        _takeStatus = TakeStatus.preparing;
      });
      // List cameras = await availableCameras();
      // print("xiangjilieb ");
      // print(cameras.length);
      _cameraController = CameraController(
        cameras.last,
        // _cameraController.description,
        ResolutionPreset.max,
        enableAudio: false,
        // imageFormatGroup: ImageFormatGroup.jpeg,
      );
      _cameraController.addListener(() {
        if (mounted) setState(() {});
      });
      await _cameraController.initialize();
      if (mounted) {
        setState(() {
          _takeStatus = TakeStatus.taking;
        });
      }
      // if (await checkLocationPermission()) {
      //   LocationInfo info = await AMapLocation.getLocation(true);
      //   if (info.isSuccess()) {
      //     String address = info.formattedAddress;
      //     if ((address == null || address.isEmpty) && (info.province != null)) {
      //       address = info.province + info.city + info.district;
      //     }
      //     setState(() {
      //       _address = address;
      //     });
      //   }
      // }
    } on CameraException catch (e) {
      print(e);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_cameraController != null) {
        _initCamera();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    // AMapLocation.destroy();
    // _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildCameraArea(),
          _buildTopBar(),
          _buildAction(),
          _buildTabs(),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    Widget child;
    if (_cameraController != null && _cameraController.value.isInitialized) {
      child = Container(
        height: 40.0,
        color: Colors.red,
        alignment: Alignment.center,
        // margin: new EdgeInsets.symmetric(vertical: 300.0),
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tabs.length,
            separatorBuilder: (BuildContext context, int index) => Container(
                  width: 0.0,
                  color: Colors.black,
                ),

            // itemExtent: 0.0, //强制高度为50.0
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  // width: 100,
                  child: FlatButton(
                      onPressed: () {
                        setState(() {
                          ocrType = OCR_TYPE.values[index];
                        });
                      },
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: Colors.white,
                          // fontSize: 20.0,
                        ),
                      )));
            }),
      );
    } else {
      child = Container(
        color: Colors.black,
      );
    }
    return Positioned(bottom: 130, left: 0, right: 0, child: child);
  }

  Widget _buildCameraArea() {
    Widget area;
    if (_takeStatus == TakeStatus.confirm && _curFile != null) {
      area = Image.file(
        File(_curFile.path),
        fit: BoxFit.fitWidth,
      );
    } else if (_cameraController != null &&
        _cameraController.value.isInitialized) {
      final double screenWidth = MediaQuery.of(context).size.width;
      area = ClipRect(
        child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Container(
                  width: screenWidth,
                  height: screenWidth * _cameraController.value.aspectRatio,
                  child: CameraPreview(_cameraController),
                ))),
      );
    } else {
      area = Container(
        color: Colors.black,
      );
    }

    return Center(
      child: RepaintBoundary(
        key: _cameraKey,
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: widget.aspectRatio ?? 5 / 6,
              child: area,
            ),
            Positioned(
                left: 10,
                right: 120,
                bottom: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _time ?? '',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    Text(
                      _address ?? '',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    double iconSize = 28;
    Icon flashIcon = Icon(
      Icons.flash_auto,
      size: iconSize,
    );

    if (_cameraController != null && _cameraController.value.isInitialized) {
      switch (_cameraController.value.flashMode) {
        case FlashMode.auto:
          flashIcon = Icon(
            Icons.flash_auto,
            size: iconSize,
          );
          break;
        case FlashMode.off:
          flashIcon = Icon(
            Icons.flash_off,
            size: iconSize,
          );
          break;
        case FlashMode.always:
        case FlashMode.torch:
          flashIcon = Icon(
            Icons.flash_on,
            size: iconSize,
          );
          break;
      }
    }

    if (_takeStatus == TakeStatus.confirm) {
      return Container();
    }

    return Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 5,
        right: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                color: Colors.white,
                icon: Icon(
                  Icons.navigate_before,
                  size: 32,
                ),
                onPressed: () => Navigator.of(context).pop()),
            IconButton(
                color: Colors.white, icon: flashIcon, onPressed: _toggleFlash)
          ],
        ));
  }

  Widget _buildAction() {
    Widget child;
    if (_takeStatus == TakeStatus.confirm) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlineButton(
              shape: CircleBorder(),
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.all(10),
              borderSide: BorderSide(color: Colors.grey),
              child: Icon(Icons.close, color: Colors.white),
              onPressed: _cancel),
          OutlineButton(
              shape: CircleBorder(),
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.all(10),
              borderSide: BorderSide(color: Colors.grey),
              child: Icon(Icons.done, color: Colors.white),
              onPressed: _confirm)
        ],
      );
    } else {
      child = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Row(
          //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     RaisedButton(
          //         color: Colors.white,
          //         child: new Text('文字识别'),
          //         onPressed: () {
          //           setState(() {
          //             ocrType = OCR_TYPE.BASE;
          //           });
          //         }),
          //     RaisedButton(
          //         color: Colors.white,
          //         child: new Text('身份证识别'),
          //         onPressed: () {
          //           setState(() {
          //             ocrType = OCR_TYPE.IDCARD;
          //           });
          //         }),
          //     // RaisedButton(
          //     //     color: Colors.white,
          //     //     child: new Text('银行卡识别'),
          //     //     onPressed: () {
          //     //       setState(() {
          //     //         ocrType = OCR_TYPE.BANKCARD;
          //     //       });
          //     //     }),
          //     RaisedButton(
          //         color: Colors.white,
          //         child: new Text('表格'),
          //         onPressed: () {
          //           setState(() {
          //             ocrType = OCR_TYPE.FORM;
          //           });
          //         })
          //   ],
          // ),
          OutlineButton(
              shape: CircleBorder(),
              color: Colors.grey,
              padding: EdgeInsets.all(2),
              borderSide: BorderSide(color: Colors.grey),
              child: Icon(
                Icons.circle,
                color: Colors.white,
                size: 60,
              ),
              onPressed: _takePicture),
        ],
      );
    }

    return Positioned(bottom: 50, left: 50, right: 50, child: child);
  }

  /// 切换闪光灯
  void _toggleFlash() {
    if (_cameraController == null) return;

    switch (_cameraController.value.flashMode) {
      case FlashMode.auto:
        _cameraController.setFlashMode(FlashMode.always);
        break;
      case FlashMode.off:
        _cameraController.setFlashMode(FlashMode.auto);
        break;
      case FlashMode.always:
      case FlashMode.torch:
        _cameraController.setFlashMode(FlashMode.off);
        break;
    }
  }

  /// 拍照
  void _takePicture() async {
    if (_cameraController == null || _cameraController.value.isTakingPicture)
      return;
    // _timer?.cancel();

    XFile file = await _cameraController.takePicture();
    setState(() {
      _curFile = file;
      _takeStatus = TakeStatus.confirm;
    });
  }

  /// 取消。重新拍照
  void _cancel() {
    setState(() {
      _takeStatus = TakeStatus.preparing;
    });
    // _cameraController?.dispose();
    // _initCamera();
  }

  void startRecognition() {
    switch (this.ocrType) {
      case OCR_TYPE.BASE:
        BaiduOcr.accurateBasic(_curFile.path, IMAGE_TYPE.IMAGE, (data) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DisplayPictureScreen(
                imagePath: _curFile.path,
                orcType: this.ocrType,
                text: data.toString());
          }));
        });
        break;
      case OCR_TYPE.IDCARD:
        BaiduOcr.idCard(_curFile.path, (data) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DisplayPictureScreen(
                imagePath: _curFile.path,
                orcType: this.ocrType,
                text: data.toString());
          }));
        });
        break;
      case OCR_TYPE.BANKCARD:
        BaiduOcr.bankCard(_curFile.path, (data) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DisplayPictureScreen(
                imagePath: _curFile.path,
                orcType: this.ocrType,
                text: data.toString());
          }));
        });
        break;
      case OCR_TYPE.FORM:
        BaiduOcr.form(_curFile.path, (data) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DisplayPictureScreen(
                imagePath: _curFile.path,
                orcType: this.ocrType,
                text: data.toString());
          }));
        });
        break;
      default:
        break;
    }

    print("testImage" + _curFile.path);
  }

  /// 确认。返回图片数据
  void _confirm() async {
    if (_isCapturing) return;
    _isCapturing = true;
    try {
      RenderRepaintBoundary boundary =
          _cameraKey.currentContext.findRenderObject();
      ui.Image image =
          await boundary.toImage(pixelRatio: widget.pixelRatio ?? 2.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List imgBytes = byteData.buffer.asUint8List();
      String basePath = await findSavePath(WatermarkPhoto.SAVE_DIR);
      File file =
          File('$basePath/${DateTime.now().millisecondsSinceEpoch}.jpg');
      file.writeAsBytesSync(imgBytes);
      // Navigator.of(context).pop(file);
      setState(() {
        _takeStatus = TakeStatus.preparing;
      });
      startRecognition();
    } catch (e) {
      print(e);
    }
    _isCapturing = false;
  }

  Future<String> findSavePath([String basePath]) async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    if (basePath == null) {
      return directory.path;
    }
    String saveDir = directory.path + "/" + basePath;
    Directory root = Directory(saveDir);
    if (!root.existsSync()) {
      await root.create();
    }
    return saveDir;
  }
}

enum TakeStatus {
  /// 准备中
  preparing,

  /// 拍摄中
  taking,

  /// 待确认
  confirm,

  /// 已完成
  done
}

Future<File> takeWatermarkPhoto(
  BuildContext context, {
  double aspectRatio,
  double pixelRatio,
}) async {
  return await Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return WatermarkPhoto(aspectRatio: aspectRatio, pixelRatio: pixelRatio);
    },
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
        FadeTransition(
      opacity: animation,
      child: child,
    ),
  ));
}
