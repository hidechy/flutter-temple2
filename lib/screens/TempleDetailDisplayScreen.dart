// ignore_for_file: file_names, prefer_const_constructors_in_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_temple2/screens/PhotoDisplayScreen.dart';
import 'package:http/http.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:convert';

import '../models/Temple.dart';

import '../utility/Utility.dart';
//import '../utility/MapUtil.dart';

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

  final Set<Marker> _markers = {};

  late CameraPosition _initialCameraPosition;

  late LatLng _latLng;

  bool _isEnlarge = false;

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

    if (_isLoading) {
      _latLng = LatLng(
        double.parse(_templeMaps[_utility.year]![0].lat),
        double.parse(_templeMaps[_utility.year]![0].lng),
      );

      _initialCameraPosition = CameraPosition(target: _latLng, zoom: 15);
    }

    Size size = MediaQuery.of(context).size;

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
                  padding: const EdgeInsets.all(10),
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

                //------------------------------// Map
                SizedBox(
                  height: (_isEnlarge) ? (size.height - 300) : 250,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    markers: _markers,
                    initialCameraPosition: _initialCameraPosition,
                  ),
                ),
                //------------------------------// Map

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_templeMaps[_utility.year]![0].address),
                          Text(_templeMaps[_utility.year]![0].station),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: const Icon(
                          Icons.center_focus_strong,
                          color: Colors.red,
                        ),
                        onTap: () => _mapEnlarge(),
                      ),
                    ),
                  ],
                ),

                Container(
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(color: Colors.red[900]),
                ),

                /////////////////////////// photo
                (_isEnlarge)
                    ? Container()
                    : Column(
                        children: [
                          Container(
                            height: 100,
                            margin: const EdgeInsets.only(top: 20),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 70,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          _templeMaps[_utility.year]![0]
                                              .photo[index]),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 0.2),
                              itemCount:
                                  _templeMaps[_utility.year]![0].photo.length,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20, right: 10),
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () => _goPhotoDisplayScreen(
                                  data: _templeMaps[_utility.year]![0]),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: const Text('Gallery'),
                              ),
                            ),
                          ),
                        ],
                      ),

                /////////////////////////// photo
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

  ///
  void _onMapCreated(GoogleMapController controller) {
//    controller.setMapStyle(MapUtil.mapStyle);

    _utility.makeYMDYData(widget.date.toString());

    setState(
      () {
        _markers.add(
          Marker(
            markerId: const MarkerId('id-01'),
            position: _latLng,
            infoWindow:
                InfoWindow(title: _templeMaps[_utility.year]![0].temple),
          ),
        );
      },
    );
  }

  ///
  void _mapEnlarge() {
    setState(() {
      _isEnlarge = !_isEnlarge;
    });
  }

  //////////////////////////////////
  ///
  void _goPhotoDisplayScreen({required Shrine data}) {
    _utility.makeYMDYData(data.date.toString());
    var date = '${_utility.year}-${_utility.month}-${_utility.day}';

    var firstPhotoTime =
        _utility.makePhotoTime(file: data.photo[0], date: date);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoDisplayScreen(
          data: data,
          firstPhotoTime: firstPhotoTime,
        ),
      ),
    );
  }
}
