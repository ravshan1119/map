import 'dart:ui' as ui;

import 'package:flutter/services.dart';

const String adminEmail = "admin@gmail.com";

const defaultImageConstant = "Select Image";

const baseUrl = "https://geocode-maps.yandex.ru";
const String apiKey = "f11f7658-f825-420a-b044-c2e650161e29";

class TimeOutConstants {
  static int connectTimeout = 30;
  static int receiveTimeout = 25;
  static int sendTimeout = 60;
}

const List<String> kindList = [
  "house",
  "metro",
  "district",
  "street",
];

const List<String> langList = [
  "uz_UZ",
  "ru_RU",
  "en_GB",
  "tr_TR",
];



Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width,
  );
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}