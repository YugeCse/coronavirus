import 'package:coronavirus/core/widgets/loader_container/loader_container.dart';
import 'package:coronavirus/data/entities/epidemic_situation/situation_statistics_info.dart';
import 'package:coronavirus/data/models/epidemic_situation_info_model.dart';
import 'package:coronavirus/ui/home_page.dart' show OnGetEpidemicSituationInfo;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EpidemicSituationKnowledgeInfoFragment extends StatefulWidget {
  EpidemicSituationKnowledgeInfoFragment(
      {Key key, @required this.getEpidemicSituationInfo})
      : super(key: key);

  final OnGetEpidemicSituationInfo getEpidemicSituationInfo;

  @override
  _EpidemicSituationKnowledgeInfoFragmentState createState() =>
      _EpidemicSituationKnowledgeInfoFragmentState();
}

class _EpidemicSituationKnowledgeInfoFragmentState
    extends State<EpidemicSituationKnowledgeInfoFragment>
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
    return Consumer<EpidemicSituationInfoModel>(builder: (_, data, __) {
      SituationStatisticsInfo statisticsInfo = data?.statisticsInfo;
      List<String> remarks = [
        statisticsInfo?.remark1,
        statisticsInfo?.remark2,
        statisticsInfo?.remark3,
        statisticsInfo?.remark4,
        statisticsInfo?.remark5
      ].where((e) => e?.trim()?.isNotEmpty == true).toList();
      List<String> notes = [
        statisticsInfo?.note1,
        statisticsInfo?.note2,
        statisticsInfo?.note3
      ].where((e) => e?.trim()?.isNotEmpty == true).toList();
      return LoaderContainer(
          state: _loaderState,
          onReload: () => _getEpidemicSituationInfo(isFirstLoad: true),
          contentView: data?.data == null
              ? Container()
              : RefreshIndicator(
                  onRefresh: () async => _getEpidemicSituationInfo(),
                  child: ListView(padding: EdgeInsets.all(8), children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: remarks.length,
                          itemBuilder: (_, position) => Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(remarks[position],
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black))),
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: Color(0xfff5f5f5)),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: notes.length,
                          itemBuilder: (_, position) => Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(notes[position],
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black))),
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: Color(0xfff5f5f5)),
                        ))
                  ])));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
