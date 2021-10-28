// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Utility {
  /// 日付データ作成
  late String year;
  late String month;
  late String day;
  late String youbi;
  late String youbiStr;
  late int youbiNo;

  void makeYMDYData(String date) {
    List explodedDate = date.split(' ');
    List explodedSelectedDate = explodedDate[0].split('-');
    year = explodedSelectedDate[0];
    month = explodedSelectedDate[1];
    day = explodedSelectedDate[2];

    DateTime youbiDate =
        DateTime(int.parse(year), int.parse(month), int.parse(day));
    youbi = DateFormat('EEEE').format(youbiDate);
    switch (youbi) {
      case "Sunday":
        youbiStr = "日";
        youbiNo = 0;
        break;
      case "Monday":
        youbiStr = "月";
        youbiNo = 1;
        break;
      case "Tuesday":
        youbiStr = "火";
        youbiNo = 2;
        break;
      case "Wednesday":
        youbiStr = "水";
        youbiNo = 3;
        break;
      case "Thursday":
        youbiStr = "木";
        youbiNo = 4;
        break;
      case "Friday":
        youbiStr = "金";
        youbiNo = 5;
        break;
      case "Saturday":
        youbiStr = "土";
        youbiNo = 6;
        break;
    }
  }

  /// 背景取得
  Widget getBackGround() {
    return Image.asset(
      'assets/images/bg.png',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      color: Colors.black.withOpacity(0.7),
      colorBlendMode: BlendMode.darken,
    );
  }

  ///
  String makePhotoTime({required String file, required String date}) {
    String time = "";

    var exFilePath = (file).split('/');
    var fileName = exFilePath[exFilePath.length - 1];
    var exFileName = fileName.split('.');
    var exDateTime = exFileName[0].split('_');
    if (exDateTime[1].length == 9) {
      var hour = exDateTime[1].substring(0, 2);
      var minute = exDateTime[1].substring(2, 4);
      time = '${hour}:${minute}';
    }

    return time;
  }
}
