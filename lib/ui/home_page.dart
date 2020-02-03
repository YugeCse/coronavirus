import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('全国疫情状况')),
      body: SingleChildScrollView(
          child: Column(children: [_buildChinaMapView()])));

  Widget _buildChinaMapView() {
    return Container();
  }
}
