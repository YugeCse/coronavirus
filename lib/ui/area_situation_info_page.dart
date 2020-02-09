import 'package:coronavirus/data/entities/epidemic_situation/area_situation_info.dart';
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

  final typeConfirmed = 1, typeSuspected = 2, typedCured = 3, typeDead = 4;

  @override
  Widget build(BuildContext context) => Material(
      type: MaterialType.transparency,
      child: Stack(alignment: Alignment.center, children: [
        GestureDetector(onTap: () => Navigator.pop(context, false)),
        Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHangingContainerView(),
              ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: (MediaQuery.of(context).size.height -
                              kToolbarHeight -
                              kBottomNavigationBarHeight) *
                          0.75),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [_buildContentView()]))),
            ])
      ]));

  Widget _buildContentView() => Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _buildAreaEpidemicSituationCitiesInfoView(),
      ]));

  Widget _buildHangingContainerView() => Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _buildTitleBarView(),
        Divider(height: 1, color: Color(0xfff0f0f0)),
        _buildTableHeaderView(),
        Divider(height: 1, color: Color(0xfff0f0f0)),
        _buildAreaEpidemicStuationStatisticsInfoView(),
        Divider(height: 1, color: Color(0xfff0f0f0))
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

  Widget _buildAreaEpidemicStuationStatisticsInfoView() => Padding(
      padding: EdgeInsets.all(8),
      child: Row(children: [
        _buildAreaNameRowItemView(
            widget.areaSituationInfo?.provinceShortName ?? ''),
        _buildItemView(typeConfirmed, 3, widget.areaSituationInfo.confirmed),
        _buildItemView(typeSuspected, 3, widget.areaSituationInfo.suspected),
        _buildItemView(typedCured, 2, widget.areaSituationInfo.cured),
        _buildItemView(typeDead, 2, widget.areaSituationInfo.dead),
      ]));

  Widget _buildAreaEpidemicSituationCitiesInfoView() =>
      widget.areaSituationInfo?.cityInfoList?.isNotEmpty == true
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.areaSituationInfo.cityInfoList
                  .map((itemInfo) => Padding(
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
                        _buildItemView(typeDead, 2, itemInfo.dead,
                            isCityData: true),
                      ])))
                  .toList())
          : Container();

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
