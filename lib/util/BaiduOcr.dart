import 'package:dio/dio.dart';
import 'package:flutter_study/http/DioManager.dart';

class BaiduOcr {
  static String tokenUrl = "https://aip.baidubce.com/oauth/2.0/token";
  static String token = "";
  static String apiKey = "l40T5erM8mnvjvNdgSjLqubt";
  static String secretKey = "o82euZbmUYXqO2GnwNPawlTgIQ1VYP4L";
  static initBaiduOcr() async {
    FormData formData = FormData.from({
      "grant_type": "client_credentials",
      "client_id": apiKey,
      "client_secret": secretKey
    });

    DioManager.getInstance().post(tokenUrl, formData, (data) {
      token = data['access_token'];
    }, (error) {
      print("网络异常，请稍后重试");
    });
  }

  static String accurateBasic(String imgUrl) {
    String url = "https://aip.baidubce.com/rest/2.0/ocr/v1/accurate_basic";
    print("accurateBasice" + token);
    FormData formData = FormData.from({
      "access_token": token,
      "url": imgUrl,
      "language_type": "CHN_ENG",
      "detect_direction": "true",
      "paragraph": "true",
      "probability": "true"
    });

    DioManager.getInstance().post(url, formData, (data) {
      print(data.toString());
      return data.toString();
    }, (error) {
      print("网络异常，请稍后重试");
    });

    return "";
  }
}
