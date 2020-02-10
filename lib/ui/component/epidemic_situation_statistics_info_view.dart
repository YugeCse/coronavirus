import 'package:coronavirus/data/entities/epidemic_situation/area_situation_info.dart';
import 'package:coronavirus/data/entities/epidemic_situation/situation_statistics_info.dart';
import 'package:coronavirus/data/enums/human_state_type.dart';
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
          _buildLocAreaEpidemicSituationInfoView(),
        _buildFooterView()
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

  Widget _buildEpidemicSituationStatisticsInfoView() =>
      _buildAreaEpidemicStuationRowItemView(
          '全国',
          widget.statisticsInfo.confirmedCount,
          widget.statisticsInfo.suspectedCount,
          widget.statisticsInfo.curedCount,
          widget.statisticsInfo.deadCount,
          confirmedIncr: widget.statisticsInfo.confirmedIncr,
          suspectedIncr: widget.statisticsInfo.suspectedIncr,
          curedIncr: widget.statisticsInfo.curedIncr,
          deadIncr: widget.statisticsInfo.deadIncr,
          isProvince: true,
          hasCities: false);

  Widget _buildLocAreaEpidemicSituationInfoView() => Column(children: [
        InkWell(
            onTap: () => setState(() =>
                _isCitySituationInfoExpanded = !_isCitySituationInfoExpanded),
            child: _buildAreaEpidemicStuationRowItemView(
                widget.locAreaSituationInfo.provinceShortName,
                widget.locAreaSituationInfo.confirmed,
                widget.locAreaSituationInfo.suspected,
                widget.locAreaSituationInfo.cured,
                widget.locAreaSituationInfo.dead,
                isProvince: true,
                hasCities:
                    widget.locAreaSituationInfo.cityInfoList?.isNotEmpty ==
                        true)),
        if (widget.locAreaSituationInfo?.cityInfoList?.isNotEmpty == true &&
            !_isCitySituationInfoExpanded)
          for (var itemInfo in widget.locAreaSituationInfo.cityInfoList)
            _buildAreaEpidemicStuationRowItemView(
                itemInfo.cityName,
                itemInfo.confirmed,
                itemInfo.suspected,
                itemInfo.cured,
                itemInfo.dead,
                isProvince: false,
                hasCities: false)
      ]);

  Widget _buildFooterView() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Text('*  ${widget.statisticsInfo.generalRemark}',
          style: TextStyle(fontSize: 10, color: Colors.grey[400])));

  Widget _buildAreaEpidemicStuationRowItemView(
          String cityName, int confirmed, int suspected, int cured, int dead,
          {int confirmedIncr,
          int suspectedIncr,
          int curedIncr,
          int deadIncr,
          bool isProvince = true,
          bool hasCities = true}) =>
      Padding(
          padding: EdgeInsets.all(8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            _buildAreaNameColumnItemView(cityName,
                textSize: isProvince ? 14 : 13,
                textColor: isProvince ? Colors.black : Colors.grey[500],
                hasCities: hasCities),
            _buildColumnItemView(HumanStateType.Confirmed, 3, confirmed,
                incrValue: confirmedIncr),
            _buildColumnItemView(HumanStateType.Suspected, 3, suspected,
                incrValue: suspectedIncr),
            _buildColumnItemView(HumanStateType.Cured, 2, cured,
                incrValue: curedIncr),
            _buildColumnItemView(HumanStateType.Dead, 2, dead,
                incrValue: deadIncr)
          ]));

  Widget _buildAreaNameColumnItemView(String name,
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

  Widget _buildColumnItemView(HumanStateType type, int flex, int value,
          {int incrValue}) =>
      Expanded(
          flex: flex,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
                type == HumanStateType.Suspected && value == 0
                    ? '---'
                    : value.toString(),
                style: TextStyle(
                    fontSize: 16,
                    color: type == HumanStateType.Confirmed
                        ? Colors.red[800]
                        : (type == HumanStateType.Suspected
                            ? Colors.yellow[800]
                            : (type == HumanStateType.Cured
                                ? Colors.green[800]
                                : Colors.black)))),
            if (incrValue != null)
              Container(
                  margin: EdgeInsets.only(top: 3),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  decoration: BoxDecoration(
                      color: type == HumanStateType.Confirmed
                          ? Colors.red[100]
                          : Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  child: Text('+$incrValue',
                      style: TextStyle(fontSize: 12, color: Colors.black)))
          ]));
}
