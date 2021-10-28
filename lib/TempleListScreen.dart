// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import 'utility/Utility.dart';

import 'TempleListContentsScreen.dart';
import 'TempleListMenuScreen.dart';

class TempleListScreen extends StatefulWidget {
  final String? year;

  const TempleListScreen({this.year});

  @override
  _TempleListScreenState createState() => _TempleListScreenState();
}

class _TempleListScreenState extends State<TempleListScreen> {
  final Utility _utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(DateTime.now().toString());
    String _selectedYear =
        (widget.year == null) ? _utility.year : '${widget.year}';

    return Scaffold(
      body: Stack(
        children: [
          TempleListMenuScreen(year: _selectedYear),
          TempleListContentsScreen(year: _selectedYear),
        ],
      ),
    );
  }
}
