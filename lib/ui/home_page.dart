import 'package:coronavirus/api/http/http_api_repositories.dart';
import 'package:coronavirus/core/widgets/china_province_view.dart';
import 'package:coronavirus/core/widgets/loader_container/loader_container.dart';
import 'package:coronavirus/data/entities/epidemic_situation/area_situation_info.dart';
import 'package:coronavirus/data/entities/epidemic_situation/coronavirus_situation_info.dart';
import 'package:coronavirus/data/entities/epidemic_situation/situation_statistics_info.dart';
import 'package:coronavirus/utils/time/datetime_util.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LoaderState _loaderState = LoaderState.Loading;
  CornonavirusSituationInfo _situationInfo;
  ChinaProvinceViewController _chinaProvinceViewController;
  AreaSituationInfo _selectedAreaSituationInfo;
  double _touchX = 0.0, _touchY = 0.0;

  void _onChinaProvinceViewCreated(int viewId) {
    _chinaProvinceViewController = ChinaProvinceViewController(viewId)
      ..selectedBackgroundColor = Colors.blue.value
      ..onProvinceSelectedChanged = (String value, double tx, double ty) {
        debugPrint('----->$value, $tx, $ty');
        var devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
        setState(() {
          _touchX = tx;
          _touchY = ty;
          _selectedAreaSituationInfo = value == null || value.isEmpty
              ? null
              : _situationInfo.areaSituationInfoList.firstWhere(
                  (element) => element.provinceShortName.contains(value));
        });
      };
  }

  void getEpidemicSituationInfo() async {
    setState(() => _loaderState = LoaderState.Loading);
    var result = await HttpApiRepositories.getCoronavirusSituationInfo();
    setState(() {
      _situationInfo = result.dataInfo;
      _loaderState = result.code == 0 ? LoaderState.Succeed : LoaderState.Error;
    });
  }

  @override
  void initState() {
    Future.microtask(getEpidemicSituationInfo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(title: Text('全国疫情状况'), centerTitle: true),
      body: _buildContentView());

  Widget _buildContentView() => LoaderContainer(
      state: _loaderState,
      onReload: getEpidemicSituationInfo,
      contentView: _situationInfo == null
          ? Container()
          : RefreshIndicator(
              onRefresh: () async => getEpidemicSituationInfo(),
              child: SingleChildScrollView(
                  child: Column(children: [
                _buildSituationInfoView(_situationInfo.statisticsInfo),
                Stack(children: [
                  Container(
                      margin: EdgeInsets.only(left: 8, right: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white),
                      child: GestureDetector(
                          child: ChinaProvinceView(
                              width: MediaQuery.of(context).size.width - 32,
                              onViewCreated: _onChinaProvinceViewCreated))),
                  if (_selectedAreaSituationInfo != null)
                    Positioned(
                        left: _touchX - 20,
                        top: _touchY - 40 < 0 ? 0 : _touchY - 40,
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: const Color(0xb8000000),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '省份：${_selectedAreaSituationInfo.provinceShortName}',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white)),
                                  Text(
                                      '确诊：${_selectedAreaSituationInfo.confirmed}',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white)),
                                  Text('死亡：${_selectedAreaSituationInfo.dead}',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white)),
                                ]))),
                ])
              ]))));

  Widget _buildSituationInfoView(SituationStatisticsInfo statisticsInfo) =>
      _SituationInfoView(
          title: '全国',
          updateTime: statisticsInfo.modifyTime,
          value: statisticsInfo.confirmedCount,
          incrValue: statisticsInfo.confirmedIncr,
          suspectedValue: statisticsInfo.suspectedCount,
          suspectedIncrValue: statisticsInfo.suspectedIncr,
          curedValue: statisticsInfo.curedCount,
          curedIncrValue: statisticsInfo.curedIncr,
          deadValue: statisticsInfo.deadCount,
          deadIncrValue: statisticsInfo.deadIncr);

  @override
  void dispose() {
    _chinaProvinceViewController?.dispose();
    super.dispose();
  }
}

class _SituationInfoView extends StatefulWidget {
  _SituationInfoView({
    Key key,
    this.title,
    this.updateTime,
    this.value,
    this.incrValue,
    this.suspectedValue,
    this.suspectedIncrValue,
    this.curedValue,
    this.curedIncrValue,
    this.deadValue,
    this.deadIncrValue,
  }) : super(key: key);

  final String title;
  final int updateTime;
  final int value;
  final int incrValue;
  final int suspectedValue;
  final int suspectedIncrValue;
  final int curedValue;
  final int curedIncrValue;
  final int deadValue;
  final int deadIncrValue;

  @override
  __SituationInfoViewState createState() => __SituationInfoViewState();
}

class __SituationInfoViewState extends State<_SituationInfoView> {
  final _situationTitles = [
    {'name': '地区', 'flex': 1},
    {'name': '确诊', 'flex': 2},
    {'name': '疑似', 'flex': 2},
    {'name': '治愈', 'flex': 2},
    {'name': '死亡', 'flex': 2},
  ];

  final int typeConfirmed = 1;
  final int typeSuspected = 2;
  final int typedCured = 3;
  final int typeDead = 4;

  Widget _buildItemView(int type, int value, int incrValue) => Expanded(
      flex: 2,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(value.toString(),
            style: TextStyle(
                fontSize: 16,
                color: type == typeConfirmed
                    ? Colors.red
                    : (type == typeSuspected
                        ? Colors.yellow[800]
                        : Colors.black))),
        Container(
            margin: EdgeInsets.only(top: 3),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            decoration: BoxDecoration(
                color:
                    type == typeConfirmed ? Colors.red[100] : Colors.grey[100],
                borderRadius: BorderRadius.all(Radius.circular(3))),
            child: Text('+$incrValue',
                style: TextStyle(fontSize: 12, color: Colors.black)))
      ]));

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
            padding: EdgeInsets.all(8),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text('实时疫情',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Text(widget.updateTime.toDateString(),
                          textAlign: TextAlign.end)))
            ])),
        Divider(color: const Color(0xfff5f5f5), height: 1),
        Padding(
            padding: EdgeInsets.all(8),
            child: Row(
                children: _situationTitles
                    .map((e) => Expanded(
                        flex: e['flex'],
                        child: Text(e['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))))
                    .toList())),
        Padding(
            padding: EdgeInsets.all(8),
            child: Row(children: [
              Expanded(
                  flex: 1,
                  child: Text('全国',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
              _buildItemView(typeConfirmed, widget.value, widget.incrValue),
              _buildItemView(typeSuspected, widget.suspectedValue,
                  widget.suspectedIncrValue),
              _buildItemView(
                  typedCured, widget.curedValue, widget.curedIncrValue),
              _buildItemView(typeDead, widget.deadValue, widget.deadIncrValue),
            ]))
      ]));
}
