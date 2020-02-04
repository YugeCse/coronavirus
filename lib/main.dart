import 'package:coronavirus/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  runApp(MyApp());
  _initSettings();
}

void _initSettings() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: '全国疫情状况',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OKToast(child: HomePage()));
}
