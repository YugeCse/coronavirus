import 'package:coronavirus/api/http/http_api_repositories.dart';
import 'package:coronavirus/core/widgets/loader_container/loader_container.dart';
import 'package:coronavirus/data/entities/epidemic_situation/coronavirus_situation_info.dart';
import 'package:coronavirus/ui/component/country_map_info_view.dart';
import 'package:coronavirus/ui/component/epidemic_situation_info_view.dart';
import 'package:coronavirus/ui/component/epidemic_situation_timeline_info_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LoaderState _loaderState = LoaderState.Loading;
  CornonavirusSituationInfo _situationInfo;

  void getEpidemicSituationInfo({bool isFirstLoad = false}) async {
    if (isFirstLoad) setState(() => _loaderState = LoaderState.Loading);
    var result = await HttpApiRepositories.getCoronavirusSituationInfo();
    setState(() {
      _situationInfo = result.dataInfo;
      _loaderState = result.code == 0 ? LoaderState.Succeed : LoaderState.Error;
    });
  }

  @override
  void initState() {
    Future.microtask(() => getEpidemicSituationInfo(isFirstLoad: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
          title: Column(children: [
            Text('全国疫情状况'),
            Text('数据来源：丁香园', style: TextStyle(fontSize: 8))
          ]),
          centerTitle: true),
      body: LoaderContainer(
          state: _loaderState,
          onReload: getEpidemicSituationInfo,
          contentView: _situationInfo == null
              ? Container()
              : RefreshIndicator(
                  onRefresh: () async => getEpidemicSituationInfo(),
                  child: _buildContentView())));

  Widget _buildContentView() => SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        EpidemicSituationInfoView(
            statisticsInfo: _situationInfo.statisticsInfo,
            areaSituationInfos: _situationInfo.areaSituationInfoList),
        CountryMapInfoView(situationInfo: _situationInfo),
        EpidemicSituationTimelineInfoView(situationInfo: _situationInfo)
      ]));
}
