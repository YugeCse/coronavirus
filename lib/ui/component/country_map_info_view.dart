import 'package:coronavirus/core/widgets/china_province_view.dart';
import 'package:coronavirus/data/entities/epidemic_situation/area_situation_info.dart';
import 'package:coronavirus/data/entities/epidemic_situation/coronavirus_situation_info.dart';
import 'package:flutter/material.dart';

/// 行政区域的疫情情况视图
class CountryMapInfoView extends StatefulWidget {
  CountryMapInfoView({Key key, @required this.situationInfo})
      : super(key: key);

  final CornonavirusSituationInfo situationInfo;

  @override
  _CountryMapInfoViewState createState() => _CountryMapInfoViewState();
}

class _CountryMapInfoViewState extends State<CountryMapInfoView> {
  final _areaColorInfos = [
    {'text': '500及以上', 'color': Colors.red[900]},
    {'text': '100-499', 'color': Colors.deepOrange},
    {'text': '10-99', 'color': Colors.orange[300]},
    {'text': '1-9', 'color': Colors.orange[100]},
  ];

  ChinaProvinceViewController _chinaProvinceViewController;
  double _touchX = 0.0, _touchY = 0.0;
  AreaSituationInfo _selectedAreaSituationInfo;

  int _getAreaColorByConfirmedCount(int count) {
    if (count >= 500)
      return Colors.red[900].value;
    else if (count >= 100 && count < 500)
      return Colors.deepOrange.value;
    else if (count >= 10 && count < 99)
      return Colors.orange[300].value;
    else if (count >= 1 && count < 9)
      return Colors.orange[100].value;
    else
      return Colors.transparent.value;
  }

  void _onChinaProvinceViewCreated(int viewId) {
    _chinaProvinceViewController = ChinaProvinceViewController(viewId)
      ..selectedBackgroundColor = Colors.blue.value
      ..onProvinceSelectedChanged = (String value, double tx, double ty) {
        setState(() {
          _touchX = tx;
          _touchY = ty;
          _selectedAreaSituationInfo = value == null || value.isEmpty
              ? null
              : widget.situationInfo.areaSituationInfoList.firstWhere(
                  (element) => element.provinceShortName.contains(value));
        });
      };
    var areaColorInfoParams = Map<String, dynamic>();
    widget.situationInfo.areaSituationInfoList.forEach((e) =>
        areaColorInfoParams[e.provinceShortName] =
            _getAreaColorByConfirmedCount(e.confirmed));
    _chinaProvinceViewController.provincesBackgroundColors =
        areaColorInfoParams;
  }

  @override
  Widget build(BuildContext context) => Stack(children: [
        Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white),
            child: ChinaProvinceView(
                width: MediaQuery.of(context).size.width - 32,
                onViewCreated: _onChinaProvinceViewCreated)),
        Positioned(
            left: 16,
            top: 8,
            child: Text('全国概况',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        Positioned(left: 16, bottom: 8, child: _buildAreaColorInfoView()),
        Positioned(right: 16, bottom: 8, child: _buildSouthSeaIsLandsView()),
        if (_selectedAreaSituationInfo != null)
          Positioned(
              left: _touchX - 20,
              top: _touchY - 40 < 0 ? 0 : _touchY - 40,
              child: _buildAreaInfoPopView()),
      ]);

  Widget _buildSouthSeaIsLandsView() => Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300])),
      child: Column(children: [
        Image.asset('assets/images/ic_south_sea_islands.png', width: 30),
        Text('南海诸岛', style: TextStyle(fontSize: 5, color: Colors.black38))
      ]));

  Widget _buildAreaColorInfoView() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _areaColorInfos
          .map(
              (e) => Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Container(width: 14, height: 14, color: e['color']),
                    Padding(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        child: Text(e['text'], style: TextStyle(fontSize: 12)))
                  ]))
          .toList());

  Widget _buildAreaInfoPopView() => Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: const Color(0xb8000000),
          borderRadius: BorderRadius.circular(5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('省份：${_selectedAreaSituationInfo.provinceShortName}',
            style: TextStyle(fontSize: 11, color: Colors.white)),
        Text('确诊：${_selectedAreaSituationInfo.confirmed}',
            style: TextStyle(fontSize: 11, color: Colors.white)),
        Text('死亡：${_selectedAreaSituationInfo.dead}',
            style: TextStyle(fontSize: 11, color: Colors.white)),
      ]));

  @override
  void dispose() {
    _chinaProvinceViewController?.dispose();
    super.dispose();
  }
}
