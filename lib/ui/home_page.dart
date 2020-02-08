import 'package:coronavirus/api/http/http_api_repositories.dart';
import 'package:coronavirus/core/plugins/geo_location.dart';
import 'package:coronavirus/core/widgets/loader_container/loader_container.dart';
import 'package:coronavirus/core/widgets/rounded_button.dart';
import 'package:coronavirus/data/models/epidemic_situation_info_model.dart';
import 'package:coronavirus/ui/component/epidemic_situation_chart_info_view.dart';
import 'package:coronavirus/ui/component/epidemic_situation_foreign_info_view.dart';
import 'package:coronavirus/ui/component/epidemic_situation_map_info_view.dart';
import 'package:coronavirus/ui/component/epidemic_situation_statistics_info_view.dart';
import 'package:coronavirus/ui/component/epidemic_situation_timeline_info_view.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

typedef Future<bool> _GetEpidemicSituationInfo({bool isFirstLoad});

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _tabItemSources = [
    {'text': '疫情信息', 'icon': Icons.bug_report},
    {'text': '实时播报', 'icon': Icons.message}
  ];

  TabController _tabController;
  int _exitTime = 0, _tabSelectedIndex = -1;
  EpidemicSituationInfoModel _epidemicSituationInfo;

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
    _tabSelectedIndex = 0; //默认tab选中的索引为0
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    await _requestAppPermission(); //请求应用权限
  }

  Future<bool> getEpidemicSituationInfo({bool isFirstLoad = false}) async {
    var ret = await HttpApiRepositories.getCoronavirusSituationInfo();
    if (ret?.code == 0 && ret?.dataInfo != null) {
      _epidemicSituationInfo.data = ret.dataInfo;
      return true;
    }
    return false;
  }

  bool _onBackPressed() {
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - _exitTime >= 800) {
      _exitTime = currentTime;
      showToast('再按一次退出应用');
      return false;
    }
    return true;
  }

  @override
  void initState() {
    _initializer();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var epidemicSiuationInfo =
        Provider.of<EpidemicSituationInfoModel>(context, listen: true);
    if (_epidemicSituationInfo != epidemicSiuationInfo) {
      _epidemicSituationInfo = epidemicSiuationInfo;
      GeoLocation.getLocationInfo().then(
          (value) => _epidemicSituationInfo.locProvinceName = value.province);
      Future.microtask(() => getEpidemicSituationInfo(isFirstLoad: true));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async => _onBackPressed(),
      child: Scaffold(
          backgroundColor: const Color(0xfff5f5f5),
          appBar: _buildAppBar(),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildTabBarView(),
                Divider(height: 1, color: Color(0xfff0f0f0)),
                _buildTabBar((index) {
                  if (_tabSelectedIndex != index) {
                    _tabController.index = index;
                    setState(() => _tabSelectedIndex = index);
                  }
                })
              ])));

  Widget _buildAppBar() => AppBar(
      centerTitle: true,
      title: Column(children: [
        Text('全国疫情状况',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('数据来源：丁香园·丁香医生', style: TextStyle(fontSize: 8))
      ]),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.share))]);

  Widget _buildTabBar(void onTabSelectedChanged(int index)) => Container(
      color: Colors.white,
      child: Row(children: [
        for (var i = 0; i < _tabItemSources.length; i++)
          Expanded(
              child: RoundedButton(
                  onPressed: () => onTabSelectedChanged(i),
                  isMaterialEnabled: false,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(children: [
                    Icon(_tabItemSources[i]['icon'],
                        size: 26,
                        color: i == _tabSelectedIndex
                            ? Theme.of(context).primaryColor
                            : Colors.grey),
                    Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Text(_tabItemSources[i]['text'],
                            style: TextStyle(
                                fontSize: 10,
                                color: i == _tabSelectedIndex
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey)))
                  ])))
      ]));

  Widget _buildTabBarView() => Expanded(
          child: TabBarView(controller: _tabController, children: [
        _EpidemicSituationInfoFragment(
            getEpidemicSituationInfo: getEpidemicSituationInfo),
        _EpidemicSituationTimelineInfoFragment(
            getEpidemicSituationInfo: getEpidemicSituationInfo)
      ]));
}

class _EpidemicSituationInfoFragment extends StatefulWidget {
  _EpidemicSituationInfoFragment(
      {Key key, @required this.getEpidemicSituationInfo})
      : super(key: key);

