import 'package:coronavirus/core/widgets/rounded_button.dart';
import 'package:coronavirus/data/entities/epidemic_situation/foreign_situation_info.dart';
import 'package:coronavirus/data/entities/epidemic_situation/situation_statistics_info.dart';
import 'package:coronavirus/utils/time/datetime_util.dart';
import 'package:flutter/material.dart';

/// 疫情概况视图
class EpidemicSituationForeignInfoView extends StatefulWidget {
  EpidemicSituationForeignInfoView(
      {Key key,
      @required this.statisticsInfo,
      @required this.foreignSituationInfoList})
      : super(key: key);
  final SituationStatisticsInfo statisticsInfo;
  final List<ForeignSituationInfo> foreignSituationInfoList;

  @override
  _EpidemicSituationForeignInfoViewState createState() =>
      _EpidemicSituationForeignInfoViewState();
}

class _EpidemicSituationForeignInfoViewState
    extends State<EpidemicSituationForeignInfoView> {
  final _situationTitles = [
    {'name': '地区', 'flex': 2},
    {'name': '确诊', 'flex': 3},
    {'name': '疑似', 'flex': 3},
    {'name': '治愈', 'flex': 2},
    {'name': '死亡', 'flex': 2},
  ];

  final typeConfirmed = 1, typeSuspected = 2, typedCured = 3, typeDead = 4;
  bool _isMoreSituationInfoExpanded = true;

  @override
  void didUpdateWidget(EpidemicSituationForeignInfoView oldWidget) {
    if (oldWidget.foreignSituationInfoList != widget.foreignSituationInfoList)
      _isMoreSituationInfoExpanded = true;
    super.didUpdateWidget(oldWidget);
  }

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
        ..._buildEpidemicSituationStatisticsInfoViews()
      ]));

  Widget _buildTitleView() => Padding(
      padding: EdgeInsets.all(8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text('国外疫情',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                    '数据截至${widget.statisticsInfo.modifyTime.toDateString()}',
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
          {double textSize = 14, Color textColor}) =>
      Expanded(
          flex: 2,
          child: Text(name,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                  color: textColor)));

  List<Widget> _buildEpidemicSituationStatisticsInfoViews() => [
        ...widget.foreignSituationInfoList
            .take(_isMoreSituationInfoExpanded
                ? 5
                : widget.foreignSituationInfoList.length)
            .map((e) => Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildAreaNameRowItemView(e.name),
                      _buildItemView(typeConfirmed, 3, e.confirmed),
                      _buildItemView(typeSuspected, 3, e.suspected),
                      _buildItemView(typedCured, 2, e.cured),
                      _buildItemView(typeDead, 2, e.dead),
                    ])))
            .toList(),
        if (_isMoreSituationInfoExpanded == true)
          RoundedButton(
              onPressed: () =>
                  setState(() => _isMoreSituationInfoExpanded = false),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('点击查看更多',
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                    Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 12)
                  ]))
      ];

  Widget _buildItemView(int type, int flex, int value,
          {int incrValue, bool isCityData}) =>
      Expanded(
          flex: flex,
          child: Text(
              type == typeSuspected && value == 0 ? '---' : value.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: type == typeConfirmed
                      ? Colors.red[800]
                      : (type == typeSuspected
                          ? Colors.yellow[800]
                          : (type == typedCured
                              ? Colors.green[800]
                              : Colors.black)))));
}
