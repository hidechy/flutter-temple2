// ignore_for_file: file_names

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/Temple.dart';

import '../utility/Utility.dart';

class PhotoDisplayScreen extends StatefulWidget {
  final Shrine data;
  final String firstPhotoTime;

  PhotoDisplayScreen({required this.data, required this.firstPhotoTime});

  @override
  _PhotoDisplayScreenState createState() => _PhotoDisplayScreenState();
}

class _PhotoDisplayScreenState extends State<PhotoDisplayScreen> {
  final Utility _utility = Utility();

  int _current = 0;

  String _photoTime = "";

  ///
  @override
  void initState() {
    _photoTime = widget.firstPhotoTime;

    super.initState();
  }

  ///
  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.all(10),
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
              (widget.data.gohonzon != "")
                  ? Text(widget.data.gohonzon)
                  : Container(),
              (widget.data.memo != "")
                  ? Text('With. ${widget.data.memo}')
                  : Container(),
              Container(
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(color: Colors.red[900]),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (_current == 0)
                        ? Icon(
                            Icons.forward,
                            color: Colors.white,
                          )
                        : Container(),
                    Text(
                      _photoTime,
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
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
          )
        ],
      ),
    );
  }
}
