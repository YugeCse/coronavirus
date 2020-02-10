import 'package:coronavirus/api/http/http_api_repositories.dart';
import 'package:coronavirus/core/plugins/geo_location.dart';
import 'package:coronavirus/core/widgets/rounded_button.dart';
import 'package:coronavirus/data/models/epidemic_situation_info_model.dart';
import 'package:coronavirus/ui/home/epidemic_situation_info_fragment.dart';
import 'package:coronavirus/ui/home/epidemic_situation_knowledge_info_fragment.dart';
import 'package:coronavirus/ui/home/epidemic_situation_timeline_info_fragment.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

typedef Future<bool> OnGetEpidemicSituationInfo({bool isFirstLoad});

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _tabItemSources = [
    {'text': '疫情信息', 'icon': 'assets/images/ic_virus.png'},
    {'text': '实时讯息', 'icon': 'assets/images/ic_news.png'},
    {'text': '常识知识', 'icon': 'assets/images/ic_knowledge.png'},
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
        showToast('获取定位权限失败，某些功能可能会受到限制');
    }
  }

  /// 初始化
  void _initializer() async {
    _tabSelectedIndex = 0; //默认tab选中的索引为0
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    await _requestAppPermission(); //请求应用权限
  }

  void _initAndLoadDataProvider() {
    var epidemicSiuationInfo =
        Provider.of<EpidemicSituationInfoModel>(context, listen: true);
    if (_epidemicSituationInfo != epidemicSiuationInfo) {
      _epidemicSituationInfo = epidemicSiuationInfo;
      GeoLocation.getLocationInfo().then(
          (value) => _epidemicSituationInfo.locProvinceName = value.province);
    }
  }

  Future<bool> _getEpidemicSituationInfo({bool isFirstLoad = false}) async {
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
    _initAndLoadDataProvider();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async => _onBackPressed(),
      child: Scaffold(
          backgroundColor: const Color(0xfff5f5f5),
          appBar: _buildAppBar(),
          body: _buildContentView()));

  Widget _buildAppBar() => AppBar(
      centerTitle: true,
      title: Column(children: [
        Text('冠状病毒(NCP)疫况',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('数据来源：丁香园·丁香医生', style: TextStyle(fontSize: 8))
      ]),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.share))]);

  Widget _buildContentView() => Column(
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
          ]);

  Widget _buildTabBar(void onTabSelectedChanged(int index)) => Container(
      color: Colors.white,
      child: Row(children: [
        for (var i = 0; i < _tabItemSources.length; i++)
          Expanded(
              child: RoundedButton(
                  onPressed: () => onTabSelectedChanged(i),
                  borderRadius: BorderRadius.zero,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(children: [
                    Image.asset(_tabItemSources[i]['icon'],
                        width: 26,
                        height: 26,
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
        EpidemicSituationInfoFragment(
            getEpidemicSituationInfo: _getEpidemicSituationInfo),
        EpidemicSituationTimelineInfoFragment(
            getEpidemicSituationInfo: _getEpidemicSituationInfo),
        EpidemicSituationKnowledgeInfoFragment(
            getEpidemicSituationInfo: _getEpidemicSituationInfo)
      ]));
}
