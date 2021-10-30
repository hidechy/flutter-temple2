// ignore_for_file: file_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'dart:convert';

import '../models/Temple.dart';

import '../utility/Utility.dart';
//import '../utility/MapUtil.dart';

import 'PhotoDisplayScreen.dart';

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

  late GoogleMapController _googleMapController;

  late LatLngBounds bounds;
  List<PointLatLng> polylinePoints = [];
  String distance = '';
  String duration = '';

  bool _canDispPolyline = false;
  bool _dispPolyline = false;

  String origin = '';

  ///
  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    origin = '35.7102009,139.9490672';

    ///////////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/getDateTemple";
    String body = json.encode({"date": widget.date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    final temple = templeFromJson(response.body);
    _templeMaps = temple.data;
    ///////////////////////////////////

    //------------------//
    _utility.makeYMDYData(widget.date.toString());
    String destination =
        '${_templeMaps[_utility.year]![0].lat},${_templeMaps[_utility.year]![0].lng}';

    String apiKey = 'AIzaSyD9PkTM1Pur3YzmO-v4VzS0r8ZZ0jRJTIU';
    String url2 =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=walking&language=ja&key=$apiKey';
    Response response2 = await get(Uri.parse(url2));

    _canDispPolyline = false;
    if (response2.statusCode == 200) {
      var decoded = jsonDecode(response2.body);

      var data = decoded['routes'][0];

      final _sw = data['bounds']['southwest'];
      final southwest = LatLng(_sw['lat'], _sw['lng']);
      final _ne = data['bounds']['northeast'];
      final northeast = LatLng(_ne['lat'], _ne['lng']);
      bounds = LatLngBounds(southwest: southwest, northeast: northeast);

      if ((data['legs'] as List).isNotEmpty) {
        final leg = data['legs'][0];
        distance = leg['distance']['text'];
        duration = leg['duration']['text'];
      }

      polylinePoints =
          PolylinePoints().decodePolyline(data['overview_polyline']['points']);

      _canDispPolyline = true;
    }
    //------------------//

    setState(() {
      _isLoading = true;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(widget.date.toString());

    if (_isLoading) {
      var exOrigin = (origin).split(',');

      _markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: LatLng(
            double.parse(exOrigin[0]),
            double.parse(exOrigin[1]),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );

      _latLng = LatLng(
        double.parse(_templeMaps[_utility.year]![0].lat),
        double.parse(_templeMaps[_utility.year]![0].lng),
      );

      _initialCameraPosition = CameraPosition(
        target: _latLng,
        zoom: 15,
        tilt: 50.0,
      );

      _markers.add(
        Marker(
          markerId: const MarkerId('distination'),
          position: _latLng,
          infoWindow: InfoWindow(title: _templeMaps[_utility.year]![0].temple),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
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
                  height: (_isEnlarge) ? (size.height - 350) : 220,
                  child: GoogleMap(
                    onMapCreated: (controller) =>
                        _googleMapController = controller,
                    markers: _markers,
                    initialCameraPosition: _initialCameraPosition,
                    polylines: {
                      if (_dispPolyline)
                        Polyline(
                          polylineId: const PolylineId('overview_polyline'),
                          color: Colors.redAccent,
                          width: 10,
                          points: polylinePoints
                              .map((e) => LatLng(e.latitude, e.longitude))
                              .toList(),
                        ),
                    },
                  ),
                ),
                //------------------------------// Map

                const SizedBox(height: 10),

                Text(_templeMaps[_utility.year]![0].address),
                Text(_templeMaps[_utility.year]![0].station),
                Text(distance),

                Row(
                  children: [
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
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: const Icon(
                          Icons.flag,
                          color: Colors.red,
                        ),
                        onTap: () => _backFlagPosition(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: const Icon(
                          Icons.vignette_rounded,
                          color: Colors.red,
                        ),
                        onTap: () => _googleMapController.animateCamera(
                          CameraUpdate.newLatLngBounds(bounds, 100),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: const Icon(
                          Icons.stacked_line_chart,
                          color: Colors.red,
                        ),
                        onTap: () => _polylineDisp(),
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
  void _mapEnlarge() {
    setState(() {
      _isEnlarge = !_isEnlarge;

      _backFlagPosition();
    });
  }

  ///
  void _backFlagPosition() {
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(_initialCameraPosition),
    );
  }

  ///
  void _polylineDisp() {
    setState(() {
      _dispPolyline = !_dispPolyline;
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
