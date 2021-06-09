import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/main.dart';
import 'package:path_provider/path_provider.dart';
import 'DisplayPictureScreen.dart';
// import 'package:video_player/video_player.dart';

class CameraExampleHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CameraExampleHomeState();
  }
}

class _CameraExampleHomeState extends State<CameraExampleHome>
    with WidgetsBindingObserver {
  CameraController controller;
  // VideoPlayerController videoController;
  String imagePath; // 图片保存路径
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool enableAudio = true;

  @override
  void initState() {
    super.initState();
    // 监听APP状态改变，是否在前台
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 如果APP不在在前台
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // 在前台
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  //展示预览窗口
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      onNewCameraSelected(cameras[0]);
      return const Text(
        '',
        style: TextStyle(
            color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w900),
      );
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      );
    }
  }

  /// 相机工具栏
  Widget _captureControlRowWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: Image.asset("lib/assets/images/camera/circle.png",
                  fit: BoxFit.cover),
              color: Colors.blue,
              onPressed: controller != null &&
                      controller.value.isInitialized &&
                      !controller.value.isRecordingVideo
                  ? onTakePictureButtonPressed
                  : null,
            ),
          ],
        ),
      ),
    );
    // );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   mainAxisSize: MainAxisSize.max,
    //   children: <Widget>[
    //     IconButton(
    //       icon: const Icon(Icons.camera_alt),
    //       color: Colors.blue,
    //       onPressed: controller != null &&
    //               controller.value.isInitialized &&
    //               !controller.value.isRecordingVideo
    //           ? onTakePictureButtonPressed
    //           : null,
    //     ),
    //     IconButton(
    //         icon: const Icon(Icons.videocam),
    //         color: Colors.blue,
    //         onPressed: null
    //         // controller != null &&
    //         //     controller.value.isInitialized &&
    //         //     !controller.value.isRecordingVideo
    //         //     ? onVideoRecordButtonPressed
    //         //     : null,
    //         ),
    //     IconButton(
    //         icon: const Icon(Icons.stop), color: Colors.red, onPressed: null
    //         // controller != null &&
    //         //     controller.value.isInitialized &&
    //         //     controller.value.isRecordingVideo
    //         //     ? onStopButtonPressed
    //         //     : null,
    //         )
    //   ],
    // );
  }

  /// 获取不同摄像头的图标（前置、后置、其它）
  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
    }
    throw ArgumentError('Unknown lens direction');
  }

  // 摄像头选中回调
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: enableAudio,
    );

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  //展示所有摄像头
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];
    if (cameras.isEmpty) {
      return const Text('没有检测到摄像头');
    } else {
      for (CameraDescription cameraDescription in cameras) {
        toggles.add(SizedBox(
          width: 90,
          child: RadioListTile<CameraDescription>(
            title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
            groupValue: controller?.description,
            value: cameraDescription,
            onChanged: controller != null && controller.value.isRecordingVideo
                ? null
                : onNewCameraSelected,
          ),
        ));
      }
    }
    return Row(children: toggles);
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          // videoController?.dispose();
          // videoController = null;
        });
        // if (filePath != null) showInSnackBar('图片保存在 $filePath');
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar("错误，请选择一个相机");
      return null;
    }
    //https://www.jianshu.com/p/2eafae001f55
    //getApplicationDocumentsDirectory 如果要让用户看到数据，请考虑改用[getExternalStorageDirectory]。
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DisplayPictureScreen(
          imagePath: filePath,
        );
      }));
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _cameraWidget() {
    return Expanded(
      flex: 1,
      child: Stack(
        children: <Widget>[_cameraPreviewWidget(), _cameraScan()],
      ),
    );
  }

  Widget _cameraScan() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Image.asset("images/scan.png"),
    );
  }

  Widget _cameraButton() {
    return GestureDetector(
      onTap: onTakePictureButtonPressed,
      child: Container(
        height: 70,
        color: Colors.black,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text("返回", style: TextStyle(color: Colors.white)),
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: onTakePictureButtonPressed,
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 50)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        // title: const Text('拍照'),
      ),
      body: cameras == null
          ? Container(
              child: Center(
                child: Text("加載中..."),
              ),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: <Widget>[_cameraWidget(), _cameraButton()],
              ),
            ),
    );
  }
}
