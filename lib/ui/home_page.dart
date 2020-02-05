import 'package:coronavirus/api/http/http_api_repositories.dart';
import 'package:coronavirus/core/plugins/location_plugin.dart';
import 'package:coronavirus/core/widgets/loader_container/loader_container.dart';
import 'package:coronavirus/data/entities/epidemic_situation/coronavirus_situation_info.dart';
import 'package:coronavirus/ui/component/country_map_info_view.dart';
import 'package:coronavirus/ui/component/epidemic_situation_info_view.dart';
import 'package:coronavirus/ui/component/epidemic_situation_timeline_info_view.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LoaderState _loaderState = LoaderState.Loading;
  CornonavirusSituationInfo _situationInfo;
  String _locProvinceName; //当前定位到的省份位置

  /// 请求应用权限
  Future<void> _requestAppPermission() async {
    var locPerRet = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    var rwPerRet = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (locPerRet != PermissionStatus.granted ||
        rwPerRet != PermissionStatus.granted) {
      var result = await PermissionHandler().requestPermissions(
          [PermissionGroup.location, PermissionGroup.storage]);
      if (result[PermissionGroup.location] != PermissionStatus.granted)
        showToast('请求应用权限失败，应用的某些功能会受到限制');
    }
  }

  /// 初始化
  void _initializer() async {
    await _requestAppPermission(); //请求应用权限
    Future.microtask(() => getEpidemicSituationInfo(isFirstLoad: true));
    LocationPlugin.getLocationInfo()
        .then((value) => setState(() => _locProvinceName = value.province));
  }

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
    _initializer();
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
            locAreaSituationInfo: _situationInfo.areaSituationInfoList != null
                ? _situationInfo.areaSituationInfoList.firstWhere((e) =>
                    _locProvinceName != null &&
                    _locProvinceName.contains(e.provinceShortName))
                : null),
        CountryMapInfoView(
            locProvinceName: _locProvinceName, situationInfo: _situationInfo),
        EpidemicSituationTimelineInfoView(situationInfo: _situationInfo)
      ]));
}
