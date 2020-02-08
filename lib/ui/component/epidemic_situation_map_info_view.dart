import 'package:coronavirus/core/widgets/china_province_view.dart';
import 'package:coronavirus/core/widgets/map_view.dart';
import 'package:coronavirus/core/widgets/rounded_button.dart';
import 'package:coronavirus/data/entities/epidemic_situation/area_situation_info.dart';
import 'package:coronavirus/data/entities/epidemic_situation/coronavirus_situation_info.dart';
import 'package:flutter/material.dart';

/// 行政区域的疫情情况视图
class EpidemicSituationMapInfoView extends StatefulWidget {
  EpidemicSituationMapInfoView(
      {Key key, @required this.locProvinceName, @required this.situationInfo})
      : super(key: key);
  final String locProvinceName;
  final CornonavirusSituationInfo situationInfo;

  @override
  _EpidemicSituationMapInfoViewState createState() =>
      _EpidemicSituationMapInfoViewState();
}

class _EpidemicSituationMapInfoViewState
    extends State<EpidemicSituationMapInfoView> {
  final _areaColorInfos = [
    {'text': '>=10000', 'min': 10000, 'color': Color(0xff551111)},
    {'text': '1000-9999', 'min': 1000, 'max': 9999, 'color': Color(0xff730111)},
    {'text': '500-999', 'min': 500, 'max': 999, 'color': Color(0xffc51111)},
    {'text': '100-499', 'min': 100, 'max': 499, 'color': Color(0xfffa5555)},
    {'text': '10-99', 'min': 10, 'max': 99, 'color': Colors.orange[300]},
    {'text': '1-9', 'min': 1, 'max': 9, 'color': Colors.orange[100]},
  ];

  // ChinaProvinceViewController _controller;
  GlobalKey<MapViewState> _mapViewKey = GlobalKey();
  double _touchX = 0.0, _touchY = 0.0;
  AreaSituationInfo _selectedAreaSituationInfo;

  void _initializer() {}

  Color _getAreaColorByConfirmedCount(int count) {
    var ret = _areaColorInfos.firstWhere((e) {
      int min = e['min'] as int;
      int max = e['max'] as int;
      if (max == null && count >= min) //只有最小，没有最大
        return true;
      return count >= min && count <= max;
    });
    if (ret != null) return ret['color'];
    return Colors.transparent;
  }

  @override
  void didUpdateWidget(EpidemicSituationMapInfoView oldWidget) {
    var areaColorInfoParams = Map<String, Color>();
    widget.situationInfo.areaSituationInfoList.forEach((e) =>
        areaColorInfoParams[e.provinceShortName] =
            _getAreaColorByConfirmedCount(e.confirmed));
    _mapViewKey?.currentState?.setProvincesColors(areaColorInfoParams);
    super.didUpdateWidget(oldWidget);
  }

  // void _onChinaProvinceViewCreated(ChinaProvinceViewController controller) {
  //   _controller = controller
  //     ..selectedBackgroundColor = Colors.blue.value
  //     ..onProvinceSelectedChanged = (String value, double tx, double ty) {
  //       setState(() {
  //         _touchX = tx;
  //         _touchY = ty;
  //         _selectedAreaSituationInfo = value == null || value.isEmpty
  //             ? null
  //             : widget.situationInfo.areaSituationInfoList.firstWhere(
  //                 (element) => element.provinceShortName.contains(value));
  //       });
  //     };
  //   var areaColorInfoParams = Map<String, dynamic>();
  //   widget.situationInfo.areaSituationInfoList.forEach((e) =>
  //       areaColorInfoParams[e.provinceShortName] =
  //           _getAreaColorByConfirmedCount(e.confirmed).value);
  //   _controller.provincesBackgroundColors = areaColorInfoParams;
  //   Future.delayed(const Duration(seconds: 1),
  //       () => _controller.selectedProvinceByName = widget.locProvinceName);
  // }

  @override
  void initState() {
    _initializer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Stack(children: [
        Container(
          margin: EdgeInsets.only(left: 8, right: 8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white),
          child: MapView(
              key: _mapViewKey,
              vectorAssetName: 'assets/vectors/ic_map_china.xml',
              width: MediaQuery.of(context).size.width - 32,
              selectedBackgroundColor: Colors.blue),
          /* ChinaProvinceView(
                width: MediaQuery.of(context).size.width - 32,
                onViewCreated: _onChinaProvinceViewCreated) */
        ),
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
          .map((e) => Padding(
              padding: EdgeInsets.only(top: 3),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: e['color'],
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(e['text'], style: TextStyle(fontSize: 9)))
              ])))
          .toList());

  Widget _buildAreaInfoPopView() => RoundedButton(
      onPressed: () {},
      padding: EdgeInsets.all(5),
      color: const Color(0xb8000000),
      borderRadius: BorderRadius.circular(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('省份：${_selectedAreaSituationInfo.provinceShortName}',
            style: TextStyle(fontSize: 11, color: Colors.white)),
        Text('确诊：${_selectedAreaSituationInfo.confirmed}',
            style: TextStyle(fontSize: 11, color: Colors.white)),
        Text('死亡：${_selectedAreaSituationInfo.dead}',
            style: TextStyle(fontSize: 11, color: Colors.white)),
      ]));

  // @override
  // void dispose() {
  //   _controller?.dispose();
  //   super.dispose();
  // }
}