  final _GetEpidemicSituationInfo getEpidemicSituationInfo;

  @override
  __EpidemicSituationInfoFragmentState createState() =>
      __EpidemicSituationInfoFragmentState();
}

class __EpidemicSituationInfoFragmentState
    extends State<_EpidemicSituationInfoFragment>
    with AutomaticKeepAliveClientMixin {
  LoaderState _loaderState = LoaderState.Loading;

  void initializer() {
    Future.microtask(() => _getEpidemicSituationInfo(isFirstLoad: true));
  }

  void _getEpidemicSituationInfo({bool isFirstLoad}) async {
    if (isFirstLoad == true) setState(() => _loaderState = LoaderState.Loading);
    bool isSuccessful =
        await widget.getEpidemicSituationInfo(isFirstLoad: isFirstLoad);
    setState(() =>
        _loaderState = isSuccessful ? LoaderState.Succeed : LoaderState.Error);
  }

  @override
  void initState() {
    initializer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<EpidemicSituationInfoModel>(
        builder: (_, data, __) => LoaderContainer(
            state: _loaderState,
            onReload: () => _getEpidemicSituationInfo(isFirstLoad: true),
            contentView: data == null ? Container() : _buildContentView(data)));
  }

  Widget _buildContentView(EpidemicSituationInfoModel data) => RefreshIndicator(
      onRefresh: () async => _getEpidemicSituationInfo(),
      child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            EpidemicSituationStatisticsInfoView(
                statisticsInfo: data.statisticsInfo,
                locAreaSituationInfo: data.locProvinceName != null &&
                        data?.areaSituationInfoList?.isNotEmpty == true
                    ? data?.areaSituationInfoList?.singleWhere((e) =>
                        data.locProvinceName.contains(e.provinceShortName))
                    : null),
            EpidemicSituationMapInfoView(
                locProvinceName: data.locProvinceName,
                situationInfo: data.data),
            EpidemicSituationChartInfoView(
                context: context, situationInfo: data.data),
            EpidemicSituationForeignInfoView(
                statisticsInfo: data.statisticsInfo,
                locAreaSituationInfo: data.locProvinceName != null &&
                        data?.areaSituationInfoList?.isNotEmpty == true
                    ? data?.areaSituationInfoList?.singleWhere((e) =>
                        data.locProvinceName.contains(e.provinceShortName))
                    : null,
                foreignSituationInfoList: data.foreignSituationInfoList)
          ])));

  @override
  bool get wantKeepAlive => true;
}

class _EpidemicSituationTimelineInfoFragment extends StatefulWidget {
  _EpidemicSituationTimelineInfoFragment(
      {Key key, @required this.getEpidemicSituationInfo})
      : super(key: key);

  final _GetEpidemicSituationInfo getEpidemicSituationInfo;

  @override
  __EpidemicSituationTimelineInfoFragmentState createState() =>
      __EpidemicSituationTimelineInfoFragmentState();
}

class __EpidemicSituationTimelineInfoFragmentState
    extends State<_EpidemicSituationTimelineInfoFragment>
    with AutomaticKeepAliveClientMixin {
  LoaderState _loaderState = LoaderState.Loading;

  void initializer() {
    Future.microtask(() => _getEpidemicSituationInfo(isFirstLoad: true));
  }

  void _getEpidemicSituationInfo({bool isFirstLoad}) async {
    if (isFirstLoad == true) setState(() => _loaderState = LoaderState.Loading);
    bool isSuccessful =
        await widget.getEpidemicSituationInfo(isFirstLoad: isFirstLoad);
    setState(() =>
        _loaderState = isSuccessful ? LoaderState.Succeed : LoaderState.Error);
  }

  @override
  void initState() {
    initializer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<EpidemicSituationInfoModel>(
        builder: (_, data, __) => LoaderContainer(
            state: _loaderState,
            onReload: () => _getEpidemicSituationInfo(isFirstLoad: true),
            contentView: data == null
                ? Container()
                : RefreshIndicator(
                    onRefresh: () async => _getEpidemicSituationInfo(),
                    child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: EpidemicSituationTimelineInfoView(
                            situationInfo: data.data)))));
  }

  @override
  bool get wantKeepAlive => true;
}
