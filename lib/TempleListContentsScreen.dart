// ignore_for_file: file_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'dart:math';

import 'models/Temple.dart';

import 'utility/Utility.dart';

class TempleListContentsScreen extends StatefulWidget {
  final String year;

  TempleListContentsScreen({Key? key, required this.year}) : super(key: key);

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

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    ///////////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/getAllTemple";
    Response response = await post(Uri.parse(url), headers: headers);
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
    Size size = MediaQuery.of(context).size;

    List<Shrine>? _shirineList = _templeMaps[widget.year];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.translationValues(
        xOffset,
        yOffset,
        0,
      )..rotateZ((isDrawerOpen) ? (pi / 20) : 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: (isDrawerOpen)
            ? BorderRadius.circular(40)
            : BorderRadius.circular(0),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            _utility.getBackGround(),
            Column(
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        child: const Icon(Icons.menu),
                        onTap: () {
                          if (isDrawerOpen) {
                            setState(() {
                              xOffset = 0;
                              yOffset = 0;
                              isDrawerOpen = false;
                            });
                          } else {
                            setState(() {
                              xOffset = (size.width - 200);
                              yOffset = (size.height / 10);
                              isDrawerOpen = true;
                            });
                          }
                        },
                      ),
                    ),
                    Text(
                      widget.year,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Container(
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(color: Colors.red[900]),
                ),
                Expanded(
                  child: (_isLoading)
                      ? MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              var _listDate =
                                  '${_shirineList![index].date.year.toString().padLeft(4, '0')}-${_shirineList[index].date.month.toString().padLeft(2, '0')}-${_shirineList[index].date.day.toString().padLeft(2, '0')}';

                              return Card(
                                color: Colors.black.withOpacity(0.3),
                                child: ListTile(
                                  leading: Container(
                                    width: 40,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            _shirineList[index].thumbnail),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  title: DefaultTextStyle(
                                    style: const TextStyle(fontSize: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_listDate),
                                        Text(_shirineList[index].temple),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 0.2),
                            itemCount: _shirineList!.length,
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
