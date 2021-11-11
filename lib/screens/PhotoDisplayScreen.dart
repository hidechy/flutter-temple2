// ignore_for_file: file_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/Temple.dart';

import '../utility/Utility.dart';

class PhotoDisplayScreen extends StatefulWidget {
  final Shrine data;
  final String firstPhotoTime;

  PhotoDisplayScreen(
      {Key? key, required this.data, required this.firstPhotoTime})
      : super(key: key);

  @override
  _PhotoDisplayScreenState createState() => _PhotoDisplayScreenState();
}

class _PhotoDisplayScreenState extends State<PhotoDisplayScreen> {
  final Utility _utility = Utility();

  int _current = 0;

  String _photoTime = "";

  late Size size;

  ///
  @override
  void initState() {
    _photoTime = widget.firstPhotoTime;

    super.initState();
  }

  ///
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    var _listDate =
        '${widget.data.date.year.toString().padLeft(4, '0')}-${widget.data.date.month.toString().padLeft(2, '0')}-${widget.data.date.day.toString().padLeft(2, '0')}';

    return Scaffold(
      body: Stack(
        children: [
          _utility.getBackGround(),
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
              Text(_listDate),
              Text(
                widget.data.temple,
                style: const TextStyle(fontSize: 24),
              ),
              // (widget.data.gohonzon != "")
              //     ? Text(widget.data.gohonzon)
              //     : Container(),
              (widget.data.memo != "")
                  ? Text('(With) ${widget.data.memo}')
                  : Container(),
              Container(
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(color: Colors.red[900]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  _photoTime,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 470.0,
                  initialPage: 0,
                  enlargeCenterPage: true,
                  onPageChanged: (index, _) {
                    setState(
                      () {
                        _current = index;

                        _photoTime = _utility.makePhotoTime(
                            file: widget.data.photo[index], date: _listDate);
                      },
                    );
                  },
                ),
                items: widget.data.photo.map(
                  (imgUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    );
                  },
                ).toList(),
              ),
            ],
          ),
          _makeIndicator(),
        ],
      ),
    );
  }

  ///
  Widget _makeIndicator() {
    List<Widget> _list = [];

    var _photoNum = widget.data.photo.length;

    for (var i = 0; i < _photoNum; i++) {
      _list.add(
        Container(
          width: 20,
          height: 5,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: (_current == i) ? Colors.redAccent : Colors.grey,
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(child: Container()),
        Container(
          width: (size.width / 10 * 8),
          height: (size.height / 15),
          alignment: Alignment.topRight,
          child: Wrap(children: _list),
        ),
      ],
    );
  }
}
