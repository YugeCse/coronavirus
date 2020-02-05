import 'package:coronavirus/data/entities/epidemic_situation/coronavirus_situation_info.dart';
import 'package:coronavirus/data/entities/epidemic_situation/timeline_info.dart';
import 'package:coronavirus/utils/time/datetime_util.dart';
import 'package:flutter/material.dart';

class EpidemicSituationTimelineInfoView extends StatelessWidget {
  const EpidemicSituationTimelineInfoView({
    Key key,
    @required CornonavirusSituationInfo situationInfo,
  })  : _situationInfo = situationInfo,
        super(key: key);

  final CornonavirusSituationInfo _situationInfo;

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
            padding: EdgeInsets.all(8),
            child: Text('实时播报',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        Divider(color: const Color(0xfff5f5f5), height: 1),
        Container(
            margin: EdgeInsets.all(8),
            child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, position) => _buildTimelineItemView(
                    _situationInfo.timelineInfoList[position]),
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: const Color(0xfff5f5f5)),
                itemCount: _situationInfo.timelineInfoList?.length ?? 0))
      ]));

  Widget _buildTimelineItemView(TimeLineInfo itemInfo) => Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(itemInfo.title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(itemInfo.summary,
                style: TextStyle(color: Colors.grey[600]))),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              child: Text('来源：${itemInfo.infoSource}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]))),
          Text('发布时间：${itemInfo.modifyTime.toDateString()}',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]))
        ])
      ]));
}
