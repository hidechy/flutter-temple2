// To parse this JSON data, do
//
//     final templeSearch = templeSearchFromJson(jsonString);

// ignore_for_file: avoid_dynamic_calls, inference_failure_on_untyped_parameter

import 'dart:convert';

TempleSearch templeSearchFromJson(String str) =>
    TempleSearch.fromJson(json.decode(str) as Map<String, dynamic>);

String templeSearchToJson(TempleSearch data) => json.encode(data.toJson());

class TempleSearch {
  TempleSearch({
    required this.data,
  });

  factory TempleSearch.fromJson(Map<String, dynamic> json) => TempleSearch(
        data: List<SearchData>.from(json['data']
                .map((x) => SearchData.fromJson(x as Map<String, dynamic>))
            as Iterable),
      );

  List<SearchData> data;

  Map<String, dynamic> toJson() => {
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SearchData {
  SearchData({
    required this.year,
    required this.month,
    required this.day,
    required this.data,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        year: json['year'].toString(),
        month: json['month'].toString(),
        day: json['day'].toString(),
        data: List<TempleData>.from(json['data']
                .map((x) => TempleData.fromJson(x as Map<String, dynamic>))
            as Iterable),
      );

  String year;
  String month;
  String day;
  List<TempleData> data;

  Map<String, dynamic> toJson() => {
        'year': year,
        'month': month,
        'day': day,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TempleData {
  TempleData({
    required this.temple,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory TempleData.fromJson(Map<String, dynamic> json) => TempleData(
        temple: json['temple'].toString(),
        address: json['address'].toString(),
        lat: json['lat'].toString(),
        lng: json['lng'].toString(),
      );

  String temple;
  String address;
  String lat;
  String lng;

  Map<String, dynamic> toJson() => {
        'temple': temple,
        'address': address,
        'lat': lat,
        'lng': lng,
      };
}
