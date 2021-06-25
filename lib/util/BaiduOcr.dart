import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_study/http/DioManager.dart';
import 'package:flutter_study/util/Encode.dart';

enum IMAGE_TYPE {
  URL,
  IMAGE,
}

enum OCR_TYPE { BASE, IDCARD, BANKCARD, FORM }

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

  static void accurateBasic(
      String path, IMAGE_TYPE imgType, Function successCallBack) {
    String url = "https://aip.baidubce.com/rest/2.0/ocr/v1/accurate_basic";

    FormData formData = FormData.from({
      "access_token": token,
      "language_type": "CHN_ENG",
      "detect_direction": "true",
      // "paragraph": "true",
      // "probability": "true"
    });

    if (imgType == IMAGE_TYPE.IMAGE) {
      EncodeUtil.image2Base64(path).then((data) {
        String imageBase64 = data;

        formData.add("image", imageBase64);
        DioManager.getInstance().post(url, formData, successCallBack, (error) {
          print("网络异常，请稍后重试");
        });
      });
    } else if ((imgType == IMAGE_TYPE.URL)) {
      formData.add("url", path);
      DioManager.getInstance().post(url, formData, successCallBack, (error) {
        print("网络异常，请稍后重试");
      });
    }
    // return "";
  }

  static void idCard(path, Function successCallBack) {
    String url = "https://aip.baidubce.com/rest/2.0/ocr/v1/idcard";
    FormData formData = FormData.from({
      "access_token": token,
      "id_card_side": "front",
      "detect_direction": "true",
      "detect_risk": "false",
      "detect_photo": "true"
    });

    EncodeUtil.image2Base64(path).then((data) {
      String imageBase64 = data;

      formData.add("image", imageBase64);
      DioManager.getInstance().post(url, formData, successCallBack, (error) {
        print("网络异常，请稍后重试");
      });
    });
    // return "";
  }

  static String accurateBasicUrl(String imgUrl) {
    String url = "https://aip.baidubce.com/rest/2.0/ocr/v1/accurate_basic";
    // print("accurateBasice " + token);
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

  static void bankCard(path, Function successCallBack) {
    String url = "https://aip.baidubce.com/rest/2.0/ocr/v1/bankcard";
    FormData formData = FormData.from({
      "access_token": token,
      "detect_direction": "true",
    });

    EncodeUtil.image2Base64(path).then((data) {
      String imageBase64 = data;

      formData.add("image", imageBase64);
      DioManager.getInstance().post(url, formData, successCallBack, (error) {
        print("网络异常，请稍后重试");
      });
    });
    // return "";
  }

  static void form(path, Function successCallBack) {
    String url = "https://aip.baidubce.com/rest/2.0/ocr/v1/form";
    FormData formData = FormData.from({
      "access_token": token,
      "table_border": "true",
    });

    EncodeUtil.image2Base64(path).then((data) {
      String imageBase64 = data;

      formData.add("image", imageBase64);
      DioManager.getInstance().post(url, formData, successCallBack, (error) {
        print("网络异常，请稍后重试");
      });
    });
    // return "";
  }
}
