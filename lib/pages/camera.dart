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
import 'package:flutter/services.dart';
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
  // void Function(int) _itemClick;
  List<GlobalKey> keys = <GlobalKey>[];

  ScrollController _controller = ScrollController();
  List tabs = [
    // "",
    "文字识别",
    "身份证识别",
    "银行卡识别",
    "表格",
    "票据识别",
    "银行卡识别",
    "表格",
    "票据识别",
    // ""
  ];
  int curItem = 0;

  _WatermarkPhotoState() {
    for (int i = 0; i < tabs.length; i++) {
      keys.add(GlobalKey(debugLabel: i.toString()));
    }
  }

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
      _cameraController
          .lockCaptureOrientation(DeviceOrientation.portraitUp); //锁住相机方向
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
        ],
      ),
    );
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
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: AspectRatio(
                aspectRatio: widget.aspectRatio ?? 5 / 7,
                child: area,
              ),
            ),
            Positioned(
                left: 10,
                right: 120,
                bottom: 200,
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
        top: MediaQuery.of(context).padding.top,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.circle, color: Colors.blue[300], size: 7),
          _initView(),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: OutlineButton(
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
          )
        ],
      );
    }

    return Positioned(bottom: 40, left: 10, right: 10, child: child);
  }

  void _itemClick(int pos) {
    setState(() {
      curItem = pos;
    });
    _scrollItemToCenter(pos);
  }

  void _scrollItemToCenter(int pos) {
    //获取item的尺寸和位置
    RenderBox box = keys[pos].currentContext.findRenderObject();
    Offset os = box.localToGlobal(Offset.zero);

    double w = box.size.width;
    double x = os.dx;
    //   获取屏幕宽高
    double windowW = MediaQuery.of(context).size.width;

    //就算当前item距离屏幕中央的相对偏移量
    double rlOffset = windowW / 2 - (x + w / 2);

    double offset = _controller.offset - rlOffset;
    _controller.animateTo(offset,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  Widget _initView() {
    return Container(
        height: 30.0,
        alignment: Alignment.center,
        // color: Colors.red,
        child: ListView.separated(
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemCount: tabs.length,
          separatorBuilder: (BuildContext context, int index) => Container(
            width: 0.0,
            color: Colors.black,
          ),
          controller: _controller,
          // itemExtent: 0.0, //强制高度为50.0
          itemBuilder: (BuildContext context, int index) {
            return _initItemView(context, index);
          },
        ));
  }

  Widget _initItemView(BuildContext context, int pos) {
    return Container(
        // width: 100,
        key: keys[pos],
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        alignment: Alignment.center,
        child: InkWell(
          onTap: () {
            _itemClick(pos);
          },
          child: Text(
            tabs[pos],
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color: curItem == pos ? Colors.blue[300] : Colors.white),
          ),
        ));
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
