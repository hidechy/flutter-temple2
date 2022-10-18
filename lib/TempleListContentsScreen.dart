// ignore_for_file: file_names, prefer_const_constructors_in_immutables, directives_ordering, avoid_dynamic_calls, inference_failure_on_untyped_parameter

import 'package:flutter/material.dart';
import 'package:flutter_temple2/screens/YearlyTempleDisplayScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

import 'dart:math';
import 'dart:convert';

import 'models/Temple.dart';

import 'utility/Utility.dart';

import 'screens/TempleDetailDisplayScreen.dart';

import 'controllers/TempleAnimationController.dart';

class TempleListContentsScreen extends StatefulWidget {
  TempleListContentsScreen({Key? key, required this.year}) : super(key: key);
  final String year;

  @override
  _TempleListContentsScreenState createState() =>
      _TempleListContentsScreenState();
}

class _TempleListContentsScreenState extends State<TempleListContentsScreen> {
  final Utility _utility = Utility();

  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;

  Map<String, String> headers = {'content-type': 'application/json'};

  Map<String, List<Shrine>> _templeMaps = {};

  bool _isLoading = false;

  final Set<Marker> _markerSets = {};

  dynamic _latLngMap;

  final TempleAnimationController _controller = TempleAnimationController();

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  Future<void> _makeDefaultDisplayData() async {
    ///////////////////////////////////
    const url2 = 'http://toyohide.work/BrainLog/api/getTempleLatLng';
    final response2 = await post(Uri.parse(url2), headers: headers);
    final tll = jsonDecode(response2.body);
    _latLngMap = tll['data'];
    ///////////////////////////////////

    ///////////////////////////////////
    const url = 'http://toyohide.work/BrainLog/api/getAllTemple';
    final response = await post(Uri.parse(url), headers: headers);
    final temple = templeFromJson(response.body);
    _templeMaps = temple.data;
    ///////////////////////////////////

    //--------------------------// marker
    for (var i = 0; i < _templeMaps[widget.year]!.length; i++) {
      _markerSets.add(
        Marker(
          markerId: MarkerId('id-$i'),
          position: LatLng(
            double.parse(_templeMaps[widget.year]![i].lat.toString()),
            double.parse(_templeMaps[widget.year]![i].lng.toString()),
          ),
          infoWindow: InfoWindow(
            title: _templeMaps[widget.year]![i].temple,
            snippet: _templeMaps[widget.year]![i].address,
          ),
        ),
      );

      if (_templeMaps[widget.year]![i].memo != '') {
        _addWithTempleMarkers(memo: _templeMaps[widget.year]![i].memo);
      }
    }
    //--------------------------// marker

    setState(() {
      _isLoading = true;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final _shirineList = _templeMaps[widget.year];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 2000),
      transform: Matrix4.translationValues(
        xOffset,
        yOffset,
        0,
      )..rotateZ(isDrawerOpen ? (pi / 60) : 0),
      curve: Curves.elasticIn,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            isDrawerOpen ? BorderRadius.circular(40) : BorderRadius.circular(0),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            _utility.getBackGround(),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              _controller.updateDrawerOpen();

                              if (isDrawerOpen) {
                                setState(() {
                                  xOffset = 0;
                                  yOffset = 0;
                                  isDrawerOpen = false;
                                });
                              } else {
                                setState(() {
                                  xOffset = size.width - 200;
                                  yOffset = size.height / 10;
                                  isDrawerOpen = true;
                                });
                              }
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 3000),
                              switchInCurve: Curves.easeInOutBack,
                              transitionBuilder: (child, animation) =>
                                  ScaleTransition(
                                      scale: animation, child: child),
                              child: (_controller.isDrawerOpen)
                                  ? const Icon(Icons.arrow_back,
                                      size: 40, key: ValueKey('close'))
                                  : const Icon(Icons.arrow_forward,
                                      size: 40, key: ValueKey('open')),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _goYearyTempleDisplayScreen,
                              icon: const Icon(Icons.map),
                            ),
                            Text(
                              widget.year,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(color: Colors.red[900]),
                    ),
                    _templeList(context, _shirineList),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ///
  Widget _templeList(BuildContext context, _shirineList) {
    return Expanded(
      child: _isLoading
          ? MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final _listDate =
                      '${_shirineList![index].date.year.toString().padLeft(4, '0')}-${_shirineList[index].date.month.toString().padLeft(2, '0')}-${_shirineList[index].date.day.toString().padLeft(2, '0')}';

                  return Card(
                    color: Colors.black.withOpacity(0.3),
                    child: ListTile(
                      leading: SizedBox(
                        width: 40,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/no_image.png',
                          image: _shirineList[index].thumbnail.toString(),
                        ),
                      ),
                      title: DefaultTextStyle(
                        style: const TextStyle(fontSize: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_listDate),
                            Text(_shirineList[index].temple.toString()),
                            (_shirineList[index].memo != '')
                                ? Text('(With) ${_shirineList[index].memo}')
                                : Container(),
                          ],
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: () =>
                            _goTempleDetailDisplayScreen(date: _listDate),
                        child: const Icon(
                          Icons.call_made,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 0.2),
                itemCount: int.parse(_shirineList!.length.toString()),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  ///
  void _addWithTempleMarkers({required String memo}) {
    final exMemo = memo.split('、');
    for (var i = 0; i < exMemo.length; i++) {
      if (_latLngMap[exMemo[i]] != null) {
        final _latLng_ = LatLng(
          double.parse(_latLngMap[exMemo[i]][0]['lat'].toString()),
          double.parse(_latLngMap[exMemo[i]][0]['lng'].toString()),
        );

        _markerSets.add(
          Marker(
            markerId: MarkerId('memo$i'),
            position: _latLng_,
            infoWindow: InfoWindow(
              title: exMemo[i],
              snippet: '${_latLngMap[exMemo[i]][0]['address']}',
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          ),
        );
      }
    }
  }

  ///////////////////////////////////////

  ///
  void _goTempleDetailDisplayScreen({required String date}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TempleDetailDisplayScreen(
          date: date,
        ),
      ),
    );
  }

  ///
  void _goYearyTempleDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YearlyTempleDisplayScreen(
          year: widget.year,
          marker: _markerSets,
        ),
      ),
    );
  }
}
