
import 'package:coronavirus/core/widgets/loader_container/loader_container.dart';
import 'package:coronavirus/data/models/epidemic_situation_info_model.dart';
import 'package:coronavirus/ui/component/epidemic_situation_timeline_info_view.dart';
import 'package:coronavirus/ui/home_page.dart' show OnGetEpidemicSituationInfo;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EpidemicSituationTimelineInfoFragment extends StatefulWidget {
  EpidemicSituationTimelineInfoFragment(
      {Key key, @required this.getEpidemicSituationInfo})
      : super(key: key);

  final OnGetEpidemicSituationInfo getEpidemicSituationInfo;

  @override
  _EpidemicSituationTimelineInfoFragmentState createState() =>
      _EpidemicSituationTimelineInfoFragmentState();
}

class _EpidemicSituationTimelineInfoFragmentState
    extends State<EpidemicSituationTimelineInfoFragment>
    with AutomaticKeepAliveClientMixin {
  LoaderState _loaderState = LoaderState.Loading;

  void _initializer() =>
      Future.microtask(() => _getEpidemicSituationInfo(isFirstLoad: true));

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
            contentView: data?.data == null
                ? Container()
                : RefreshIndicator(
                    onRefresh: () async => _getEpidemicSituationInfo(),
                    child: EpidemicSituationTimelineInfoView(
                        situationInfo: data.data))));
  }

  @override
  bool get wantKeepAlive => true;
}
