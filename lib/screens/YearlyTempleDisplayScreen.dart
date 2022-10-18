// ignore_for_file: file_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utility/Utility.dart';

class YearlyTempleDisplayScreen extends StatefulWidget {
  YearlyTempleDisplayScreen(
      {Key? key, required this.year, required this.marker})
      : super(key: key);
  final String year;
  final Set<Marker> marker;

  @override
  _YearlyTempleDisplayScreenState createState() =>
      _YearlyTempleDisplayScreenState();
}

class _YearlyTempleDisplayScreenState extends State<YearlyTempleDisplayScreen> {
  final Utility _utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    const _latLng = LatLng(35.7102009, 139.9490672);

    const _initialCameraPosition = CameraPosition(target: _latLng, zoom: 11);

    final itemCount = widget.marker.length;

    return Scaffold(
      body: Stack(
        children: [
          _utility.getBackGround(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.year,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        '（${itemCount.toString()}）',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
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
                ],
              ),

              //------------------------------// Map
              Expanded(
                child: GoogleMap(
                  markers: widget.marker,
                  initialCameraPosition: _initialCameraPosition,
                ),
              ),
              //------------------------------// Map
            ],
          ),
        ],
      ),
    );
  }
}
