import 'package:coronavirus/core/widgets/china_province_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChinaProvinceViewController _chinaProvinceViewController;

  void _onChinaProvinceViewCreated(int viewId) {
    _chinaProvinceViewController = ChinaProvinceViewController(viewId)
      ..selectedBackgroundColor = Colors.blue.value;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('全国疫情状况')),
      body: SingleChildScrollView(
          child: Column(children: [_buildChinaMapView()])));

  Widget _buildChinaMapView() {
    return Container(
        margin: EdgeInsets.all(5),
        child: ChinaProvinceView(
            width: MediaQuery.of(context).size.width - 10,
            onViewCreated: _onChinaProvinceViewCreated));
  }

  @override
  void dispose() {
    _chinaProvinceViewController?.dispose();
    super.dispose();
  }
}
