// To parse this JSON data, do
//
//     final temple = templeFromJson(jsonString);

// ignore_for_file: file_names, avoid_dynamic_calls, inference_failure_on_untyped_parameter

import 'dart:convert';

Temple templeFromJson(String str) =>
    Temple.fromJson(json.decode(str) as Map<String, dynamic>);

String templeToJson(Temple data) => json.encode(data.toJson());

///
class Temple {
  Temple({
    required this.data,
  });

  factory Temple.fromJson(Map<String, dynamic> json) => Temple(
        data: Map.from(json['data'] as Map).map((k, v) =>
            MapEntry<String, List<Shrine>>(
                k.toString(),
                List<Shrine>.from(
                    v.map((x) => Shrine.fromJson(x as Map<String, dynamic>))
                        as Iterable))),
      );

  Map<String, List<Shrine>> data;

  Map<String, dynamic> toJson() => {
        'data': Map.from(data).map((k, v) => MapEntry<String, dynamic>(
            k.toString(),
            List<dynamic>.from(v.map((x) => x.toJson()) as Iterable))),
      };
}

///
class Shrine {
  Shrine({
    required this.date,
    required this.temple,
    required this.memo,
    required this.address,
    required this.station,
    this.gohonzon,
    required this.thumbnail,
    this.lat,
    this.lng,
    required this.photo,
  });

  factory Shrine.fromJson(Map<String, dynamic> json) => Shrine(
        date: DateTime.parse(json['date'].toString()),
        temple: json['temple'].toString(),
        memo: json['memo'].toString(),
        address: json['address'].toString(),
        station: json['station'].toString(),
        gohonzon: json['gohonzon'],
        photo: List<String>.from(json['photo'].map((x) => x) as Iterable),
        thumbnail: json['thumbnail'].toString(),
        lat: json['lat'],
        lng: json['lng'],
      );

  DateTime date;
  String temple;
  String memo;
  String address;
  String station;
  dynamic gohonzon;
  List<String> photo;
  String thumbnail;
  dynamic lat;
  dynamic lng;

  Map<String, dynamic> toJson() => {
        'date':
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        'temple': temple,
        'memo': memo,
        'address': address,
        'station': station,
        'gohonzon': gohonzon,
        'photo': List<dynamic>.from(photo.map((x) => x)),
        'thumbnail': thumbnail,
        'lat': lat,
        'lng': lng,
      };
}
