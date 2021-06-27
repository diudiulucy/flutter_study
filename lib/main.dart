import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_study/pages/album.dart';
import 'package:flutter_study/pages/camera.dart';
import 'package:flutter_study/pages/login/LoginPage.dart';
import 'package:flutter_study/pages/login/auth_serivice.dart';
import 'package:flutter_study/pages/login/login_page.dart';
import 'package:flutter_study/pages/login/sign_up.dart';
import 'package:flutter_study/pages/toolbar.dart';
import 'package:flutter_study/pages/picselect.dart';
import 'package:flutter_study/test/newroute.dart';
import 'package:flutter_study/test/tiproute.dart';
import 'package:flutter_study/util/BaiduOcr.dart';
import 'package:flutter_study/util/themeutil.dart';

import 'pages/camera/camera_flow.dart';
import 'pages/login/verification_page.dart';

List<CameraDescription> cameras;

void main() async {
  //camera必须添加下面main()函数中的第一行,否则报错 WidgetsFlutterBinding是框架和flutter引擎之间的胶水
  WidgetsFlutterBinding.ensureInitialized();
  // 获取可用摄像头列表，cameras为全局变量
  cameras = await availableCameras();

  SystemChrome.setPreferredOrientations(//设置屏幕的方向
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  BaiduOcr.initBaiduOcr();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();
  // final _amplify = Amplify();

  @override
  void initState() {
    super.initState();
    _authService.showLogin();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/", //名为"/"的路由作为应用的home(首页)
      theme: new ThemeData(
        primarySwatch: ThemeUtils.currentColorTheme,
      ),
      // 注册路由表
      routes: {
        "new_page": (context) => NewRoute(),
        "/": (context) => ToolBar(), //注册首页路由
        "tip2": (context) {
          return TipRoute(text: ModalRoute.of(context).settings.arguments);
        },
        "camera": (context) => WatermarkPhoto(),
        "album": (context) => Album(),
        "picselect": (context) => PickSelect(),
        "login": (context) => LoginPage(),
      },
      // home: StreamBuilder<AuthState>(
      //     // 2
      //     stream: _authService.authStateController.stream,
      //     builder: (context, snapshot) {
      //       // 3
      //       if (snapshot.hasData) {
      //         return Navigator(
      //           pages: [
      //             // 4
      //             // Show Login Page
      //             if (snapshot.data.authFlowStatus == AuthFlowStatus.login)
      //               MaterialPage(
      //                   child: LoginPage(
      //                       didProvideCredentials:
      //                           _authService.loginWithCredentials,
      //                       shouldShowSignUp: _authService.showSignUp)),
      //             // Show Verification Code Page
      //             if (snapshot.data.authFlowStatus ==
      //                 AuthFlowStatus.verification)
      //               MaterialPage(
      //                   child: VerificationPage(
      //                       didProvideVerificationCode:
      //                           _authService.verifyCode)),
      //             // Show Camera Flow
      //             if (snapshot.data.authFlowStatus == AuthFlowStatus.session)
      //               MaterialPage(
      //                   child: CameraFlow(shouldLogOut: _authService.logOut)),

      //             // 5
      //             // Show Sign Up Page
      //             if (snapshot.data.authFlowStatus == AuthFlowStatus.signUp)
      //               MaterialPage(
      //                   child: SignUpPage(
      //                       didProvideCredentials:
      //                           _authService.signUpWithCredentials,
      //                       shouldShowLogin: _authService.showLogin))
      //           ],
      //           onPopPage: (route, result) => route.didPop(result),
      //         );
      //       } else {
      //         // 6
      //         return Container(
      //           alignment: Alignment.center,
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //     }),
    );
  }
}
