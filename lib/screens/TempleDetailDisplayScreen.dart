// ignore_for_file: file_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:convert';

import '../models/Temple.dart';

import '../utility/Utility.dart';

class TempleDetailDisplayScreen extends StatefulWidget {
  final String date;

  TempleDetailDisplayScreen({Key? key, required this.date}) : super(key: key);

  @override
  _TempleDetailDisplayScreenState createState() =>
      _TempleDetailDisplayScreenState();
}

class _TempleDetailDisplayScreenState extends State<TempleDetailDisplayScreen> {
  final Utility _utility = Utility();

  Map<String, String> headers = {'content-type': 'application/json'};

  Map<String, List<Shrine>> _templeMaps = {};

  bool _isLoading = false;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    ///////////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/getDateTemple";
    String body = json.encode({"date": widget.date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    final temple = templeFromJson(response.body);
    _templeMaps = temple.data;
    ///////////////////////////////////

    setState(() {
      _isLoading = true;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(widget.date.toString());

    return Scaffold(
      body: Stack(
        children: [
          _utility.getBackGround(),
          if (_isLoading)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                Container(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                Text(widget.date),

                Text(
                  _templeMaps[_utility.year]![0].temple,
                  style: const TextStyle(fontSize: 24),
                ),

                (_templeMaps[_utility.year]![0].gohonzon != "")
                    ? Text(_templeMaps[_utility.year]![0].gohonzon)
                    : Container(),

                (_templeMaps[_utility.year]![0].memo != "")
                    ? Text('With. ${_templeMaps[_utility.year]![0].memo}')
                    : Container(),

                Container(
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(color: Colors.red[900]),
                ),

                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _templeMaps[_utility.year]![0].lat,
                        _templeMaps[_utility.year]![0].lng,
                      ),
                      zoom: 15,
                    ),
                  ),
                ),

                Container(
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(color: Colors.red[900]),
                ),

                Text(_templeMaps[_utility.year]![0].address),
                Text(_templeMaps[_utility.year]![0].station),

                //
                //
                //
                // Text(_templeMaps[_utility.year]![0].lat.toString()),
                // Text(_templeMaps[_utility.year]![0].lng.toString()),
                //
                //
                //
              ],
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
