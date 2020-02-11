import 'package:coronavirus/core/widgets/loader_container/loader_container.dart';
import 'package:coronavirus/core/widgets/map_view.dart';
import 'package:coronavirus/data/models/epidemic_situation_info_model.dart';
import 'package:coronavirus/ui/component/epidemic_situation_chart_info_view.dart';
import 'package:coronavirus/ui/component/epidemic_situation_foreign_info_view.dart';
import 'package:coronavirus/ui/component/epidemic_situation_map_info_view.dart';
import 'package:coronavirus/ui/component/epidemic_situation_statistics_info_view.dart';
import 'package:coronavirus/ui/home_page.dart' show OnGetEpidemicSituationInfo;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EpidemicSituationInfoFragment extends StatefulWidget {
  EpidemicSituationInfoFragment(
      {Key key, @required this.getEpidemicSituationInfo})
      : super(key: key);

  final OnGetEpidemicSituationInfo getEpidemicSituationInfo;

  @override
  _EpidemicSituationInfoFragmentState createState() =>
      _EpidemicSituationInfoFragmentState();
}

class _EpidemicSituationInfoFragmentState
    extends State<EpidemicSituationInfoFragment>
    with AutomaticKeepAliveClientMixin {
  LoaderState _loaderState = LoaderState.Loading;
  MapInfo _mapInfo; //地图数据

  void _initializer() async {
    _mapInfo = await getMapInfoByVectorXmlAsset(
        context, 'assets/vectors/ic_map_china.xml');
    Future.microtask(() => _getEpidemicSituationInfo(isFirstLoad: true));
  }

  /// 获取疫情信息
  /// * [isFirstLoad] - 是否是首次加载
  void _getEpidemicSituationInfo({bool isFirstLoad}) async {
    if (isFirstLoad == true) setState(() => _loaderState = LoaderState.Loading);
    bool isSuccessful =
        await widget.getEpidemicSituationInfo(isFirstLoad: isFirstLoad);
    setState(() =>
        _loaderState = isSuccessful ? LoaderState.Succeed : LoaderState.Error);
  }

  @override
  void initState() {
    _initializer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<EpidemicSituationInfoModel>(
        builder: (_, data, __) => LoaderContainer(
            state: _loaderState,
            onReload: () => _getEpidemicSituationInfo(isFirstLoad: true),
            contentView: _buildContentView(data)));
  }

  Widget _buildContentView(EpidemicSituationInfoModel data) {
    if (data?.data == null) return Container();
    return RefreshIndicator(
        onRefresh: () async => _getEpidemicSituationInfo(),
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EpidemicSituationStatisticsInfoView(
                      statisticsInfo: data.statisticsInfo,
                      locAreaSituationInfo: data.locAreaSituationInfo),
                  EpidemicSituationMapInfoView(
                      mapInfo: _mapInfo, situationInfo: data.data),
                  EpidemicSituationChartInfoView(
                      context: context, situationInfo: data.data),
                  EpidemicSituationForeignInfoView(
                      statisticsInfo: data.statisticsInfo,
                      foreignSituationInfoList: data.foreignSituationInfoList)
                ])));
  }

  @override
  bool get wantKeepAlive => true;
}
