import 'package:coronavirus/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
  _initSettings();
}

void _initSettings() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '全国疫情状况',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomePage());
  }
}
