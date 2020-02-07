import 'package:coronavirus/data/entities/epidemic_situation/area_situation_info.dart';
import 'package:coronavirus/data/entities/epidemic_situation/situation_statistics_info.dart';
import 'package:coronavirus/utils/time/datetime_util.dart';
import 'package:flutter/material.dart';

/// 疫情概况视图
class EpidemicSituationStatisticsInfoView extends StatefulWidget {
  EpidemicSituationStatisticsInfoView(
      {Key key,
      @required this.statisticsInfo,
      @required this.locAreaSituationInfo})
      : super(key: key);
  final SituationStatisticsInfo statisticsInfo;
  final AreaSituationInfo locAreaSituationInfo;

  @override
  _EpidemicSituationStatisticsInfoViewState createState() =>
      _EpidemicSituationStatisticsInfoViewState();
}

class _EpidemicSituationStatisticsInfoViewState
    extends State<EpidemicSituationStatisticsInfoView> {
  final _situationTitles = [
    {'name': '地区', 'flex': 2},
    {'name': '确诊', 'flex': 3},
    {'name': '疑似', 'flex': 3},
    {'name': '治愈', 'flex': 2},
    {'name': '死亡', 'flex': 2},
  ];

  final typeConfirmed = 1, typeSuspected = 2, typedCured = 3, typeDead = 4;
  bool _isCitySituationInfoExpanded = true;

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _buildTitleView(),
        Divider(color: const Color(0xfff5f5f5), height: 1),
        _buildTableHeaderView(),
        _buildEpidemicSituationStatisticsInfoView(),
        if (widget.locAreaSituationInfo != null)
          _buildLocAreaEpidemicSituationInfoView()
      ]));

  Widget _buildTitleView() => Padding(
      padding: EdgeInsets.all(8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text('实时疫情',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                    '数据截至于${widget.statisticsInfo.modifyTime.toDateString()}',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]))))
      ]));

  Widget _buildTableHeaderView() => Padding(
      padding: EdgeInsets.all(8),
      child: Row(
          children: _situationTitles
              .map((e) => Expanded(
                  flex: e['flex'],
                  child: Text(e['name'],
                      textAlign: e['name'] == '地区'
                          ? TextAlign.start
                          : TextAlign.center,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))))
              .toList()));

  Widget _buildAreaNameRowItemView(String name,
      {double textSize = 14, Color textColor, bool hasCities = false}) {
    var nameWidget = Text(name,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: textSize, fontWeight: FontWeight.bold, color: textColor));
    var retWidget = !hasCities
        ? nameWidget
        : Row(children: [
            nameWidget,
            Padding(
                padding: EdgeInsets.only(top: 3),
                child: Icon(
                    hasCities && !_isCitySituationInfoExpanded
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    size: 15))
          ]);
    return Expanded(flex: 2, child: retWidget);
  }

  Widget _buildEpidemicSituationStatisticsInfoView() => Padding(
      padding: EdgeInsets.all(8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        _buildAreaNameRowItemView('全国'),
        _buildItemView(typeConfirmed, 3, widget.statisticsInfo.confirmedCount,
            incrValue: widget.statisticsInfo.confirmedIncr),
        _buildItemView(typeSuspected, 3, widget.statisticsInfo.suspectedCount,
            incrValue: widget.statisticsInfo.suspectedIncr),
        _buildItemView(typedCured, 2, widget.statisticsInfo.curedCount,
            incrValue: widget.statisticsInfo.curedIncr),
        _buildItemView(typeDead, 2, widget.statisticsInfo.deadCount,
            incrValue: widget.statisticsInfo.deadIncr),
      ]));

  Widget _buildLocAreaEpidemicSituationInfoView() => Column(children: [
        InkWell(
            onTap: () => setState(() =>
                _isCitySituationInfoExpanded = !_isCitySituationInfoExpanded),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(children: [
                  _buildAreaNameRowItemView(
                      widget.locAreaSituationInfo?.provinceShortName ?? '',
                      hasCities: widget
                              .locAreaSituationInfo?.cityInfoList?.isNotEmpty ==
                          true),
                  _buildItemView(
                      typeConfirmed, 3, widget.locAreaSituationInfo.confirmed),
                  _buildItemView(
                      typeSuspected, 3, widget.locAreaSituationInfo.suspected),
                  _buildItemView(
                      typedCured, 2, widget.locAreaSituationInfo.cured),
                  _buildItemView(typeDead, 2, widget.locAreaSituationInfo.dead),
                ]))),
        if (widget.locAreaSituationInfo?.cityInfoList?.isNotEmpty == true &&
            !_isCitySituationInfoExpanded)
          for (var itemInfo in widget.locAreaSituationInfo.cityInfoList)
            Padding(
                padding: EdgeInsets.all(8),
                child: Row(children: [
                  _buildAreaNameRowItemView(itemInfo.cityName ?? '',
                      textSize: 13, textColor: Colors.grey[500]),
                  _buildItemView(typeConfirmed, 3, itemInfo.confirmed,
                      isCityData: true),
                  _buildItemView(typeSuspected, 3, itemInfo.suspected,
                      isCityData: true),
                  _buildItemView(typedCured, 2, itemInfo.cured,
                      isCityData: true),
                  _buildItemView(typeDead, 2, itemInfo.dead, isCityData: true),
                ]))
      ]);

  Widget _buildItemView(int type, int flex, int value,
          {int incrValue, bool isCityData}) =>
      Expanded(
          flex: flex,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(type == typeSuspected && value == 0 ? '---' : value.toString(),
                style: TextStyle(
                    fontSize: 16,
                    color: type == typeConfirmed
                        ? Colors.red[800]
                        : (type == typeSuspected
                            ? Colors.yellow[800]
                            : (type == typedCured
                                ? Colors.green[800]
                                : Colors.black)))),
            if (incrValue != null)
              Container(
                  margin: EdgeInsets.only(top: 3),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  decoration: BoxDecoration(
                      color: type == typeConfirmed
                          ? Colors.red[100]
                          : Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  child: Text('+$incrValue',
                      style: TextStyle(fontSize: 12, color: Colors.black)))
          ]));
}
