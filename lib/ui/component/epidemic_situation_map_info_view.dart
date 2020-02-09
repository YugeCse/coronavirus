import 'package:coronavirus/core/widgets/map_view.dart';
import 'package:coronavirus/core/widgets/rounded_button.dart';
import 'package:coronavirus/data/entities/epidemic_situation/area_situation_info.dart';
import 'package:coronavirus/data/entities/epidemic_situation/coronavirus_situation_info.dart';
import 'package:coronavirus/ui/area_situation_info_page.dart';
import 'package:flutter/material.dart';

/// 行政区域的疫情情况视图
class EpidemicSituationMapInfoView extends StatefulWidget {
  EpidemicSituationMapInfoView({
    Key key,
    @required this.mapInfo,
    @required this.locProvinceName,
    @required this.situationInfo,
  }) : super(key: key);
  final MapInfo mapInfo;
  final String locProvinceName;
  final CornonavirusSituationInfo situationInfo;

  @override
  _EpidemicSituationMapInfoViewState createState() =>
      _EpidemicSituationMapInfoViewState();
}

class _EpidemicSituationMapInfoViewState
    extends State<EpidemicSituationMapInfoView> {
  final _areaColorInfos = [
    {'text': '>=10000', 'min': 10000, 'color': Color(0xff401111)},
    {'text': '1000-9999', 'min': 1000, 'max': 9999, 'color': Color(0xff730111)},
    {'text': '500-999', 'min': 500, 'max': 999, 'color': Color(0xffc51111)},
    {'text': '100-499', 'min': 100, 'max': 499, 'color': Color(0xfffa5555)},
    {'text': '10-99', 'min': 10, 'max': 99, 'color': Colors.orange[300]},
    {'text': '1-9', 'min': 1, 'max': 9, 'color': Colors.orange[100]},
  ];

  double _touchX = 0.0, _touchY = 0.0;
  AreaSituationInfo _selectedAreaSituationInfo;
  Map<String, Color> _mapAreaBackgroundRenderParams;

  void _initializer() {
    _mapAreaBackgroundRenderParams = _getMapAreaBackgroundRenderParams();
  }

  Map<String, Color> _getMapAreaBackgroundRenderParams() {
    var renderParams = Map<String, Color>();
    widget.situationInfo.areaSituationInfoList.forEach((e) {
      renderParams[e.provinceShortName] =
          _getAreaColorByConfirmedCount(e.confirmed);
    });
    return renderParams;
  }

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

  void _onSelectedAreaChanged(AreaInfo info, double mapScale) {
    setState(() {
      _selectedAreaSituationInfo = info != null
          ? widget.situationInfo?.areaSituationInfoList?.singleWhere(
              (e) => info.name.contains(e.provinceShortName),
              orElse: () => null)
          : null;
      if (info != null) {
        _touchX = info.bounds.center.dx * mapScale;
        _touchY = info.bounds.center.dy * mapScale;
      }
    });
  }

  @override
  void initState() {
    _initializer();
    super.initState();
  }

  @override
  void didUpdateWidget(EpidemicSituationMapInfoView oldWidget) {
    if (oldWidget.situationInfo != widget.situationInfo)
      _mapAreaBackgroundRenderParams = _getMapAreaBackgroundRenderParams();
    super.didUpdateWidget(oldWidget);
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
                mapInfo: widget.mapInfo,
                width: MediaQuery.of(context).size.width - 32,
                selectedBackgroundColor: Colors.blue,
                backgroundRenderParams: _mapAreaBackgroundRenderParams,
                onSelectedAreaChanged: _onSelectedAreaChanged)),
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
              top: _touchY - 40 < 0 ? 8 : _touchY - 40,
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
      onPressed: () => showDialog(
          context: context,
          child: AreaSituationInfoPage(
              areaSituationInfo: _selectedAreaSituationInfo)),
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
}
