import 'package:coronavirus/data/entities/epidemic_situation/area_situation_info.dart';
import 'package:coronavirus/data/enums/human_state_type.dart';
import 'package:flutter/material.dart';

class AreaSituationInfoPage extends StatefulWidget {
  AreaSituationInfoPage({
    Key key,
    @required this.areaSituationInfo,
  }) : super(key: key);

  final AreaSituationInfo areaSituationInfo;

  @override
  _AreaSituationInfoPageState createState() => _AreaSituationInfoPageState();
}

class _AreaSituationInfoPageState extends State<AreaSituationInfoPage> {
  final _situationTitles = [
    {'name': '地区', 'flex': 2},
    {'name': '确诊', 'flex': 3},
    {'name': '疑似', 'flex': 3},
    {'name': '治愈', 'flex': 2},
    {'name': '死亡', 'flex': 2},
  ];

  @override
  Widget build(BuildContext context) => Material(
      type: MaterialType.transparency,
      child: Stack(alignment: Alignment.center, children: [
        GestureDetector(onTap: () => Navigator.pop(context, false)),
        Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHangingContainerView(),
                        _buildAreaEpidemicSituationCitiesInfoView(),
                        Container(
                            height: 8,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(5))))
                      ]))
            ])
      ]));

  Widget _buildHangingContainerView() => Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _buildTitleBarView(),
        _buildTableHeaderView(),
        _buildAreaEpidemicStuationRowItemView(
            widget.areaSituationInfo.provinceShortName,
            widget.areaSituationInfo.confirmed,
            widget.areaSituationInfo.suspected,
            widget.areaSituationInfo.cured,
            widget.areaSituationInfo.dead,
            isProvince: true),
      ]));

  Widget _buildTitleBarView() =>
      Stack(alignment: Alignment.center, fit: StackFit.loose, children: [
        Padding(
            padding: EdgeInsets.all(8),
            child: Text('${widget.areaSituationInfo.provinceShortName} 疫情信息',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        Positioned(
            right: 15,
            child: InkWell(
                onTap: () => Navigator.pop(context, false),
                child: Icon(Icons.close, color: Colors.grey[500], size: 20)))
      ]);

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

  Widget _buildAreaEpidemicSituationCitiesInfoView() =>
      widget.areaSituationInfo?.cityInfoList?.isNotEmpty == true
          ? Container(
              constraints: BoxConstraints(
                  maxHeight: (MediaQuery.of(context).size.height -
                          kToolbarHeight -
                          kBottomNavigationBarHeight) *
                      0.75),
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: widget.areaSituationInfo.cityInfoList
                          .map((itemInfo) =>
                              _buildAreaEpidemicStuationRowItemView(
                                  itemInfo.cityName,
                                  itemInfo.confirmed,
                                  itemInfo.suspected,
                                  itemInfo.cured,
                                  itemInfo.dead,
                                  isProvince: false))
                          .toList())))
          : Container();

  Widget _buildAreaEpidemicStuationRowItemView(
          String cityName, int confirmed, int suspected, int cured, int dead,
          {bool isProvince = true}) =>
      Padding(
          padding: EdgeInsets.all(8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            _buildAreaNameColumnItemView(cityName,
                textSize: isProvince ? 14 : 13,
                textColor: isProvince ? Colors.black : Colors.grey[500]),
            _buildColumnItemView(HumanStateType.Confirmed, 3, confirmed),
            _buildColumnItemView(HumanStateType.Suspected, 3, suspected),
            _buildColumnItemView(HumanStateType.Cured, 2, cured),
            _buildColumnItemView(HumanStateType.Dead, 2, dead),
          ]));

  Widget _buildAreaNameColumnItemView(String name,
          {double textSize = 14, Color textColor}) =>
      Expanded(
          flex: 2,
          child: Text(name,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                  color: textColor)));

  Widget _buildColumnItemView(HumanStateType type, int flex, int value,
          {int incrValue, bool isCityData}) =>
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
