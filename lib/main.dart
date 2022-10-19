import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'TempleListScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //画面向き指定
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp, //縦固定
    ],
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temple List',
      theme: ThemeData(brightness: Brightness.dark),
      home: const TempleListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
