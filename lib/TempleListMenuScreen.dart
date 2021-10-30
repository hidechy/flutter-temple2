// ignore_for_file: file_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'models/Temple.dart';

import 'utility/Utility.dart';

import 'TempleListScreen.dart';

class TempleListMenuScreen extends StatefulWidget {
  final String year;

  TempleListMenuScreen({Key? key, required this.year}) : super(key: key);

  @override
  _TempleListMenuScreenState createState() => _TempleListMenuScreenState();
}

class _TempleListMenuScreenState extends State<TempleListMenuScreen> {
  final Utility _utility = Utility();

  final List<String> _yearsList = [];

  Map<String, String> headers = {'content-type': 'application/json'};

  Map<String, List<Shrine>> _templeMaps = {};

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    _utility.makeYMDYData(DateTime.now().toString());
    String _maxYear = _utility.year;

    for (int i = int.parse(_maxYear); i >= 2014; i--) {
      _yearsList.add(i.toString());
    }

    ///////////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/getAllTemple";
    Response response = await post(Uri.parse(url), headers: headers);
    final temple = templeFromJson(response.body);
    _templeMaps = temple.data;
    ///////////////////////////////////

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.topLeft,
              child: const Text(
                'Year Select',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  var _shirineCount = (_templeMaps[_yearsList[index]] != null)
                      ? _templeMaps[_yearsList[index]]!.length
                      : 0;

                  return Card(
                    color: (_yearsList[index] == widget.year)
                        ? Colors.red[900]
                        : Colors.white.withOpacity(0.2),
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(_yearsList[index],
                              style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 10),
                          Text(
                            '（$_shirineCount）',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      onTap: () => _goTempleListScreen(year: _yearsList[index]),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 0.2),
                itemCount: _yearsList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///////////////////////////////////////

  ///
  void _goTempleListScreen({required String year}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TempleListScreen(
          year: year,
        ),
      ),
    );
  }
}
